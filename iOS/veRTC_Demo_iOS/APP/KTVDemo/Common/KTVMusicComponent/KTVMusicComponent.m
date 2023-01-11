//
//  KTVMusicComponent.m
//  veRTC_Demo
//
//  Created by on 2021/11/30.
//  
//

#import "KTVMusicComponent.h"
#import "KTVMusicView.h"
#import "KTVMusicNullView.h"
#import "KTVMusicEndView.h"
#import "KTVPickSongManager.h"

/// 音乐UI展示状态
/// Music UI display status
typedef NS_ENUM(NSInteger, KTVMusicViewStatus) {
    KTVMusicViewStatusShowMusic     = 0,
    KTVMusicViewStatusShowNull      = 1,
    KTVMusicViewStatusShowResult    = 2,
};

@interface KTVMusicComponent () <KTVMusicViewdelegate>

@property (nonatomic, strong) KTVMusicNullView *musicNullView;
@property (nonatomic, strong) KTVMusicView *musicView;
@property (nonatomic, strong) KTVMusicEndView *musicEndView;

@property (nonatomic, copy) NSString *roomID;
@property (nonatomic, strong) KTVUserModel *loginUserModel;
@property (nonatomic, strong) KTVSongModel *songModel;
@property (nonatomic, strong) KTVSongModel *aboveSongModel;

@end

@implementation KTVMusicComponent

#pragma mark - Publish Action

- (instancetype)initWithSuperView:(UIView *)view
                           roomID:(NSString *)roomID {
    self = [super init];
    if (self) {
        _roomID = roomID;
        [view addSubview:self.musicView];
        [self.musicView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view);
            make.top.mas_equalTo([DeviceInforTool getStatusBarHight] + 72);
            make.height.mas_equalTo(256);
        }];
        
        [view addSubview:self.musicNullView];
        [self.musicNullView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view);
            make.top.mas_equalTo([DeviceInforTool getStatusBarHight] + 72);
            make.height.mas_equalTo(256);
        }];
        
        [view addSubview:self.musicEndView];
        [self.musicEndView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view);
            make.top.mas_equalTo([DeviceInforTool getStatusBarHight] + 72);
            make.height.mas_equalTo(256);
        }];
        
        __weak __typeof(self) wself = self;
        self.musicNullView.clickPlayMusicBlock = ^{
            if ([wself.delegate respondsToSelector:@selector(musicComponent:clickPlayMusic:)]) {
                [wself.delegate musicComponent:wself clickPlayMusic:YES];
            }
        };
    }
    return self;
}

- (void)showMusicViewWithStatus:(KTVMusicViewStatus)status {
    switch (status) {
        case KTVMusicViewStatusShowMusic: {
            self.musicEndView.hidden = YES;
            self.musicNullView.hidden = YES;
            self.musicView.hidden = NO;
        }
            break;
        case KTVMusicViewStatusShowNull: {
            self.musicEndView.hidden = YES;
            self.musicView.hidden = YES;
            self.musicNullView.hidden = NO;
        }
            break;
        case KTVMusicViewStatusShowResult: {
            self.musicEndView.hidden = NO;
            self.musicNullView.hidden = YES;
            self.musicView.hidden = YES;
        }
            break;
        default:
            break;
    }
}

#pragma mark - Publish Action

- (void)startSingWithSongModel:(KTVSongModel * _Nullable)songModel {
    _songModel = songModel;
    if (songModel && NOEmptyStr(songModel.musicId)) {

        [self showMusicViewWithStatus:KTVMusicViewStatusShowMusic];
        [self startWithSongModel:songModel
                  loginUserModel:self.loginUserModel];
        
    } else {
        [self showMusicViewWithStatus:KTVMusicViewStatusShowNull];
        if ([_aboveSongModel.pickedUserID isEqualToString:[LocalUserComponent userModel].uid]) {
            [[KTVRTCManager shareRtc] enableEarMonitor:NO];
            [[KTVRTCManager shareRtc] stopSinging];
        }
    }
    _aboveSongModel = songModel;
}

- (void)stopSong {
    if (IsEmptyStr(self.roomID) ||
        IsEmptyStr(self.songModel.musicId)) {
        return;
    }
    [KTVRTMManager finishSing:self.roomID
                              songID:self.songModel.musicId
                               score:75
                               block:^(KTVSongModel * _Nonnull songModel,
                                       RTMACKModel * _Nonnull model) {
        if (!model.result) {
            [[ToastComponent shareToastComponent] showWithMessage:model.message];
        }
    }];
    
    // close ear return
    [[KTVRTCManager shareRtc] enableEarMonitor:NO];
    // turn off the reverb effect
    [[KTVRTCManager shareRtc] setVoiceReverbType:ByteRTCVoiceReverbOriginal];
    // close the tuning panel
    [self.musicView dismissTuningPanel];
}

- (void)showSongEndSongModel:(KTVSongModel * _Nullable)nextSongModel
                curSongModel:(KTVSongModel * _Nullable)curSongModel
                       score:(NSInteger)score {
    // Display the singing result
    [self showMusicViewWithStatus:KTVMusicViewStatusShowResult];
    [[KTVRTCManager shareRtc] resetAudioMixingStatus];
    __weak __typeof(self) wself = self;
    [self.musicEndView showWithModel:nextSongModel
                               score:score
                               block:^(BOOL result) {
        // After the countdown is over, the anchor performs song cutting
        if ([curSongModel.pickedUserID isEqualToString:[LocalUserComponent userModel].uid]) {
            [wself loadDataWithCutOffSong:^(RTMACKModel *model) {
                if (!model.result) {
                    [[ToastComponent shareToastComponent] showWithMessage:model.message];
                }
            }];
        }
    }];
    
    
}

- (void)updateUserModel:(KTVUserModel *)loginUserModel {
    _loginUserModel = loginUserModel;
    self.musicNullView.loginUserModel = loginUserModel;
}

- (void)updateCurrentSongTime:(NSString *)json {
    NSDictionary *dic = [NetworkingTool decodeJsonMessage:json];
    if (dic && [dic isKindOfClass:[NSDictionary class]]) {
        NSInteger progress = [dic[@"progress"] integerValue];
        NSString *musicId = dic[@"music_id"];
        if ([musicId isEqualToString:self.songModel.musicId]) {
            self.musicView.time = progress;
        }
    }
}

- (void)dismissTuningPanel {
    [self.musicView dismissTuningPanel];
}

- (void)sendSongTime:(NSInteger)songTime {
    if ([self isSingerWithSongModel:self.songModel loginUserModel:self.loginUserModel] &&
        self.songModel && NOEmptyStr(self.songModel.musicId)) {
        NSTimeInterval second = (NSTimeInterval)songTime / 1000;
        self.musicView.time = second;
        NSDictionary *dic = @{@"progress" : @(second),
                              @"music_id" : self.songModel.musicId};
        NSString *json = [dic yy_modelToJSONString];
        
        // 发送给远端歌词进度
        [[KTVRTCManager shareRtc] sendStreamSyncTime:json];
        
        // 更新本地歌词进度
        [self updateCurrentSongTime:json];
    }
}

/// 音频播放路由改变
- (void)updateAudioRouteChanged {
    [self.musicView updateAudioRouteChanged];
}

#pragma mark - KTVMusicViewdelegate

- (void)musicViewdelegate:(KTVMusicView *)musicViewdelegate topViewClickCut:(BOOL)isResult {
    [[ToastComponent shareToastComponent] showLoading];
    musicViewdelegate.userInteractionEnabled = NO;
    [self loadDataWithCutOffSong:^(RTMACKModel *model) {
        [[ToastComponent shareToastComponent] dismiss];
        if (!model.result) {
            [[ToastComponent shareToastComponent] showWithMessage:model.message];
        }
        musicViewdelegate.userInteractionEnabled = YES;
    }];
}

#pragma mark - Network request Method

- (void)loadDataWithCutOffSong:(void(^)(RTMACKModel *model))complete {
    [KTVRTMManager cutOffSong:self.roomID
                        block:^(RTMACKModel * _Nonnull model) {
        if (complete) {
            complete(model);
        }
    }];
}

#pragma mark - Private Action

- (BOOL)isSingerWithSongModel:(KTVSongModel *)songModel
               loginUserModel:(KTVUserModel *)loginUserModel {
    BOOL isCompetence = (loginUserModel.status == KTVUserStatusActive || loginUserModel.userRole == KTVUserRoleHost);
    if (isCompetence &&
        [songModel.pickedUserID isEqualToString:loginUserModel.uid]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)startWithSongModel:(KTVSongModel *)songModel
            loginUserModel:(KTVUserModel *)loginUserModel {
    NSString *aboveSongID = [NSString stringWithFormat:@"%@_%@", _aboveSongModel.musicId, _aboveSongModel.pickedUserID];
    NSString *songID = [NSString stringWithFormat:@"%@_%@", songModel.musicId, songModel.pickedUserID];
    
    if ([aboveSongID isEqualToString:songID]) {
        // 如果是相同歌曲，相同演唱者丢弃该消息
        return;
    } else {
        // 切歌时会下发新歌，演唱者需要先暂停上一首歌。
        if ([_aboveSongModel.pickedUserID isEqualToString:[LocalUserComponent userModel].uid]) {
            [[KTVRTCManager shareRtc] enableEarMonitor:NO];
            [[KTVRTCManager shareRtc] stopSinging];
        }
    }
    
    [self.musicView updateTopWithSongModel:songModel
                            loginUserModel:loginUserModel];
    
    __weak __typeof(self) wself = self;
    [self.musicView updateLrcHidden:YES];
    [KTVPickSongManager requestDownSongModel:songModel complete:^(KTVDownloadSongModel * _Nonnull downloadSongModel) {
        // LRC
        [KTVPickSongManager getLRCFilePath:downloadSongModel
                                  complete:^(NSString * _Nonnull filePath) {
            if (NOEmptyStr(filePath)) {
                // Initialize lyrics
                [wself.musicView updateLrcHidden:NO];
                [wself.musicView loadLrcByPath:filePath];
                // Singer
                if ([wself isSingerWithSongModel:songModel
                                  loginUserModel:loginUserModel]) {
                    [[KTVRTCManager shareRtc] sendStreamSyncTime:@"0"];
                }
            } else {
                NSLog(@"歌词下载失败，请稍后再试");
            }
        }];
        
        // Music
        if ([wself isSingerWithSongModel:songModel
                         loginUserModel:loginUserModel]) {
            [KTVPickSongManager getMP3FilePath:downloadSongModel
                                      complete:^(NSString * _Nonnull filePath) {
                [[KTVRTCManager shareRtc] startStartSinging:filePath];
                [[KTVRTCManager shareRtc] switchAccompaniment:YES];
                [[KTVRTCManager shareRtc] setMusicVolume:10];
                [[ToastComponent shareToastComponent] showWithMessage:@"开始演唱吧"];
                [wself.musicView resetTuningView];
            }];
        }
    }];
}


#pragma mark - Getter

- (KTVMusicNullView *)musicNullView {
    if (!_musicNullView) {
        _musicNullView = [[KTVMusicNullView alloc] init];
        _musicNullView.backgroundColor = [UIColor clearColor];
        _musicNullView.hidden = NO;
    }
    return _musicNullView;
}

- (KTVMusicView *)musicView {
    if (!_musicView) {
        _musicView = [[KTVMusicView alloc] init];
        _musicView.musicDelegate = self;
        [_musicView setBackgroundColor:[UIColor clearColor]];
        _musicView.hidden = YES;
    }
    return _musicView;
}

- (KTVMusicEndView *)musicEndView {
    if (!_musicEndView) {
        _musicEndView = [[KTVMusicEndView alloc] init];
        [_musicEndView setBackgroundColor:[UIColor clearColor]];
        _musicEndView.hidden = YES;
    }
    return _musicEndView;
}

@end
