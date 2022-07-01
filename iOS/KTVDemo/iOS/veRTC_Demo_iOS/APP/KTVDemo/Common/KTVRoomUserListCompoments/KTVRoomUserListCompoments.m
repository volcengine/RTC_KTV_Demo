//
//  KTVRoomUserListCompoments.m
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/19.
//  Copyright © 2021 . All rights reserved.
//

#import "KTVRoomUserListCompoments.h"
#import "KTVRoomTopSelectView.h"
#import "KTVRoomTopSeatView.h"
#import "KTVRTMManager.h"

@interface KTVRoomUserListCompoments () <KTVRoomTopSelectViewDelegate, KTVRoomRaiseHandListsViewDelegate, KTVRoomAudienceListsViewDelegate>

@property (nonatomic, strong) KTVRoomTopSeatView *topSeatView;
@property (nonatomic, strong) KTVRoomTopSelectView *topSelectView;
@property (nonatomic, strong) KTVRoomRaiseHandListsView *applyListsView;
@property (nonatomic, strong) KTVRoomAudienceListsView *onlineListsView;
@property (nonatomic, strong) UIButton *maskButton;

@property (nonatomic, copy) void (^dismissBlock)(void);
@property (nonatomic, strong) KTVRoomModel *roomModel;
@property (nonatomic, copy) NSString *seatID;
@property (nonatomic, assign) BOOL isRed;

@end


@implementation KTVRoomUserListCompoments

- (instancetype)init {
    self = [super init];
    if (self) {
        _isRed = NO;
    }
    return self;
}

#pragma mark - Publish Action

- (void)showRoomModel:(KTVRoomModel *)roomModel
               seatID:(NSString *)seatID
         dismissBlock:(void (^)(void))dismissBlock {
    _roomModel = roomModel;
    _seatID = seatID;
    self.dismissBlock = dismissBlock;
    UIViewController *rootVC = [DeviceInforTool topViewController];
    
    [rootVC.view addSubview:self.maskButton];
    [self.maskButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.height.equalTo(rootVC.view);
        make.top.equalTo(rootVC.view).offset(SCREEN_HEIGHT);
    }];
    
    [self.maskButton addSubview:self.applyListsView];
    [self.applyListsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        CGFloat hetight = ((300.0 / 667.0) * SCREEN_HEIGHT);
        make.height.mas_offset(hetight + [DeviceInforTool getVirtualHomeHeight]);
        make.bottom.mas_offset(0);
    }];
    
    [self.maskButton addSubview:self.onlineListsView];
    [self.onlineListsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.applyListsView);
    }];
    
    [self.maskButton addSubview:self.topSelectView];
    [self.topSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.maskButton);
        make.bottom.equalTo(self.applyListsView.mas_top);
        make.height.mas_equalTo(52);
    }];
    
    [self.maskButton addSubview:self.topSeatView];
    [self.topSeatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.maskButton);
        make.bottom.equalTo(self.topSelectView.mas_top);
        make.height.mas_equalTo(48);
    }];
    
    // Start animation
    [rootVC.view layoutIfNeeded];
    [self.maskButton.superview setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.25
                     animations:^{
        [self.maskButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(rootVC.view).offset(0);
        }];
        [self.maskButton.superview layoutIfNeeded];
    }];
    
    if (_isRed) {
        [self loadDataWithApplyLists];
        [self.topSelectView updateSelectItem:NO];
        self.onlineListsView.hidden = YES;
        self.applyListsView.hidden = NO;
    } else {
        [self loadDataWithOnlineLists];
        [self.topSelectView updateSelectItem:YES];
        self.onlineListsView.hidden = NO;
        self.applyListsView.hidden = YES;
    }
    
    __weak __typeof(self) wself = self;
    self.topSeatView.clickSwitchBlock = ^(BOOL isOn) {
        [wself loadDataWithSwitch:isOn];
    };
}

- (void)update {
    if (self.onlineListsView.superview && !self.onlineListsView.hidden) {
        [self loadDataWithOnlineLists];
    } else if (self.applyListsView.superview && !self.applyListsView.hidden) {
        [self loadDataWithApplyLists];
    } else {
        
    }
}

- (void)updateWithRed:(BOOL)isRed {
    _isRed = isRed;
    [self.topSelectView updateWithRed:isRed];
}

#pragma mark - Load Data

- (void)loadDataWithOnlineLists {
    __weak __typeof(self) wself = self;
    [KTVRTMManager getAudienceList:_roomModel.roomID
                             block:^(NSArray<KTVUserModel *> * _Nonnull userLists, RTMACKModel * _Nonnull model) {

        if (model.result) {
            wself.onlineListsView.dataLists = userLists;
        }
    }];
}

- (void)loadDataWithApplyLists {
    __weak __typeof(self) wself = self;
    [KTVRTMManager getApplyAudienceList:_roomModel.roomID
                                  block:^(NSArray<KTVUserModel *> * _Nonnull userLists, RTMACKModel * _Nonnull model) {
        if (model.result) {
            wself.applyListsView.dataLists = userLists;
        }
    }];
}

#pragma mark - KTVRoomTopSelectViewDelegate

- (void)KTVRoomTopSelectView:(KTVRoomTopSelectView *)KTVRoomTopSelectView clickCancelAction:(id)model {
    [self dismissUserListView];
}

- (void)KTVRoomTopSelectView:(KTVRoomTopSelectView *)KTVRoomTopSelectView clickSwitchItem:(BOOL)isAudience {
    if (isAudience) {
        self.onlineListsView.hidden = YES;
        self.applyListsView.hidden = NO;
        [self loadDataWithApplyLists];
    } else {
        self.onlineListsView.hidden = NO;
        self.applyListsView.hidden = YES;
        [self loadDataWithOnlineLists];
    }
}

#pragma mark - KTVRoomonlineListsViewDelegate

- (void)KTVRoomAudienceListsView:(KTVRoomRaiseHandListsView *)KTVRoomAudienceListsView clickButton:(KTVUserModel *)model {
    [self clickTableViewWithModel:model dataLists:KTVRoomAudienceListsView.dataLists];
}

#pragma mark - KTVRoomapplyListsViewDelegate

- (void)KTVRoomRaiseHandListsView:(KTVRoomRaiseHandListsView *)KTVRoomRaiseHandListsView clickButton:(KTVUserModel *)model {
    [self clickTableViewWithModel:model dataLists:KTVRoomRaiseHandListsView.dataLists];
}

#pragma mark - Private Action

- (void)loadDataWithSwitch:(BOOL)isOn {
    NSInteger type = isOn ? 1 : 2;
    [KTVRTMManager managerInteractApply:self.roomModel.roomID
                                                type:type
                                               block:^(RTMACKModel * _Nonnull model) {
  
        if (!model.result) {
            [[ToastComponents shareToastComponents] showWithMessage:@"操作失败，请重试"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateSeatSwitch object:@(!isOn)];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationResultSeatSwitch object:nil];
    }];
}

- (void)clickTableViewWithModel:(KTVUserModel *)userModel dataLists:(NSArray<KTVUserModel *> *)dataLists {
    if (userModel.status == KTVUserStatusDefault) {
        [KTVRTMManager inviteInteract:userModel.roomID
                                               uid:userModel.uid
                                            seatID:_seatID
                                             block:^(RTMACKModel * _Nonnull model) {
            if (!model.result) {
                [[ToastComponents shareToastComponents] showWithMessage:model.message];
            } else {
                [[ToastComponents shareToastComponents] showWithMessage:@"已向观众发出邀请，等待对方应答"];
            }
        }];
    } else if (userModel.status == KTVUserStatusApply) {
        __weak __typeof(self)wself = self;
        [KTVRTMManager agreeApply:userModel.roomID
                                           uid:userModel.uid
                                         block:^(RTMACKModel * _Nonnull model) {
        
            if (model.result) {
                userModel.status = KTVUserStatusApply;
                [wself updateDataLists:dataLists model:userModel];
            } else {
                [[ToastComponents shareToastComponents] showWithMessage:model.message];
            }
        }];
    } else {
        
    }
}

- (void)updateDataLists:(NSArray<KTVUserModel *> *)dataLists
                  model:(KTVUserModel *)model {
    for (int i = 0; i < dataLists.count; i++) {
        KTVUserModel *currentModel = dataLists[i];
        if ([currentModel.uid isEqualToString:model.uid]) {
            NSMutableArray *mutableLists = [[NSMutableArray alloc] initWithArray:dataLists];
            [mutableLists replaceObjectAtIndex:i withObject:model];
            break;
        }
    }
}

- (void)removeDataLists:(NSArray<KTVUserModel *> *)dataLists model:(KTVUserModel *)model {
    KTVUserModel *deleteModel = nil;
    for (int i = 0; i < dataLists.count; i++) {
        KTVUserModel *currentModel = dataLists[i];
        if ([currentModel.uid isEqualToString:model.uid]) {
            deleteModel = currentModel;
            break;
        }
    }

    if (deleteModel) {
        NSMutableArray *mutableLists = [[NSMutableArray alloc] initWithArray:dataLists];
        [mutableLists removeObject:deleteModel];
        dataLists = [mutableLists copy];
    }
}

- (void)maskButtonAction {
    [self dismissUserListView];
}

- (void)dismissUserListView {
    _seatID = @"-1";
    [self.maskButton removeAllSubviews];
    [self.maskButton removeFromSuperview];
    self.maskButton = nil;
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

#pragma mark - Getter

- (KTVRoomRaiseHandListsView *)applyListsView {
    if (!_applyListsView) {
        _applyListsView = [[KTVRoomRaiseHandListsView alloc] init];
        _applyListsView.delegate = self;
        _applyListsView.backgroundColor = [UIColor colorFromRGBHexString:@"#0E0825" andAlpha:0.95 * 255];
    }
    return _applyListsView;
}

- (KTVRoomAudienceListsView *)onlineListsView {
    if (!_onlineListsView) {
        _onlineListsView = [[KTVRoomAudienceListsView alloc] init];
        _onlineListsView.delegate = self;
        _onlineListsView.backgroundColor = [UIColor colorFromRGBHexString:@"#0E0825" andAlpha:0.95 * 255];
    }
    return _onlineListsView;
}

- (UIButton *)maskButton {
    if (!_maskButton) {
        _maskButton = [[UIButton alloc] init];
        [_maskButton addTarget:self action:@selector(maskButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_maskButton setBackgroundColor:[UIColor clearColor]];
    }
    return _maskButton;
}

- (KTVRoomTopSelectView *)topSelectView {
    if (!_topSelectView) {
        _topSelectView = [[KTVRoomTopSelectView alloc] init];
        _topSelectView.delegate = self;
    }
    return _topSelectView;
}

- (KTVRoomTopSeatView *)topSeatView {
    if (!_topSeatView) {
        _topSeatView = [[KTVRoomTopSeatView alloc] init];
    }
    return _topSeatView;
}

- (void)dealloc {
    NSLog(@"dealloc %@",NSStringFromClass([self class]));
}

@end
