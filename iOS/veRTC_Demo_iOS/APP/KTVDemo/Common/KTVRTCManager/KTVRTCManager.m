//#import "SettingsService.h"
#import "KTVRTCManager.h"
#import "AlertActionManager.h"
#import "SystemAuthority.h"

@interface KTVRTCManager () <ByteRTCVideoDelegate>

@property (nonatomic, strong) KTVRoomParamInfoModel *paramInfoModel;
@property (nonatomic, assign) int audioMixingID;
@property (nonatomic, assign) BOOL isAudioMixing;
@property (nonatomic, assign) BOOL isEnableAudioCapture;
@property (nonatomic, assign) ByteRTCAudioRoute currentAudioRoute;

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
    [self.rtcRoom setUserVisibility:NO];
    self.paramInfoModel.rtt = @"0";
    _audioMixingID = 3001;
}

- (void)joinChannelWithToken:(NSString *)token roomID:(NSString *)roomID uid:(NSString *)uid {
    self.isEnableAudioCapture = NO;
    //关闭 本地音频/视频采集
    //Turn on/off local audio capture
    [self.rtcEngineKit stopAudioCapture];
    [self.rtcEngineKit stopVideoCapture];

    //设置音频路由模式，YES 扬声器/NO 听筒
    //Set the audio routing mode, YES speaker/NO earpiece
    [self.rtcEngineKit setDefaultAudioRoute:ByteRTCAudioRouteSpeakerphone];

    //开启/关闭发言者音量键控
    //Turn on/off speaker volume keying
    ByteRTCAudioPropertiesConfig *audioPropertiesConfig = [[ByteRTCAudioPropertiesConfig alloc] init];
    audioPropertiesConfig.interval = 300;
    [self.rtcEngineKit enableAudioPropertiesReport:audioPropertiesConfig];
    
    //加入房间，开始连麦,需要申请AppId和Token
    //Join the room, start connecting the microphone, you need to apply for AppId and Token
    ByteRTCUserInfo *userInfo = [[ByteRTCUserInfo alloc] init];
    userInfo.userId = uid;
    ByteRTCRoomConfig *config = [[ByteRTCRoomConfig alloc] init];
    config.profile = ByteRTCRoomProfileKTV;
    config.isAutoPublish = YES;
    config.isAutoSubscribeAudio = YES;
    self.rtcRoom = [self.rtcEngineKit createRTCRoom:roomID];
    self.rtcRoom.delegate = self;
    [self.rtcRoom joinRoomByToken:token userInfo:userInfo roomConfig:config];
}

- (BOOL)canEarMonitor {
    return _currentAudioRoute == ByteRTCAudioRouteHeadset || _currentAudioRoute == ByteRTCAudioRouteHeadsetUSB;
}

#pragma mark - rtc method

- (void)enableLocalAudio:(BOOL)enable {
    if (enable) {
        [SystemAuthority authorizationStatusWithType:AuthorizationTypeAudio
                                               block:^(BOOL isAuthorize) {
            if (isAuthorize) {
                NSLog(@"KTV RTC Manager == startAudioCapture");
                [self.rtcRoom setUserVisibility:YES];
                [self.rtcRoom publishStream:ByteRTCMediaStreamTypeAudio];
                [self.rtcEngineKit startAudioCapture];
                self.isEnableAudioCapture = YES;
            }
        }];
    } else {
        NSLog(@"KTV RTC Manager == stopAudioCapture");
        [self.rtcRoom setUserVisibility:NO];
        self.isEnableAudioCapture = NO;
        [self.rtcEngineKit stopAudioCapture];
        self.paramInfoModel.rtt = @"0";
    }
}

- (void)muteLocalAudio:(BOOL)mute {
    //开启/关闭 本地音频采集
    //Turn on/off local audio capture
    if (mute) {
        [self.rtcRoom unpublishStream:ByteRTCMediaStreamTypeAudio];
    } else {
        [self.rtcRoom publishStream:ByteRTCMediaStreamTypeAudio];
    }
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
    [self.rtcRoom leaveRoom];
}

#pragma mark - Singing Music Method

- (void)startStartSinging:(NSString *)filePath {
    if (IsEmptyStr(filePath)) {
        return;
    }
    
    [self enableEarMonitor:NO];
    
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

- (void)rtcEngine:(ByteRTCVideo *)engine onStreamSyncInfoReceived:(ByteRTCRemoteStreamKey *)remoteStreamKey streamType:(ByteRTCSyncInfoStreamType)streamType data:(NSData *)data {
    // Cut the song enough to start local playback and still be able to receive callbacks causing the lyrics to flicker
    if (self.isAudioMixing) {
        return;
    }
    
    NSString *time = [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
    
    if ([self.delegate respondsToSelector:@selector(KTVRTCManager:onStreamSyncInfoReceived:)]) {
        [self.delegate KTVRTCManager:self onStreamSyncInfoReceived:time];
    }
}

- (void)rtcEngine:(ByteRTCVideo *)engine onAudioMixingStateChanged:(NSInteger)mixId state:(ByteRTCAudioMixingState)state error:(ByteRTCAudioMixingError)error {
    if (state == ByteRTCAudioMixingStateFinished) {
        dispatch_queue_async_safe(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(KTVRTCManager:songEnds:)]) {
                [self.delegate KTVRTCManager:self songEnds:YES];
            }
        });
    }
}

- (void)rtcEngine:(ByteRTCVideo *)engine onAudioMixingPlayingProgress:(NSInteger)mixId progress:(int64_t)progress {
        if ([self.delegate respondsToSelector:@selector(KTVRTCManager:onAudioMixingPlayingProgress:)]) {
            [self.delegate KTVRTCManager:self onAudioMixingPlayingProgress:progress];
        }
}


#pragma mark - ByteRTCVideoDelegate

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onNetworkQuality:(ByteRTCNetworkQualityStats *)localQuality remoteQualities:(NSArray<ByteRTCNetworkQualityStats *> *)remoteQualities {
    if (self.isEnableAudioCapture) {
        // 开启音频采集的用户，数据传输往返时延。
        // For users who enable audio capture, the round-trip delay of data transmission.
        self.paramInfoModel.rtt = [NSString stringWithFormat:@"%.0ld",(long)localQuality.rtt];
    } else {
        // 关闭音频采集的用户，数据传输往返时延。
        // For users who turn off audio capture, the round-trip delay of data transmission.
        self.paramInfoModel.rtt = [NSString stringWithFormat:@"%.0ld",(long)remoteQualities.firstObject.rtt];
    }
    // 下行网络质量评分
    // Downlink network quality score
    self.paramInfoModel.rxQuality = localQuality.rxQuality;
    
    // 上行网络质量评分
    // Uplink network quality score
    self.paramInfoModel.txQuality = localQuality.txQuality;
    [self updateRoomParamInfoModel];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onRemoteAudioPropertiesReport:(NSArray<ByteRTCRemoteAudioPropertiesInfo *> *)audioPropertiesInfos totalRemoteVolume:(NSInteger)totalRemoteVolume {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < audioPropertiesInfos.count; i++) {
        ByteRTCRemoteAudioPropertiesInfo *model = audioPropertiesInfos[i];
        [dic setValue:@(model.audioPropertiesInfo.linearVolume) forKey:model.streamKey.userId];
    }
    if ([self.delegate respondsToSelector:@selector(KTVRTCManager:reportAllAudioVolume:)]) {
        [self.delegate KTVRTCManager:self reportAllAudioVolume:dic];
    }
}

/**
 * @type callback
 * @region 音频事件回调
 * @author dixing
 * @brief 音频播放路由变化时，收到该回调。
 * @param device 新的音频播放路由，详见 ByteRTCAudioRouteDevice{@link #ByteRTCAudioRouteDevice}
 * @notes 关于音频路由设置，详见 setAudioRoute:{@link #ByteRTCEngineKit#setAudioRoute:}。
 */
- (void)rtcEngine:(ByteRTCVideo *)engine onAudioRouteChanged:(ByteRTCAudioRoute)device {
    _currentAudioRoute = device;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(KTVRTCManagerOnAudioRouteChanged:)]) {
            [self.delegate KTVRTCManagerOnAudioRouteChanged:self];
        }
    });
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
