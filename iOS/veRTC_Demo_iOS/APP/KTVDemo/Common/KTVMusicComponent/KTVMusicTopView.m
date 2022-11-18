//
//  KTVMusicTopView.m
//  veRTC_Demo
//
//  Created by on 2022/1/19.
//  
//

#import "KTVMusicTopView.h"

@interface KTVMusicTopView ()

@property (nonatomic, strong) UIImageView *scoreImageView;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *musicTitleLabel;
@property (nonatomic, strong) UILabel *musicTimeLabel;
@property (nonatomic, strong) BaseButton *nextButton;
@property (nonatomic, strong) BaseButton *pauseButton;
@property (nonatomic, strong) BaseButton *tuningButton;
@property (nonatomic, strong) BaseButton *originalButton;

@property (nonatomic, strong) KTVSongModel *songModel;

@end

@implementation KTVMusicTopView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.scoreImageView];
        [self addSubview:self.scoreLabel];
        [self addSubview:self.musicTitleLabel];
        [self addSubview:self.musicTimeLabel];
        [self addSubview:self.nextButton];
        [self addSubview:self.pauseButton];
        [self addSubview:self.tuningButton];
        [self addSubview:self.originalButton];
        
        [self.scoreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(62, 62));
            make.centerY.equalTo(self);
            make.left.mas_equalTo(16);
        }];
        
        [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.scoreImageView).offset(1);
            make.centerY.equalTo(self.scoreImageView).offset(-2);
        }];
        
        [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 36));
            make.top.mas_equalTo(28);
            make.right.mas_equalTo(-16);
        }];
        
        [self.pauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 36));
            make.top.mas_equalTo(28);
            make.right.equalTo(self.nextButton.mas_left).offset(-20);
        }];
        
        [self.tuningButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 36));
            make.top.mas_equalTo(28);
            make.right.equalTo(self.pauseButton.mas_left).offset(-20);
        }];
        
        [self.originalButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 36));
            make.top.mas_equalTo(28);
            make.right.equalTo(self.tuningButton.mas_left).offset(-20);
        }];
        
        [self.musicTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(32);
            make.left.equalTo(self.scoreImageView.mas_right).offset(11);
            make.right.lessThanOrEqualTo(self.originalButton.mas_left).offset(-5);
        }];
        
        [self.musicTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.musicTitleLabel.mas_bottom).offset(4);
            make.left.equalTo(self.musicTitleLabel);
        }];
        
        [self updateScoreLabel:@"S"];
    }
    return self;
}

#pragma mark - Publish Action

- (void)updateWithSongModel:(KTVSongModel *)songModel
             loginUserModel:(KTVUserModel *)loginUserModel {
    self.songModel = songModel;
    
    if ([self isSingerWithSongModel:songModel
                     loginUserModel:loginUserModel]) {
        // Role Singer
        self.nextButton.hidden = NO;
        self.pauseButton.hidden = NO;
        self.tuningButton.hidden = NO;
        self.originalButton.hidden = NO;
    } else {
        if (loginUserModel.userRole == KTVUserRoleHost) {
            // Role Host
            self.nextButton.hidden = NO;
            self.pauseButton.hidden = YES;
            self.tuningButton.hidden = YES;
            self.originalButton.hidden = YES;
        } else {
            // Role Audience
            self.nextButton.hidden = YES;
            self.pauseButton.hidden = YES;
            self.tuningButton.hidden = YES;
            self.originalButton.hidden = YES;
        }
    }
    
    self.musicTitleLabel.text = songModel.musicName;
    self.originalButton.status = ButtonStatusNone;
    self.pauseButton.status = ButtonStatusNone;
    self.time = 0;
    [self updateScoreLabel:@"S"];
}

- (void)setTime:(NSTimeInterval)time {
    _time = time;
    
    self.musicTimeLabel.text = [NSString stringWithFormat:@"%@ / %@", [self secondsToMinutes:time], [self secondsToMinutes:(long)self.songModel.musicAllTime]];
}

- (NSString *)secondsToMinutes:(NSInteger)allSecond {
    NSInteger minute = allSecond / 60;
    NSInteger second = allSecond - (minute * 60);
    NSString *minuteStr = (minute < 10) ? [NSString stringWithFormat:@"0%ld", minute] : [NSString stringWithFormat:@"%ld", (long)minute];
    NSString *secondStr = (second < 10) ? [NSString stringWithFormat:@"0%ld", second] : [NSString stringWithFormat:@"%ld", (long)second];
    return [NSString stringWithFormat:@"%@:%@", minuteStr, secondStr];
}

- (void)buttonAction:(BaseButton *)sender {
    MusicTopState state = MusicTopStateNone;
    if (sender == self.originalButton) {
        state = MusicTopStateOriginal;
        sender.status = (sender.status == ButtonStatusNone) ? ButtonStatusActive : ButtonStatusNone;
    } else if (sender == self.tuningButton) {
        state = MusicTopStateTuning;
    } else if (sender == self.pauseButton) {
        state = MusicTopStatePause;
        sender.status = (sender.status == ButtonStatusNone) ? ButtonStatusActive : ButtonStatusNone;
    } else if (sender == self.nextButton) {
        state = MusicTopStateNext;
    } else {
        //error
    }
    
    BOOL isSelect = (sender.status == ButtonStatusActive) ? YES : NO;
    if (self.clickButtonBlock) {
        self.clickButtonBlock(state, isSelect);
    }
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

- (void)updateScoreLabel:(NSString *)text {
    NSString *str1 = text;
    NSString *str2 = @"";
    UIFont *font1 = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
    UIFont *font2 = [UIFont systemFontOfSize:8];
    NSString *all = [NSString stringWithFormat:@"%@%@" ,str1, str2];
    NSRange range1 = [all rangeOfString:str1];
    NSRange range2 = [all rangeOfString:str2];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:all];
    
    [string beginEditing];
    [string addAttribute:NSForegroundColorAttributeName
                   value:[UIColor colorFromHexString:@"#FFFFFF"]
                   range:NSMakeRange(0, all.length)];
    [string addAttribute:NSFontAttributeName
                   value:font1
                   range:range1];
    [string addAttribute:NSFontAttributeName
                   value:font2
                   range:range2];
    [string endEditing];

    self.scoreLabel.attributedText = string;
}

#pragma mark - Getter

- (UIImageView *)scoreImageView {
    if (!_scoreImageView) {
        _scoreImageView = [[UIImageView alloc] init];
        
        UIImageView *image1View = [[UIImageView alloc] init];
        image1View.image = [UIImage imageNamed:@"ktv_score_center" bundleName:HomeBundleName];
        [_scoreImageView addSubview:image1View];
        [image1View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(62, 62));
            make.center.equalTo(_scoreImageView);
        }];
        
        UIImageView *image2View = [[UIImageView alloc] init];
        image2View.image = [UIImage imageNamed:@"ktv_score" bundleName:HomeBundleName];
        [_scoreImageView addSubview:image2View];
        [image2View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(62, 62));
            make.center.equalTo(_scoreImageView);
        }];
    }
    return _scoreImageView;
}

- (UILabel *)scoreLabel {
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
    }
    return _scoreLabel;
}

- (UILabel *)musicTitleLabel {
    if (!_musicTitleLabel) {
        _musicTitleLabel = [[UILabel alloc] init];
        _musicTitleLabel.textColor = [UIColor colorFromRGBHexString:@"#FFFFFF" andAlpha:0.9 * 255];
        _musicTitleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _musicTitleLabel;
}

- (UILabel *)musicTimeLabel {
    if (!_musicTimeLabel) {
        _musicTimeLabel = [[UILabel alloc] init];
        _musicTimeLabel.textColor = [UIColor colorFromRGBHexString:@"#FFFFFF" andAlpha:0.6 * 255];
        _musicTimeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _musicTimeLabel;
}

- (BaseButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[BaseButton alloc] init];
        [_nextButton setImage:[UIImage imageNamed:@"ktv_next" bundleName:HomeBundleName] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

- (BaseButton *)pauseButton {
    if (!_pauseButton) {
        _pauseButton = [[BaseButton alloc] init];
        [_pauseButton bingImage:[UIImage imageNamed:@"ktv_pauser" bundleName:HomeBundleName] status:ButtonStatusNone];
        [_pauseButton bingImage:[UIImage imageNamed:@"ktv_pauser_s" bundleName:HomeBundleName] status:ButtonStatusActive];
        [_pauseButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pauseButton;
}

- (BaseButton *)tuningButton {
    if (!_tuningButton) {
        _tuningButton = [[BaseButton alloc] init];
        [_tuningButton setImage:[UIImage imageNamed:@"ktv_tuning" bundleName:HomeBundleName] forState:UIControlStateNormal];
        [_tuningButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tuningButton;
}

- (BaseButton *)originalButton {
    if (!_originalButton) {
        _originalButton = [[BaseButton alloc] init];
        [_originalButton bingImage:[UIImage imageNamed:@"ktv_switch" bundleName:HomeBundleName] status:ButtonStatusNone];
        [_originalButton bingImage:[UIImage imageNamed:@"ktv_switch_s" bundleName:HomeBundleName] status:ButtonStatusActive];
        [_originalButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _originalButton;
}

@end
