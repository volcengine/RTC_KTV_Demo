//
//  KTVMusicTuningView.m
//  veRTC_Demo
//
//  Created by bytedance on 2022/1/19.
//  Copyright © 2022 bytedance. All rights reserved.
//

#import "KTVMusicTuningView.h"
#import "KTVMusicReverberationView.h"
#import "KTVRTCManager.h"

@interface KTVMusicTuningView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *earLabel;
@property (nonatomic, strong) UILabel *earTipLabel;
@property (nonatomic, strong) UILabel *earRightLabel;
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UISlider *earSlider;

@property (nonatomic, strong) UILabel *musicLeftLabel;
@property (nonatomic, strong) UILabel *musicRightLabel;
@property (nonatomic, strong) UISlider *musicSlider;

@property (nonatomic, strong) UILabel *vocalLeftLabel;
@property (nonatomic, strong) UILabel *vocalRightLabel;
@property (nonatomic, strong) UISlider *vocalSlider;

@property (nonatomic, strong) UILabel *reverberationLeftLabel;
@property (nonatomic, strong) KTVMusicReverberationView *reverberationView;

@end

@implementation KTVMusicTuningView


- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorFromRGBHexString:@"#0E0825" andAlpha:0.95 * 255];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(48);
            make.centerX.top.equalTo(self);
        }];
        
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(48);
        }];
        
        [self addSubview:self.earLabel];
        [self.earLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(18);
            make.left.mas_equalTo(16);
        }];
        
        [self addSubview:self.switchView];
        [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.earLabel);
            make.left.equalTo(self.earLabel.mas_right).offset(12);
        }];
        
        [self addSubview:self.earTipLabel];
        [self.earTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.switchView);
            make.left.equalTo(self.switchView.mas_right).offset(7);
        }];
        
        [self addSubview:self.earRightLabel];
        [self.earRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.earTipLabel);
            make.right.mas_equalTo(-16);
        }];
        
        [self addSubview:self.earSlider];
        [self.earSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.earLabel.mas_bottom).offset(8);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
        }];
        
        [self addSubview:self.musicLeftLabel];
        [self.musicLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.earLabel.mas_bottom).offset(50);
            make.left.mas_equalTo(16);
        }];

        [self addSubview:self.musicRightLabel];
        [self.musicRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.musicLeftLabel);
            make.right.mas_equalTo(-16);
        }];

        [self addSubview:self.musicSlider];
        [self.musicSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.musicLeftLabel.mas_bottom).offset(8);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
        }];
        
        [self addSubview:self.vocalLeftLabel];
        [self.vocalLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.musicLeftLabel.mas_bottom).offset(48);
            make.left.mas_equalTo(16);
        }];

        [self addSubview:self.vocalRightLabel];
        [self.vocalRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.vocalLeftLabel);
            make.right.mas_equalTo(-16);
        }];

        [self addSubview:self.vocalSlider];
        [self.vocalSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vocalLeftLabel.mas_bottom).offset(8);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
        }];
        
        [self addSubview:self.reverberationLeftLabel];
        [self.reverberationLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vocalLeftLabel.mas_bottom).offset(48);
            make.left.mas_equalTo(16);
        }];
        
        [self addSubview:self.reverberationView];
        [self.reverberationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(50);
            make.top.equalTo(self.vocalLeftLabel.mas_bottom).offset(76);
        }];
        
        [self enableMusicVolume:NO];
    }
    return self;
}

#pragma mark - Publish Action

- (void)resetUI {
    [self.switchView setOn:NO];
    [self.reverberationView resetItemState];
    self.musicSlider.value = 10;
    self.musicRightLabel.text = @"10";
    [[KTVRTCManager shareRtc] setMusicVolume:10];
}

#pragma mark - Private Action

- (void)switchViewChanged:(UISwitch *)sender {
    if (sender.on) {
        [[KTVRTCManager shareRtc] enableEarMonitor:YES];
        [self enableMusicVolume:YES];
    } else {
        [[KTVRTCManager shareRtc] enableEarMonitor:NO];
        [self enableMusicVolume:NO];
    }
}

- (void)enableMusicVolume:(BOOL)isEnable {
    CGFloat alpha = 1;
    if (!isEnable) {
        alpha = 0.34;
        self.earSlider.userInteractionEnabled = NO;
    } else {
        self.earSlider.userInteractionEnabled = YES;
    }
    self.earRightLabel.alpha = alpha;
    self.earSlider.alpha = alpha;
}

- (void)musicSliderValueChanged:(UISlider *)musicSlider {
    [[KTVRTCManager shareRtc] setMusicVolume:musicSlider.value];
    self.musicRightLabel.text = [NSString stringWithFormat:@"%ld", (long)musicSlider.value];
}

- (void)vocalSliderValueChanged:(UISlider *)musicSlider {
    [[KTVRTCManager shareRtc] setRecordingVolume:musicSlider.value];
    self.vocalRightLabel.text = [NSString stringWithFormat:@"%ld", (long)musicSlider.value];
}

- (void)earValueChanged:(UISlider *)musicSlider {
    [[KTVRTCManager shareRtc] setEarMonitorVolume:musicSlider.value];
    self.earRightLabel.text = [NSString stringWithFormat:@"%ld", (long)musicSlider.value];
}

#pragma mark - Getter

- (UILabel *)earLabel {
    if (!_earLabel) {
        _earLabel = [[UILabel alloc] init];
        _earLabel.text = @"耳返";
        _earLabel.font = [UIFont systemFontOfSize:16];
        _earLabel.textColor = [UIColor whiteColor];
    }
    return _earLabel;
}

- (UISwitch *)switchView {
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
        _switchView.onTintColor = [UIColor colorFromHexString:@"#165DFF"];
        [_switchView addTarget:self action:@selector(switchViewChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

- (UISlider *)earSlider {
    if (!_earSlider) {
        _earSlider = [[UISlider alloc] init];
        [_earSlider setTintColor:[UIColor colorFromHexString:@"#4080FF"]];
        [_earSlider addTarget:self action:@selector(earValueChanged:) forControlEvents:UIControlEventValueChanged];
        _earSlider.minimumValue = 0;
        _earSlider.maximumValue = 100;
        _earSlider.value = 100;
    }
    return _earSlider;
}

- (UILabel *)earTipLabel {
    if (!_earTipLabel) {
        _earTipLabel = [[UILabel alloc] init];
        _earTipLabel.text = @"插入耳机后可使用耳返功能";
        _earTipLabel.font = [UIFont systemFontOfSize:14];
        _earTipLabel.textColor = [UIColor colorFromRGBHexString:@"#E5E6EB" andAlpha:0.57 * 255];
    }
    return _earTipLabel;
}

- (UILabel *)earRightLabel {
    if (!_earRightLabel) {
        _earRightLabel = [[UILabel alloc] init];
        _earRightLabel.text = @"100";
        _earRightLabel.font = [UIFont systemFontOfSize:14];
        _earRightLabel.textColor = [UIColor colorFromHexString:@"#FFFFFF"];
    }
    return _earRightLabel;
}

- (UILabel *)musicLeftLabel {
    if (!_musicLeftLabel) {
        _musicLeftLabel = [[UILabel alloc] init];
        _musicLeftLabel.text = @"音乐音量";
        _musicLeftLabel.font = [UIFont systemFontOfSize:14];
        _musicLeftLabel.textColor = [UIColor colorFromHexString:@"#E5E6EB"];
    }
    return _musicLeftLabel;
}

- (UILabel *)musicRightLabel {
    if (!_musicRightLabel) {
        _musicRightLabel = [[UILabel alloc] init];
        _musicRightLabel.text = @"100";
        _musicRightLabel.font = [UIFont systemFontOfSize:14];
        _musicRightLabel.textColor = [UIColor colorFromHexString:@"#FFFFFF"];
    }
    return _musicRightLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"调音";
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor colorFromHexString:@"#FFFFFF"];
    }
    return _titleLabel;
}

- (UISlider *)musicSlider {
    if (!_musicSlider) {
        _musicSlider = [[UISlider alloc] init];
        [_musicSlider setTintColor:[UIColor colorFromHexString:@"#4080FF"]];
        [_musicSlider addTarget:self action:@selector(musicSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        _musicSlider.minimumValue = 0;
        _musicSlider.maximumValue = 100;
        _musicSlider.value = 10;
    }
    return _musicSlider;
}

- (UILabel *)vocalLeftLabel {
    if (!_vocalLeftLabel) {
        _vocalLeftLabel = [[UILabel alloc] init];
        _vocalLeftLabel.text = @"人声音量";
        _vocalLeftLabel.font = [UIFont systemFontOfSize:14];
        _vocalLeftLabel.textColor = [UIColor colorFromHexString:@"#E5E6EB"];
    }
    return _vocalLeftLabel;
}

- (UILabel *)reverberationLeftLabel {
    if (!_reverberationLeftLabel) {
        _reverberationLeftLabel = [[UILabel alloc] init];
        _reverberationLeftLabel.text = @"混响";
        _reverberationLeftLabel.font = [UIFont systemFontOfSize:14];
        _reverberationLeftLabel.textColor = [UIColor colorFromHexString:@"#E5E6EB"];
    }
    return _reverberationLeftLabel;
}

- (UILabel *)vocalRightLabel {
    if (!_vocalRightLabel) {
        _vocalRightLabel = [[UILabel alloc] init];
        _vocalRightLabel.text = @"100";
        _vocalRightLabel.font = [UIFont systemFontOfSize:14];
        _vocalRightLabel.textColor = [UIColor colorFromHexString:@"#FFFFFF"];
    }
    return _vocalRightLabel;
}

- (UISlider *)vocalSlider {
    if (!_vocalSlider) {
        _vocalSlider = [[UISlider alloc] init];
        [_vocalSlider setTintColor:[UIColor colorFromHexString:@"#4080FF"]];
        [_vocalSlider addTarget:self action:@selector(vocalSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        _vocalSlider.minimumValue = 0;
        _vocalSlider.maximumValue = 100;
        _vocalSlider.value = 100;
    }
    return _vocalSlider;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorFromRGBHexString:@"#2A2441"];
    }
    return _lineView;
}

- (KTVMusicReverberationView *)reverberationView {
    if (!_reverberationView) {
        _reverberationView = [[KTVMusicReverberationView alloc] init];
    }
    return _reverberationView;
}


@end
