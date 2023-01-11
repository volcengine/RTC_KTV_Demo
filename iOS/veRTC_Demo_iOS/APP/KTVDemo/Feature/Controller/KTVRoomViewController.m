//
//  KTVRoomViewController.m
//  veRTC_Demo
//
//  Created by on 2021/5/18.
//  
//

#import "KTVRoomViewController.h"
#import "KTVRoomViewController+SocketControl.h"
#import "KTVStaticView.h"
#import "KTVHostAvatarView.h"
#import "KTVRoomBottomView.h"
#import "KTVPeopleNumView.h"
#import "KTVSeatComponent.h"
#import "KTVMusicComponent.h"
#import "KTVTextInputComponent.h"
#import "KTVRoomUserListComponent.h"
#import "KTVIMComponent.h"
#import "KTVPickSongComponent.h"
#import "KTVPickSongManager.h"
#import "KTVRTCManager.h"
#import "KTVRTMManager.h"
#import "NetworkingTool.h"

@interface KTVRoomViewController () <KTVRoomBottomViewDelegate, KTVRTCManagerDelegate, KTVSeatDelegate, MusicComponentDelegate, KTVPickSongComponentDelegate>

@property (nonatomic, strong) KTVStaticView *staticView;
@property (nonatomic, strong) KTVHostAvatarView *hostAvatarView;
@property (nonatomic, strong) KTVRoomBottomView *bottomView;
@property (nonatomic, strong) KTVMusicComponent *musicComponent;
@property (nonatomic, strong) KTVTextInputComponent *textInputComponent;
@property (nonatomic, strong) KTVRoomUserListComponent *userListComponent;
@property (nonatomic, strong) KTVIMComponent *imComponent;
@property (nonatomic, strong) KTVSeatComponent *seatComponent;
@property (nonatomic, strong) KTVPickSongComponent *pickSongComponent;
@property (nonatomic, strong) KTVRoomModel *roomModel;
@property (nonatomic, strong) KTVUserModel *hostUserModel;
@property (nonatomic, copy) NSString *rtcToken;

@property (nonatomic, strong) UIView *seatContentView;

@end

@implementation KTVRoomViewController

- (instancetype)initWithRoomModel:(KTVRoomModel *)roomModel {
    self = [super init];
    if (self) {
        _roomModel = roomModel;
    }
    return self;
}

- (instancetype)initWithRoomModel:(KTVRoomModel *)roomModel
                         rtcToken:(NSString *)rtcToken
                    hostUserModel:(KTVUserModel *)hostUserModel {
    self = [super init];
    if (self) {
        _hostUserModel = hostUserModel;
        _roomModel = roomModel;
        _rtcToken = rtcToken;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.view.backgroundColor = [UIColor colorFromHexString:@"#394254"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearRedNotification) name:KClearRedNotification object:nil];
    
    [self addSocketListener];
    [self addSubviewAndConstraints];
    [self joinRoom];
    
    __weak typeof(self) weakSelf = self;
    [KTVRTCManager shareRtc].rtcJoinRoomBlock = ^(NSString * _Nonnull roomId, NSInteger errorCode, NSInteger joinType) {
        [weakSelf receivedJoinRoom:roomId errorCode:errorCode joinType:joinType];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark - Notification
- (void)receivedJoinRoom:(NSString *)roomId
               errorCode:(NSInteger)errorCode
                joinType:(NSInteger)joinType {
    if ([roomId isEqualToString:self.roomModel.roomID]) {
        if (errorCode == 0) {

        }
        if (joinType != 0 && errorCode == 0) {
            [self reconnectKTVRoom];
        }
        return;
    }
}

- (void)reconnectKTVRoom {
    __weak typeof(self) weakSelf = self;
    [KTVRTMManager reconnectWithBlock:^(NSString * _Nonnull RTCToken,
                                        KTVRoomModel * _Nonnull roomModel,
                                        KTVUserModel * _Nonnull userModel,
                                        KTVUserModel * _Nonnull hostUserModel,
                                        KTVSongModel * _Nonnull songModel,
                                        NSArray<KTVSeatModel *> * _Nonnull seatList,
                                        RTMACKModel * _Nonnull model) {
        // 重连
        if (model.result) {
            [weakSelf updateRoomViewWithData:RTCToken
                                   roomModel:roomModel
                                   userModel:userModel
                               hostUserModel:hostUserModel
                                    seatList:seatList
                                   songModel:songModel
                                 isReconnect:YES];
            
            for (KTVSeatModel *seatModel in seatList) {
                if ([seatModel.userModel.uid isEqualToString:userModel.uid]) {
                    // Reconnect after disconnection, I need to turn on the microphone to collect
                    [[KTVRTCManager shareRtc] enableLocalAudio:(userModel.mic == KTVUserMicOn) ? YES : NO];
                    break;
                }
            }
        } else if (model.code == RTMStatusCodeUserIsInactive ||
                   model.code == RTMStatusCodeRoomDisbanded ||
                   model.code == RTMStatusCodeUserNotFound) {
            [weakSelf hangUp:NO];
        }
    }];
}

- (void)clearRedNotification {
    [self.bottomView updateButtonStatus:KTVRoomBottomStatusPhone isRed:NO];
    [self.userListComponent updateWithRed:NO];
}

#pragma mark - SocketControl

// The audience cannot receive a callback when they enter the room for the first time because they have not yet joined the room
- (void)receivedJoinUser:(KTVUserModel *)userModel
                   count:(NSInteger)count {
    KTVIMModel *model = [[KTVIMModel alloc] init];
    model.userModel = userModel;
    model.isJoin = YES;
    [self.imComponent addIM:model];
    [self.staticView updatePeopleNum:count];
    [self.userListComponent update];
}

- (void)receivedLeaveUser:(KTVUserModel *)userModel
                    count:(NSInteger)count {
    KTVIMModel *model = [[KTVIMModel alloc] init];
    model.userModel = userModel;
    model.isJoin = NO;
    [self.imComponent addIM:model];
    [self.staticView updatePeopleNum:count];
    [self.userListComponent update];
}

- (void)receivedFinishLive:(NSInteger)type roomID:(NSString *)roomID {
    if (![roomID isEqualToString:self.roomModel.roomID]) {
        return;
    }
    [self hangUp:NO];
    if (type == 3) {
        [[ToastComponent shareToastComponent] showWithMessage:@"直播间内容违规，直播间已被关闭" delay:0.8];
    }
    else if (type == 2 && [self isHost]) {
        [[ToastComponent shareToastComponent] showWithMessage:@"本次体验时间已超过20分钟" delay:0.8];
    } else {
        if (![self isHost]) {
            [[ToastComponent shareToastComponent] showWithMessage:@"直播间已结束" delay:0.8];
        }
    }
}

- (void)receivedJoinInteractWithUser:(KTVUserModel *)userModel
                              seatID:(NSString *)seatID {
    KTVSeatModel *seatModel = [[KTVSeatModel alloc] init];
    seatModel.status = 1;
    seatModel.userModel = userModel;
    seatModel.index = seatID.integerValue;
    [self.seatComponent addSeatModel:seatModel];
    [self.userListComponent update];
    if ([userModel.uid isEqualToString:[LocalUserComponent userModel].uid]) {
        [self.bottomView updateBottomLists:userModel];
        // RTC Start Audio Capture
        [[KTVRTCManager shareRtc] enableLocalAudio:YES];
        [[ToastComponent shareToastComponent] showWithMessage:@"你已上麦"];
        [self.musicComponent updateUserModel:userModel];
    }
    
    //IM
    KTVIMModel *model = [[KTVIMModel alloc] init];
    NSString *message = [NSString stringWithFormat:@"%@已上麦",userModel.name];
    model.message = message;
    [self.imComponent addIM:model];
}

- (void)receivedLeaveInteractWithUser:(KTVUserModel *)userModel
                               seatID:(NSString *)seatID
                                 type:(NSInteger)type {
    [self.seatComponent removeUserModel:userModel];
    [self.userListComponent update];
    if ([userModel.uid isEqualToString:[LocalUserComponent userModel].uid]) {
        [self.bottomView updateBottomLists:userModel];
        // RTC Stop Audio Capture
        [[KTVRTCManager shareRtc] enableLocalAudio:NO];
        [self.musicComponent updateUserModel:userModel];
        
        if (type == 1) {
            [[ToastComponent shareToastComponent] showWithMessage:@"你已被主播移出麦位"];
        } else if (type == 2) {
            [[ToastComponent shareToastComponent] showWithMessage:@"你已下麦"];
        }
    }
    
    //IM
    KTVIMModel *model = [[KTVIMModel alloc] init];
    NSString *message = [NSString stringWithFormat:@"%@已下麦",userModel.name];
    model.message = message;
    [self.imComponent addIM:model];
}

- (void)receivedSeatStatusChange:(NSString *)seatID
                            type:(NSInteger)type {
    KTVSeatModel *seatModel = [[KTVSeatModel alloc] init];
    seatModel.status = type;
    seatModel.userModel = nil;
    seatModel.index = seatID.integerValue;
    [self.seatComponent updateSeatModel:seatModel];
}

- (void)receivedMediaStatusChangeWithUser:(KTVUserModel *)userModel
                                   seatID:(NSString *)seatID
                                      mic:(NSInteger)mic {
    if ([userModel.uid isEqualToString:[LocalUserComponent userModel].uid]) {
        [self.bottomView updateButtonStatus:KTVRoomBottomStatusLocalMic
                                   isSelect:!mic];
    }
    KTVSeatModel *seatModel = [[KTVSeatModel alloc] init];
    seatModel.status = 1;
    seatModel.userModel = userModel;
    seatModel.index = seatID.integerValue;
    [self.seatComponent updateSeatModel:seatModel];
    if ([userModel.uid isEqualToString:self.roomModel.hostUid]) {
        [self.hostAvatarView updateHostMic:mic];
    }
    if ([userModel.uid isEqualToString:[LocalUserComponent userModel].uid]) {
        // RTC Mute/Unmute Audio Capture
        [[KTVRTCManager shareRtc] muteLocalAudio:!mic];
    }
}

- (void)receivedMessageWithUser:(KTVUserModel *)userModel
                        message:(NSString *)message {
    if (![userModel.uid isEqualToString:[LocalUserComponent userModel].uid]) {
        KTVIMModel *model = [[KTVIMModel alloc] init];
        NSString *imMessage = [NSString stringWithFormat:@"%@：%@",
                               userModel.name,
                               message];
        model.userModel = userModel;
        model.message = imMessage;
        [self.imComponent addIM:model];
    }
}

- (void)receivedInviteInteractWithUser:(KTVUserModel *)hostUserModel
                                seatID:(NSString *)seatID {
    AlertActionModel *alertModel = [[AlertActionModel alloc] init];
    alertModel.title = @"接受";
    AlertActionModel *cancelModel = [[AlertActionModel alloc] init];
    cancelModel.title = @"拒绝";
    [[AlertActionManager shareAlertActionManager] showWithMessage:@"主播邀请你上麦，是否接受？" actions:@[cancelModel, alertModel]];
    
    __weak __typeof(self) wself = self;
    alertModel.alertModelClickBlock = ^(UIAlertAction * _Nonnull action) {
        if ([action.title isEqualToString:@"接受"]) {
            [wself loadDataWithReplyInvite:1];
        }
    };
    cancelModel.alertModelClickBlock = ^(UIAlertAction * _Nonnull action) {
        if ([action.title isEqualToString:@"拒绝"]) {
            [wself loadDataWithReplyInvite:2];
        }
    };
}

- (void)receivedApplyInteractWithUser:(KTVUserModel *)userModel
                               seatID:(NSString *)seatID {
    if ([self isHost]) {
        [self.bottomView updateButtonStatus:KTVRoomBottomStatusPhone isRed:YES];
        [self.userListComponent updateWithRed:YES];
        [self.userListComponent update];
    }
}

- (void)receivedInviteResultWithUser:(KTVUserModel *)hostUserModel
                               reply:(NSInteger)reply {
    if ([self isHost] && reply == 2) {
        NSString *message = [NSString stringWithFormat:@"观众%@拒绝了你的邀请", hostUserModel.name];
        [[ToastComponent shareToastComponent] showWithMessage:message];
        [self.userListComponent update];
    }
}

- (void)receivedMediaOperatWithUid:(NSInteger)mic {
    [KTVRTMManager updateMediaStatus:self.roomModel.roomID
                                              mic:mic
                               block:^(RTMACKModel * _Nonnull model) {
        
    }];
    if (mic) {
        [[ToastComponent shareToastComponent] showWithMessage:@"主播已解除对你的静音"];
    } else {
        [[ToastComponent shareToastComponent] showWithMessage:@"你已被主播静音"];
    }
}

- (void)receivedClearUserWithUid:(NSString *)uid {
    [self hangUp:NO];
    [[ToastComponent shareToastComponent] showWithMessage:@"相同ID用户已登录，您已被强制下线！" delay:0.8];
}

- (void)hangUp:(BOOL)isServer {
    if (isServer) {
        // socket api
        if ([self isHost]) {
            [KTVRTMManager finishLive:self.roomModel.roomID];
        } else {
            [KTVRTMManager leaveLiveRoom:self.roomModel.roomID];
        }
    }
    // sdk api
    [[KTVRTCManager shareRtc] leaveChannel];
    
    [[KTVRTCManager shareRtc] enableLocalAudio:NO];
    // ui
    [self navigationControllerPop];
}

- (void)receivedPickedSong:(KTVSongModel *)songModel {
    [self.pickSongComponent updatePickedSongList];
}

- (void)receivedStartSingSong:(KTVSongModel *)songModel {
    [self.musicComponent startSingWithSongModel:songModel];
    [self.pickSongComponent updatePickedSongList];
    [self.seatComponent updateCurrentSongModel:songModel];
    [self.hostAvatarView updateCurrentSongModel:songModel];
}

- (void)receivedFinishSingSong:(NSInteger)score
                 nextSongModel:(KTVSongModel *)nextSongModel
                  curSongModel:(KTVSongModel *)curSongModel {
    [self.musicComponent showSongEndSongModel:nextSongModel curSongModel:curSongModel score:score];
    [self.pickSongComponent updatePickedSongList];
}

#pragma mark - Load Data

- (void)loadDataWithJoinRoom {
    __weak __typeof(self) wself = self;
    [KTVRTMManager joinLiveRoom:self.roomModel.roomID
                              userName:[LocalUserComponent userModel].name
                                 block:^(
                                         NSString * _Nonnull RTCToken,
                                         KTVRoomModel * _Nonnull roomModel,
                                         KTVUserModel * _Nonnull userModel,
                                         KTVUserModel * _Nonnull hostUserModel,
                                         KTVSongModel * _Nonnull songModel,
                                         NSArray<KTVSeatModel *> * _Nonnull seatList,
                                         RTMACKModel * _Nonnull model) {
 
        if (NOEmptyStr(roomModel.roomID)) {
            [wself updateRoomViewWithData:RTCToken
                                roomModel:roomModel
                                userModel:userModel
                            hostUserModel:hostUserModel
                                 seatList:seatList
                                songModel:songModel
                              isReconnect:NO];
        } else {
            AlertActionModel *alertModel = [[AlertActionModel alloc] init];
            alertModel.title = @"确定";
            alertModel.alertModelClickBlock = ^(UIAlertAction * _Nonnull action) {
                if ([action.title isEqualToString:@"确定"]) {
                    [wself hangUp:NO];
                }
            };
            [[AlertActionManager shareAlertActionManager] showWithMessage:@"加入房间失败，回到房间列表页" actions:@[alertModel]];
        }
    }];
}

#pragma mark - KTVPickSongComponentDelegate
- (void)ktvPickSongComponent:(KTVPickSongComponent *)component pickedSongCountChanged:(NSInteger)count {
    [self.bottomView updatePickedSongCount:count];
}

#pragma mark - KTVRoomBottomViewDelegate

- (void)KTVRoomBottomView:(KTVRoomBottomView *_Nonnull)KTVRoomBottomView
                     itemButton:(KTVRoomItemButton *_Nullable)itemButton
                didSelectStatus:(KTVRoomBottomStatus)status {
    if (status == KTVRoomBottomStatusInput) {
        [self.textInputComponent showWithRoomModel:self.roomModel];
        __weak __typeof(self) wself = self;
        self.textInputComponent.clickSenderBlock = ^(NSString * _Nonnull text) {
            KTVIMModel *model = [[KTVIMModel alloc] init];
            NSString *message = [NSString stringWithFormat:@"%@：%@",
                                 [LocalUserComponent userModel].name,
                                 text];
            model.message = message;
            [wself.imComponent addIM:model];
        };
    } else if (status == KTVRoomBottomStatusPhone) {
        [self.userListComponent showRoomModel:self.roomModel
                                        seatID:@"-1"
                                  dismissBlock:^{
            
        }];
    } else if (status == KTVRoomBottomStatusMusic) {
        
    } else if (status == KTVRoomBottomStatusLocalMic) {
        
    }
    else if (status == KTVRoomBottomStatusPickSong) {
        [self showPickSongView];
    }
    else {
        if ([self isHost]) {
            [self showEndView];
        } else {
            [self hangUp:YES];
        }
    }
}

#pragma mark - KTVSeatDelegate

- (void)KTVSeatComponent:(KTVSeatComponent *)KTVSeatComponent
                    clickButton:(KTVSeatModel *)seatModel
                    sheetStatus:(KTVSheetStatus)sheetStatus {
    if (sheetStatus == KTVSheetStatusInvite) {
        [self.userListComponent showRoomModel:self.roomModel
                                        seatID:[NSString stringWithFormat:@"%ld", (long)seatModel.index]
                                  dismissBlock:^{
            
        }];
    }
}

#pragma mark - KTVRTCManagerDelegate

- (void)KTVRTCManager:(KTVRTCManager *)KTVRTCManager changeParamInfo:(KTVRoomParamInfoModel *)model {
    [self.staticView updateParamInfoModel:model];
}

- (void)KTVRTCManager:(KTVRTCManager *_Nonnull)KTVRTCManager reportAllAudioVolume:(NSDictionary<NSString *, NSNumber *> *_Nonnull)volumeInfo {
    if (volumeInfo.count > 0) {
        NSNumber *volumeValue = volumeInfo[self.roomModel.hostUid];
        [self.hostAvatarView updateHostVolume:volumeValue];
        [self.seatComponent updateSeatVolume:volumeInfo];
    }
}

- (void)KTVRTCManager:(KTVRTCManager *_Nonnull)KTVRTCManager onStreamSyncInfoReceived:(nonnull NSString *)json {
    dispatch_queue_async_safe(dispatch_get_main_queue(), ^{
        [self.musicComponent updateCurrentSongTime:json];
    });
}

- (void)KTVRTCManager:(KTVRTCManager *_Nonnull)KTVRTCManager songEnds:(BOOL)result {
    [self.musicComponent stopSong];
}

- (void)KTVRTCManager:(KTVRTCManager *_Nonnull)KTVRTCManager onAudioMixingPlayingProgress:(NSInteger)progress {
    dispatch_queue_async_safe(dispatch_get_main_queue(), ^{
        [self.musicComponent sendSongTime:progress];
    });
}

- (void)KTVRTCManagerOnAudioRouteChanged:(KTVRTCManager *)KTVRTCManager {
    [self.musicComponent updateAudioRouteChanged];
}

#pragma mark - MusicComponentDelegate

- (void)musicComponent:(KTVMusicComponent *)musicComponent clickPlayMusic:(BOOL)isClick {
    [self showPickSongView];
}

#pragma mark - Network request

- (void)loadDataWithReplyInvite:(NSInteger)type {
    [KTVRTMManager replyInvite:self.roomModel.roomID
                                      reply:type
                                      block:^(RTMACKModel * _Nonnull model) {
        if (!model.result) {
            [[ToastComponent shareToastComponent] showWithMessage:model.message];
        }
    }];
}

#pragma mark - Private Action

- (void)joinRoom {
    if (IsEmptyStr(self.hostUserModel.uid)) {
        [self loadDataWithJoinRoom];
        self.staticView.roomModel = self.roomModel;
    } else {
        [self updateRoomViewWithData:self.rtcToken
                           roomModel:self.roomModel
                           userModel:self.hostUserModel
                       hostUserModel:self.hostUserModel
                            seatList:[self getDefaultSeatDataList]
                           songModel:nil
                         isReconnect:NO];
    }
}

- (void)updateRoomViewWithData:(NSString *)rtcToken
                     roomModel:(KTVRoomModel *)roomModel
                     userModel:(KTVUserModel *)userModel
                 hostUserModel:(KTVUserModel *)hostUserModel
                      seatList:(NSArray<KTVSeatModel *> *)seatList
                     songModel:(KTVSongModel *)songModel
                   isReconnect:(BOOL)isReconnect {
    _hostUserModel = hostUserModel;
    _roomModel = roomModel;
    _rtcToken = rtcToken;
    //Activate SDK
    [KTVRTCManager shareRtc].delegate = self;
    [[KTVRTCManager shareRtc] joinChannelWithToken:rtcToken
                                                  roomID:self.roomModel.roomID
                                                     uid:[LocalUserComponent userModel].uid];
    if (userModel.userRole == KTVUserRoleHost) {
        [[KTVRTCManager shareRtc] enableLocalAudio:(userModel.mic == KTVUserMicOn) ? YES : NO];
    }
    self.hostAvatarView.userModel = self.hostUserModel;
    self.staticView.roomModel = self.roomModel;
    [self.bottomView updateBottomLists:userModel];
    [self.seatComponent showSeatView:seatList loginUserModel:userModel];
    [self.musicComponent updateUserModel:userModel];
    [self.musicComponent startSingWithSongModel:songModel];

    [self.seatComponent updateCurrentSongModel:songModel];
    [self.hostAvatarView updateCurrentSongModel:songModel];
}

- (void)addSubviewAndConstraints {
    [self.view addSubview:self.staticView];
    [self.staticView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.seatContentView];
    [self.seatContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(55);
        make.top.mas_equalTo(333 + 19 + [DeviceInforTool getStatusBarHight]);
    }];
    
    CGFloat space = (SCREEN_WIDTH - 32 * 7 - 1)/9;
    
    [self.seatContentView addSubview:self.hostAvatarView];
    [self.hostAvatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 55));
        make.top.bottom.equalTo(self.seatContentView);
        make.left.equalTo(self.seatContentView).offset(space);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.27];
    [self.seatContentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hostAvatarView.mas_right).offset(space);
        make.centerY.equalTo(self.hostAvatarView);
        make.size.mas_equalTo(CGSizeMake(1, 30));
    }];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([DeviceInforTool getVirtualHomeHeight] + 36 + 32);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.bottom.equalTo(self.view);
    }];
    
    [self musicComponent];
    [self imComponent];
    [self textInputComponent];
    [self pickSongComponent];
}

- (void)showEndView {
    __weak __typeof(self) wself = self;
    AlertActionModel *alertModel = [[AlertActionModel alloc] init];
    alertModel.title = @"结束直播";
    alertModel.alertModelClickBlock = ^(UIAlertAction *_Nonnull action) {
        if ([action.title isEqualToString:@"结束直播"]) {
            [wself hangUp:YES];
        }
    };
    AlertActionModel *alertCancelModel = [[AlertActionModel alloc] init];
    alertCancelModel.title = @"取消";
    NSString *message = @"是否结束直播？";
    [[AlertActionManager shareAlertActionManager] showWithMessage:message actions:@[ alertCancelModel, alertModel ]];
}

- (void)navigationControllerPop {
    UIViewController *jumpVC = nil;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([NSStringFromClass([vc class]) isEqualToString:@"KTVRoomListsViewController"]) {
            jumpVC = vc;
            break;
        }
    }
    if (jumpVC) {
        [self.navigationController popToViewController:jumpVC animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)isHost {
    return [self.roomModel.hostUid isEqualToString:[LocalUserComponent userModel].uid];
}

- (NSArray *)getDefaultSeatDataList {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (int i = 0; i < 8; i++) {
        KTVSeatModel *seatModel = [[KTVSeatModel alloc] init];
        seatModel.status = 1;
        seatModel.index = i + 1;
        [list addObject:seatModel];
    }
    return [list copy];
}

- (void)showPickSongView {
    [self.pickSongComponent show];
}

#pragma mark - Getter

- (KTVTextInputComponent *)textInputComponent {
    if (!_textInputComponent) {
        _textInputComponent = [[KTVTextInputComponent alloc] init];
    }
    return _textInputComponent;
}

- (KTVStaticView *)staticView {
    if (!_staticView) {
        _staticView = [[KTVStaticView alloc] init];
    }
    return _staticView;
}

- (KTVHostAvatarView *)hostAvatarView {
    if (!_hostAvatarView) {
        _hostAvatarView = [[KTVHostAvatarView alloc] init];
    }
    return _hostAvatarView;
}

- (KTVSeatComponent *)seatComponent {
    if (!_seatComponent) {
        _seatComponent = [[KTVSeatComponent alloc] initWithSuperView:self.seatContentView];
        _seatComponent.delegate = self;
    }
    return _seatComponent;
}

- (KTVRoomBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[KTVRoomBottomView alloc] init];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (KTVRoomUserListComponent *)userListComponent {
    if (!_userListComponent) {
        _userListComponent = [[KTVRoomUserListComponent alloc] init];
    }
    return _userListComponent;
}

- (KTVIMComponent *)imComponent {
    if (!_imComponent) {
        _imComponent = [[KTVIMComponent alloc] initWithSuperView:self.view];
    }
    return _imComponent;
}

- (KTVMusicComponent *)musicComponent {
    if (!_musicComponent) {
        _musicComponent = [[KTVMusicComponent alloc] initWithSuperView:self.view
                                                                  roomID:self.roomModel.roomID];
        _musicComponent.delegate = self;
    }
    return _musicComponent;
}

- (void)dealloc {
    [self.musicComponent dismissTuningPanel];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[AlertActionManager shareAlertActionManager] dismiss:^{
        
    }];
}

- (UIView *)seatContentView {
    if (!_seatContentView) {
        _seatContentView = [[UIView alloc] init];
    }
    return _seatContentView;
}

- (KTVPickSongComponent *)pickSongComponent {
    if (!_pickSongComponent) {
        _pickSongComponent = [[KTVPickSongComponent alloc] initWithSuperView:self.view roomID:self.roomModel.roomID];
        _pickSongComponent.delegate = self;
    }
    return _pickSongComponent;
}

@end
