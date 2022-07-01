//#import "SettingsService.h"
#import "KTVRTCManager.h"
#import "AlertActionManager.h"
#import "SystemAuthority.h"

@interface KTVRTCManager () <ByteRTCEngineDelegate>

@property (nonatomic, strong) KTVRoomParamInfoModel *paramInfoModel;
@property (nonatomic, assign) int audioMixingID;
@property (nonatomic, assign) BOOL isAudioMixing;

@end

@implementation KTVRTCManager

+ (KTVRTCManager *_Nullable)shareRtc {
    static KTVRTCManager *rtcManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rtcManager = [[KTVRTCManager alloc] init];
    });
    return rtcManager;
}

#pragma mark - Publish Action

- (void)configeRTCEngine {
    [self.rtcEngineKit setAudioScenario:ByteRTCAudioScenarioMusic];
    [self.rtcEngineKit setUserVisibility:NO];
    self.paramInfoModel.receivedLossRate = @"0";
    self.paramInfoModel.sendLossRate = @"0";
    self.paramInfoModel.rtt = @"0";
    _audioMixingID = 3001;
}

- (void)joinChannelWithToken:(NSString *)token roomID:(NSString *)roomID uid:(NSString *)uid {
    //关闭 本地音频/视频采集
    //Turn on/off local audio capture
    [self.rtcEngineKit stopAudioCapture];
    [self.rtcEngineKit stopVideoCapture];

    //设置音频路由模式，YES 扬声器/NO 听筒
    //Set the audio routing mode, YES speaker/NO earpiece
    [self.rtcEngineKit setAudioPlaybackDevice:ByteRTCAudioPlaybackDeviceSpeakerphone];
    
    //开启/关闭发言者音量键控
    //Turn on/off speaker volume keying
    [self.rtcEngineKit setAudioVolumeIndicationInterval:300];

    //加入房间，开始连麦,需要申请AppId和Token
    //Join the room, start connecting the microphone, you need to apply for AppId and Token
    ByteRTCUserInfo *userInfo = [[ByteRTCUserInfo alloc] init];
    userInfo.userId = uid;
    
    ByteRTCRoomConfig *config = [[ByteRTCRoomConfig alloc] init];
    config.profile = ByteRTCRoomProfileLiveBroadcasting;
    config.isAutoPublish = YES;
    config.isAutoSubscribeAudio = YES;
    
    [self.rtcEngineKit joinRoomByKey:token
                        roomId:roomID
                      userInfo:userInfo
                 rtcRoomConfig:config];
}

- (NSString *_Nullable)getSdkVersion {
    return [ByteRTCEngineKit getSdkVersion];
}

#pragma mark - rtc method

- (void)enableLocalAudio:(BOOL)enable {
    //开启/关闭 本地音频采集
    //Turn on/off local audio capture
    if (enable) {
        [self.rtcEngineKit setUserVisibility:YES];
    } else {
        [self.rtcEngineKit setUserVisibility:NO];
        self.paramInfoModel.receivedLossRate = @"0";
        self.paramInfoModel.sendLossRate = @"0";
        self.paramInfoModel.rtt = @"0";
    }
    
    if (enable) {
        [SystemAuthority authorizationStatusWithType:AuthorizationTypeAudio
                                               block:^(BOOL isAuthorize) {
            if (isAuthorize) {
                NSLog(@"KTV RTC Manager == startAudioCapture");
                [self.rtcEngineKit startAudioCapture];
                [self.rtcEngineKit muteLocalAudio:ByteRTCMuteStateOff];
            }
        }];
    } else {
        NSLog(@"KTV RTC Manager == stopAudioCapture");
        [self.rtcEngineKit stopAudioCapture];
    }
}

- (void)muteLocalAudio:(BOOL)mute {
    //开启/关闭 本地音频采集
    //Turn on/off local audio capture
    [self.rtcEngineKit muteLocalAudio:mute];
}

- (void)leaveChannel {
    // 关闭混音
    // close the mix
    [self stopSinging];
    
    // 耳返恢复默认值
    // The ear return restores the default value
    [self enableEarMonitor:NO];
    [self setEarMonitorVolume:100];
    
    // 离开频道
    // Leave the channel
    [self.rtcEngineKit leaveRoom];
}

- (void)destroy {
    [ByteRTCEngineKit destroy];
    [self.rtcEngineKit destroyEngine];
    self.rtcEngineKit = nil;
}

#pragma mark - Singing Music Method

- (void)startStartSinging:(NSString *)filePath {
    if (IsEmptyStr(filePath)) {
        return;
    }
    self.isAudioMixing = YES;
    ByteRTCAudioMixingManager *audioMixingManager = [self.rtcEngineKit getAudioMixingManager];
    
    ByteRTCAudioMixingConfig *config = [[ByteRTCAudioMixingConfig alloc] init];
    config.type = ByteRTCAudioMixingTypePlayoutAndPublish;
    config.playCount = 1;
    [audioMixingManager startAudioMixing:_audioMixingID
                                filePath:filePath
                                  config:config];
    [audioMixingManager setAudioMixingProgressInterval:_audioMixingID interval:100];
}

- (void)pauseSinging {
    ByteRTCAudioMixingManager *audioMixingManager = [self.rtcEngineKit getAudioMixingManager];
    
    [audioMixingManager pauseAudioMixing:_audioMixingID];
}

- (void)resumeSinging {
    ByteRTCAudioMixingManager *audioMixingManager = [self.rtcEngineKit getAudioMixingManager];
    
    [audioMixingManager resumeAudioMixing:_audioMixingID];
}

- (void)stopSinging {
    self.isAudioMixing = NO;
    ByteRTCAudioMixingManager *audioMixingManager = [self.rtcEngineKit getAudioMixingManager];
    
    [audioMixingManager stopAudioMixing:_audioMixingID];
}

- (void)resetAudioMixingStatus {
    self.isAudioMixing = NO;
}

- (void)switchAccompaniment:(BOOL)isAccompaniment {
    ByteRTCAudioMixingManager *audioMixingManager = [self.rtcEngineKit getAudioMixingManager];
    
    if (isAccompaniment) {
        [audioMixingManager setAudioMixingDualMonoMode:_audioMixingID
                                                  mode:ByteRTCAudioMixingDualMonoModeR];
    } else {
        [audioMixingManager setAudioMixingDualMonoMode:_audioMixingID
                                                  mode:ByteRTCAudioMixingDualMonoModeL];
    }
}

- (void)sendStreamSyncTime:(NSString *)time {
    NSData *data = [time dataUsingEncoding:NSUTF8StringEncoding];
    ByteRTCStreamSycnInfoConfig *config = [[ByteRTCStreamSycnInfoConfig alloc] init];
    [self.rtcEngineKit sendStreamSyncInfo:data config:config];
}

- (void)setVoiceReverbType:(ByteRTCVoiceReverbType)reverbType {
    [self.rtcEngineKit setVoiceReverbType:reverbType];
}

- (void)enableEarMonitor:(BOOL)isEnable {
    [self.rtcEngineKit setEarMonitorMode:isEnable ? ByteRTCEarMonitorModeOn : ByteRTCEarMonitorModeOff];
}

- (void)setEarMonitorVolume:(NSInteger)volume {
    [self.rtcEngineKit setEarMonitorVolume:volume];
}

- (void)setRecordingVolume:(NSInteger)volume {
    [self.rtcEngineKit setCaptureVolume:ByteRTCStreamIndexMain volume:(int)volume];
}

- (void)setMusicVolume:(NSInteger)volume {
    ByteRTCAudioMixingManager *audioMixingManager = [self.rtcEngineKit getAudioMixingManager];
    
    [audioMixingManager setAudioMixingVolume:_audioMixingID volume:(int)volume type:ByteRTCAudioMixingTypePlayoutAndPublish];
}

- (void)rtcEngine:(ByteRTCEngineKit *)engine onStreamSyncInfoReceived:(ByteRTCRemoteStreamKey *)remoteStreamKey streamType:(ByteRTCSyncInfoStreamType)streamType data:(NSData *)data {
    // 切歌够开始本地播放依然能够收到回调导致歌词闪烁
    // Cut the song enough to start local playback and still be able to receive callbacks causing the lyrics to flicker
    if (self.isAudioMixing) {
        return;
    }
    
    NSString *time = [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
    
    if ([self.delegate respondsToSelector:@selector(KTVRTCManager:onStreamSyncInfoReceived:)]) {
        [self.delegate KTVRTCManager:self onStreamSyncInfoReceived:time];
    }
}

- (void)rtcEngine:(ByteRTCEngineKit *)engine onAudioMixingStateChanged:(NSInteger)id state:(ByteRTCAudioMixingState)state error:(ByteRTCAudioMixingError)error {
    if (state == ByteRTCAudioMixingStateFinished) {
        dispatch_queue_async_safe(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(KTVRTCManager:songEnds:)]) {
                [self.delegate KTVRTCManager:self songEnds:YES];
            }
        });
    }
}

- (void)rtcEngine:(ByteRTCEngineKit * _Nonnull)engine
    onAudioMixingPlayingProgress:(NSInteger)id
    progress:(int64_t) progress {
        if ([self.delegate respondsToSelector:@selector(KTVRTCManager:onAudioMixingPlayingProgress:)]) {
            [self.delegate KTVRTCManager:self onAudioMixingPlayingProgress:progress];
        }
}


#pragma mark - ByteRTCEngineDelegate

- (void)rtcEngine:(ByteRTCEngineKit *_Nonnull)engine onLocalStreamStats:(const ByteRTCLocalStreamStats * _Nonnull)stats {
    if (stats.audio_stats.audioLossRate > 0) {
        self.paramInfoModel.sendLossRate = [NSString stringWithFormat:@"%.0f",stats.audio_stats.audioLossRate];
    }
    if (stats.audio_stats.rtt > 0) {
        self.paramInfoModel.rtt = [NSString stringWithFormat:@"%.0ld",(long)stats.audio_stats.rtt];
    }
    [self updateRoomParamInfoModel];
}

- (void)rtcEngine:(ByteRTCEngineKit * _Nonnull)engine onRemoteStreamStats:(const ByteRTCRemoteStreamStats * _Nonnull)stats {
    if (stats.audio_stats.audioLossRate > 0) {
        self.paramInfoModel.receivedLossRate = [NSString stringWithFormat:@"%.0f",stats.audio_stats.audioLossRate];
    }
    [self updateRoomParamInfoModel];
}

- (void)rtcEngine:(ByteRTCEngineKit * _Nonnull)engine onAudioVolumeIndication:(NSArray<ByteRTCAudioVolumeInfo *> * _Nonnull)speakers totalRemoteVolume:(NSInteger)totalRemoteVolume {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < speakers.count; i++) {
        ByteRTCAudioVolumeInfo *model = speakers[i];
        [dic setValue:@(model.linearVolume) forKey:model.uid];
    }
    if ([self.delegate respondsToSelector:@selector(KTVRTCManager:reportAllAudioVolume:)]) {
        [self.delegate KTVRTCManager:self reportAllAudioVolume:dic];
    }
}

#pragma mark - Private Action

- (void)updateRoomParamInfoModel {
    dispatch_queue_async_safe(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(KTVRTCManager:changeParamInfo:)]) {
            [self.delegate KTVRTCManager:self changeParamInfo:self.paramInfoModel];
        }
    });
}


#pragma mark - getter

- (KTVRoomParamInfoModel *)paramInfoModel {
    if (!_paramInfoModel) {
        _paramInfoModel = [[KTVRoomParamInfoModel alloc] init];
    }
    return _paramInfoModel;
}

@end
