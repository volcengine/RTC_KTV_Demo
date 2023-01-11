//
//  KTVMusicView.m
//  veRTC_Demo
//
//  Created by on 2021/11/30.
//  
//

#import "KTVMusicView.h"
#import "KTVMusicTuningView.h"
#import "KTVMusicTopView.h"
#import "KTVMusicLyricsView.h"
#import "KTVPickSongManager.h"
#import "KTVRTMManager.h"
#import "KTVRTCManager.h"

@interface KTVMusicView ()

@property (nonatomic, strong) UIImageView *maskImageView;
@property (nonatomic, strong) KTVMusicTopView *topView;
@property (nonatomic, strong) KTVMusicLyricsView *lyricsView;
@property (nonatomic, strong) KTVMusicTuningView *tuningView;
@property (nonatomic, strong) UIButton *maskButton;

@end

@implementation KTVMusicView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubviewAndConstraints];
        
        __weak __typeof(self) wself = self;
        self.topView.clickButtonBlock = ^(MusicTopState state, BOOL isSelect) {
            [wself topViewClick:state isSelect:isSelect];
        };
    }
    return self;
}

#pragma mark - Publish Action

- (void)updateTopWithSongModel:(KTVSongModel *)songModel
                loginUserModel:(KTVUserModel *)loginUserModel {
    [self.topView updateWithSongModel:songModel
                       loginUserModel:loginUserModel];
}

- (void)resetTuningView {
    [self.tuningView resetUI];
}

- (void)loadLrcByPath:(NSString *)filePath  {
    [self.lyricsView loadLrcByPath:filePath error:nil];
    [self.lyricsView playAtTime:0];
}

- (void)setTime:(NSTimeInterval)time {
    _time = time;
    
    self.topView.time = time;
    [self.lyricsView playAtTime:time];
}

- (void)dismissTuningPanel {
    [self maskButtonAction];
}

/// 音频播放路由改变
- (void)updateAudioRouteChanged {
    [self.tuningView updateAudioRouteChanged];
}

- (void)updateLrcHidden:(BOOL)isHidden {
    self.lyricsView.hidden = isHidden;
    if (isHidden) {
        [self.lyricsView resetStatus];
    }
}

#pragma mark - Private Action

- (void)maskButtonAction {
    self.maskButton.hidden = YES;
    [self.maskButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.maskButton.superview).offset(SCREEN_HEIGHT);
    }];
}

- (void)topViewClick:(MusicTopState)state isSelect:(BOOL)isSelect {
    if (state == MusicTopStateOriginal) {
        [[KTVRTCManager shareRtc] switchAccompaniment:!isSelect];
        if (isSelect) {
            [[ToastComponent shareToastComponent] showWithMessage:@"已开启原唱"];
        } else {
            [[ToastComponent shareToastComponent] showWithMessage:@"已开启伴奏"];
        }
    } else if (state == MusicTopStateTuning) {
        [self tuningViewShow];
    } else if (state == MusicTopStatePause) {
        if (isSelect) {
            [[KTVRTCManager shareRtc] pauseSinging];
        } else {
            [[KTVRTCManager shareRtc] resumeSinging];
        }
    } else if (state == MusicTopStateNext) {
        if ([self.musicDelegate respondsToSelector:@selector(musicViewdelegate:topViewClickCut:)]) {
            [self.musicDelegate musicViewdelegate:self topViewClickCut:YES];
        }
    } else {
        
    }
}

- (void)addSubviewAndConstraints {
    [self addSubview:self.maskImageView];
    [self addSubview:self.topView];
    [self addSubview:self.lyricsView];
    
    [self.maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(72);
    }];
    
    [self.lyricsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.topView.mas_bottom);
    }];
    
    UIView *keyView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [keyView addSubview:self.maskButton];
    [self.maskButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.height.equalTo(keyView);
        make.top.equalTo(keyView).offset(SCREEN_HEIGHT);
    }];
    
    [self.maskButton addSubview:self.tuningView];
    [self.tuningView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.maskButton);
        make.height.mas_equalTo(372 + [DeviceInforTool getVirtualHomeHeight]);
    }];
}

- (void)tuningViewShow {
    self.maskButton.hidden = NO;
    
    // Start animation
    [self.maskButton.superview layoutIfNeeded];
    [self.maskButton.superview setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.25
                     animations:^{
        [self.maskButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.maskButton.superview).offset(0);
        }];
        [self.maskButton.superview layoutIfNeeded];
    }];
}

#pragma mark - Getter

- (KTVMusicTopView *)topView {
    if (!_topView) {
        _topView = [[KTVMusicTopView alloc] init];
    }
    return _topView;
}

- (KTVMusicLyricsView *)lyricsView {
    if (!_lyricsView) {
        _lyricsView = [[KTVMusicLyricsView alloc] init];
    }
    return _lyricsView;
}

- (KTVMusicTuningView *)tuningView {
    if (!_tuningView) {
        _tuningView = [[KTVMusicTuningView alloc] init];
    }
    return _tuningView;
}

- (UIButton *)maskButton {
    if (!_maskButton) {
        _maskButton = [[UIButton alloc] init];
        [_maskButton addTarget:self action:@selector(maskButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_maskButton setBackgroundColor:[UIColor clearColor]];
    }
    return _maskButton;
}

- (UIImageView *)maskImageView {
    if (!_maskImageView) {
        _maskImageView = [[UIImageView alloc] init];
        _maskImageView.image = [UIImage imageNamed:@"ktv_music_bg" bundleName:HomeBundleName];
        _maskImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _maskImageView;
}

@end
