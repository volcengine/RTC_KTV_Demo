// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import "KTVSeatItemView.h"
#import "KTVSeatModel.h"
#import "KTVSongModel.h"

typedef NS_ENUM(NSInteger, KTVSeatItemStatue) {
    KTVSeatItemStatueNull = 0,
    KTVSeatItemStatueLock,
    KTVSeatItemStatueUser,
    KTVSeatItemStatueUserAndSpeak,
    KTVSeatItemStatueMuteMic,
};

@interface KTVSeatItemView ()

@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, strong) UILabel *avatarLabel;
@property (nonatomic, strong) UIImageView *avatarBgImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) KTVSongModel *songModel;

@end

@implementation KTVSeatItemView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.animationView];
        [self addSubview:self.avatarBgImageView];
        [self addSubview:self.avatarLabel];
        [self addSubview:self.userNameLabel];
        [self addSubview:self.maskView];
        [self addSubview:self.centerImageView];
        
        [self.avatarBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(32, 32));
            make.top.mas_equalTo(5);
            make.centerX.equalTo(self);
        }];
        
        [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.avatarBgImageView);
        }];
        
        [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.avatarBgImageView);
            make.width.height.mas_equalTo(42);
        }];
        
        [self.avatarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.avatarBgImageView);
        }];
        
        [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(self);
            make.left.greaterThanOrEqualTo(self);
            make.right.lessThanOrEqualTo(self);
        }];
        
        [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.center.equalTo(self.avatarBgImageView);
        }];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setSeatModel:(KTVSeatModel *)seatModel {
    _seatModel = seatModel;
    if (seatModel) {
        if (seatModel.status == 1) {
            //unlock
            if (NOEmptyStr(seatModel.userModel.uid)) {
                if (seatModel.userModel.mic == KTVUserMicOn) {
                    if (seatModel.userModel.isSpeak) {
                        [self updateUI:KTVSeatItemStatueUserAndSpeak seatModel:seatModel];
                    } else {
                        [self updateUI:KTVSeatItemStatueUser seatModel:seatModel];
                    }
                } else {
                    [self updateUI:KTVSeatItemStatueMuteMic seatModel:seatModel];
                }
            } else {
                [self updateUI:KTVSeatItemStatueNull seatModel:seatModel];
            }
        } else {
            //lock
            [self updateUI:KTVSeatItemStatueLock seatModel:seatModel];
        }
    } else {
        [self updateUI:KTVSeatItemStatueNull seatModel:seatModel];
    }
}

- (void)updateUI:(KTVSeatItemStatue)statue
       seatModel:(KTVSeatModel *)seatModel {
    self.animationView.hidden = YES;
    self.maskView.hidden = YES;
    
    if (statue == KTVSeatItemStatueNull) {
        self.avatarBgImageView.image = nil;
        self.avatarBgImageView.backgroundColor = [UIColor colorFromRGBHexString:@"#FFFFFF" andAlpha:0.3 * 255];
        self.centerImageView.image = [UIImage imageNamed:@"KTV_seat_null" bundleName:HomeBundleName];
        self.centerImageView.hidden = NO;
        self.avatarLabel.text = @"";
        self.userNameLabel.text = [NSString stringWithFormat:@"%ld", (long)(seatModel.index)];
    } else if (statue == KTVSeatItemStatueLock) {
        self.avatarBgImageView.image = nil;
        self.avatarBgImageView.backgroundColor = [UIColor colorFromRGBHexString:@"#FFFFFF" andAlpha:0.3 * 255];
        self.centerImageView.image = [UIImage imageNamed:@"KTV_seat_lock" bundleName:HomeBundleName];
        self.centerImageView.hidden = NO;
        self.avatarLabel.text = @"";
        self.userNameLabel.text = [NSString stringWithFormat:@"%ld", (long)(seatModel.index)];
    } else if (statue == KTVSeatItemStatueUser) {
        self.avatarBgImageView.backgroundColor = [UIColor clearColor];
        self.avatarBgImageView.image = [UIImage imageNamed:@"KTV_small_bg" bundleName:HomeBundleName];
        self.avatarLabel.text = [seatModel.userModel.name substringToIndex:1];
        self.centerImageView.hidden = YES;
        [self updateUserNameUI];
    } else if (statue == KTVSeatItemStatueUserAndSpeak) {
        self.avatarBgImageView.backgroundColor = [UIColor clearColor];
        self.avatarBgImageView.image = [UIImage imageNamed:@"KTV_border_small" bundleName:HomeBundleName];
        self.avatarLabel.text = [seatModel.userModel.name substringToIndex:1];
        self.centerImageView.hidden = YES;
        [self updateUserNameUI];
        
        self.animationView.hidden = NO;
    } else if (statue == KTVSeatItemStatueMuteMic) {
        self.avatarBgImageView.backgroundColor = [UIColor clearColor];
        self.avatarBgImageView.image = [UIImage imageNamed:@"KTV_small_bg" bundleName:HomeBundleName];
        self.centerImageView.hidden = YES;
        self.avatarLabel.text = [seatModel.userModel.name substringToIndex:1];
        self.centerImageView.image = [UIImage imageNamed:@"KTV_seat_mic" bundleName:HomeBundleName];
        self.centerImageView.hidden = NO;
        self.maskView.hidden = NO;
        [self updateUserNameUI];
    } else {
        //error
    }
}

- (void)updateUserNameUI {
    if (NOEmptyStr(_seatModel.userModel.uid)) {
        if ([_seatModel.userModel.uid isEqualToString:_songModel.pickedUserID]) {
            self.userNameLabel.text = @"演唱者";
        }
        else {
            self.userNameLabel.text = _seatModel.userModel.name;
        }
    }
}

- (void)updateCurrentSongModel:(KTVSongModel *)songModel {
    self.songModel = songModel;
    [self updateUserNameUI];
}

- (void)tapAction {
    if (self.clickBlock) {
        self.clickBlock(self.seatModel);
    }
}

- (void)addWiggleAnimation:(UIView *)view {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.81), @(1.0), @(1.0)];
    animation.keyTimes = @[@(0), @(0.27), @(1.0)];
    
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    animation2.values = @[@(0), @(0.2), @(0.4), @(0.2)];
    animation2.keyTimes = @[@(0), @(0.27), @(0.27), @(1.0)];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation,animation2];
    group.duration = 1.1;
    group.repeatCount = MAXFLOAT;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:group forKey:@"transformKey"];
}

#pragma mark - getter

- (UIView *)animationView {
    if (!_animationView) {
        _animationView = [[UIView alloc] init];
        _animationView.backgroundColor = [UIColor colorFromRGBHexString:@"#F93D89"];
        _animationView.layer.cornerRadius = 42 / 2;
        _animationView.layer.masksToBounds = YES;
        _animationView.hidden = YES;
        [self addWiggleAnimation:_animationView];
    }
    return _animationView;
}

- (UIImageView *)avatarBgImageView {
    if (!_avatarBgImageView) {
        _avatarBgImageView = [[UIImageView alloc] init];
        _avatarBgImageView.layer.cornerRadius = 32 / 2;
        _avatarBgImageView.layer.masksToBounds = YES;
    }
    return _avatarBgImageView;
}

- (UILabel *)avatarLabel {
    if (!_avatarLabel) {
        _avatarLabel = [[UILabel alloc] init];
        _avatarLabel.textColor = [UIColor colorFromHexString:@"#FFFFFF"];
        _avatarLabel.font = [UIFont systemFontOfSize:14.5];
    }
    return _avatarLabel;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.textColor = [UIColor colorFromHexString:@"#F2F3F5"];
        _userNameLabel.font = [UIFont systemFontOfSize:12];
    }
    return _userNameLabel;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorFromRGBHexString:@"#040404" andAlpha:0.8 * 255];
        _maskView.layer.cornerRadius = 16;
        _maskView.layer.masksToBounds = YES;
        _maskView.hidden = YES;
    }
    return _maskView;
}

- (UIImageView *)centerImageView {
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc] init];
    }
    return _centerImageView;
}

@end
