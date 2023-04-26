// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import "KTVMusicNullView.h"

@interface KTVMusicNullView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) BaseButton *button;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation KTVMusicNullView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(92, 44));
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(6);
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.button.mas_top).offset(-12);
        }];
    }
    return self;
}

#pragma mark - Publish Action

- (void)setLoginUserModel:(KTVUserModel *)loginUserModel {
    _loginUserModel = loginUserModel;

    if (loginUserModel.status == KTVUserStatusActive ||
        loginUserModel.userRole == KTVUserRoleHost) {
        self.titleLabel.text = @"立即点歌开始体验吧";
        self.button.hidden = NO;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.button.mas_top).offset(-12);
        }];
    } else {
        self.titleLabel.text = @"没有歌曲了,快来上麦点歌吧";
        self.button.hidden = YES;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.button.mas_top).offset(44);
        }];
    }
}

- (void)buttonAction {
    if (self.clickPlayMusicBlock) {
        self.clickPlayMusicBlock();
    }
}

#pragma mark - Getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
        _titleLabel.textColor = [UIColor colorFromHexString:@"#EE77C6"];
    }
    return _titleLabel;
}

- (BaseButton *)button {
    if (!_button) {
        _button = [[BaseButton alloc] init];
        [_button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        [_button setBackgroundColor:[UIColor clearColor]];
        [_button setImage:[UIImage imageNamed:@"ktv_play_music" bundleName:HomeBundleName] forState:UIControlStateNormal];
        _button.hidden = YES;
    }
    return _button;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"ktv_null_bg" bundleName:HomeBundleName];
    }
    return _imageView;
}

@end
