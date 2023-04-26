// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import "KTVPickSongTopView.h"

@interface KTVPickSongTopView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *onlineButton;
@property (nonatomic, strong) UIButton *pickedButton;
@property (nonatomic, strong) UIView *selectedView;

@end

@implementation KTVPickSongTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
        
        [self buttonClick:self.onlineButton];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.onlineButton];
    [self addSubview:self.pickedButton];
    [self addSubview:self.selectedView];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.height.mas_equalTo(48);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.titleLabel);
        make.height.mas_equalTo(1);
    }];
    [self.onlineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(48);
        make.right.equalTo(self.mas_centerX);
    }];
    [self.pickedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.mas_centerX);
        make.height.mas_equalTo(48);
    }];
}

#pragma mark - action
- (void)buttonClick:(UIButton *)button {
    NSInteger index = 0;
    if (button == self.onlineButton) {
        [self.pickedButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    } else {
        index = 1;
        [self.onlineButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor colorFromHexString:@"#4080FF"] forState:UIControlStateNormal];
    [self.selectedView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button);
        make.bottom.equalTo(self.onlineButton).offset(-5);
        make.size.mas_equalTo(CGSizeMake(64, 2));
    }];
    
    if (self.selectedChangedBlock) {
        self.selectedChangedBlock(index);
    }
}

- (void)updatePickedSongCount:(NSInteger)count {
    if (count == 0) {
        [_pickedButton setTitle:@"已点歌曲" forState:UIControlStateNormal];
    }
    else {
        [_pickedButton setTitle:[NSString stringWithFormat:@"已点歌曲(%ld)", count] forState:UIControlStateNormal];
    }
}

#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.text = @"点歌台";
    }
    return _titleLabel;
}

- (UIButton *)onlineButton {
    if (!_onlineButton) {
        _onlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _onlineButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_onlineButton setTitle:@"在线曲库" forState:UIControlStateNormal];
        [_onlineButton setTitleColor:[UIColor colorFromHexString:@"#4080FF"] forState:UIControlStateNormal];
        [_onlineButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _onlineButton;
}

- (UIButton *)pickedButton {
    if (!_pickedButton) {
        _pickedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pickedButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_pickedButton setTitle:@"已点歌曲" forState:UIControlStateNormal];
        [_pickedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_pickedButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pickedButton;
}

- (UIView *)selectedView {
    if (!_selectedView) {
        _selectedView = [[UIView alloc] init];
        _selectedView.backgroundColor = [UIColor colorFromHexString:@"#4080FF"];
        _selectedView.layer.cornerRadius = 1;
    }
    return _selectedView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorFromHexString:@"#2A2441"];
    }
    return _lineView;
}

@end
