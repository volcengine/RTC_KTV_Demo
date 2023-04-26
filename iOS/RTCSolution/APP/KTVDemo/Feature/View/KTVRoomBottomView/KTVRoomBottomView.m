// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import "KTVRoomBottomView.h"
#import "UIView+Fillet.h"
#import "KTVRTSManager.h"

@interface KTVRoomBottomView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) KTVRoomItemButton *inputButton;
@property (nonatomic, strong) NSMutableArray *buttonLists;
@property (nonatomic, strong) KTVUserModel *loginUserModel;
@property (nonatomic, strong) KTVRoomItemButton *pickSongButton;
@property (nonatomic, strong) UILabel *songCountLabel;

@end

@implementation KTVRoomBottomView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.right.equalTo(self);
            make.width.mas_equalTo(0);
        }];
        
        [self addSubview:self.inputButton];
        [self.inputButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(36);
            make.left.top.equalTo(self);
            make.right.equalTo(self.contentView.mas_left).offset(-18);
        }];
        [self addSubview:self.pickSongButton];
        [self.pickSongButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(82, 36));
        }];
        
        [self addSubviewAndConstraints];
    }
    return self;
}

- (void)inputButtonAction {
    if ([self.delegate respondsToSelector:@selector(KTVRoomBottomView:itemButton:didSelectStatus:)]) {
        [self.delegate KTVRoomBottomView:self itemButton:self.inputButton didSelectStatus:KTVRoomBottomStatusInput];
    }
}

- (void)buttonAction:(KTVRoomItemButton *)sender {
    if ([self.delegate respondsToSelector:@selector(KTVRoomBottomView:itemButton:didSelectStatus:)]) {
        [self.delegate KTVRoomBottomView:self itemButton:sender didSelectStatus:sender.tagNum];
    }
    
    if (sender.tagNum == KTVRoomBottomStatusLocalMic) {
        BOOL isEnableMic = YES;
        if (sender.status == ButtonStatusActive) {
            sender.status = ButtonStatusNone;
            isEnableMic = YES;
        } else {
            sender.status = ButtonStatusActive;
            isEnableMic = NO;
        }
        [self loadDataWithMediaStatus:isEnableMic];
    }
}

- (void)loadDataWithMediaStatus:(BOOL)isEnable {
    [KTVRTSManager updateMediaStatus:_loginUserModel.roomID
                                              mic:isEnable ? 1 : 0
                                            block:^(RTSACKModel * _Nonnull model) {
        if (!model.result) {
            [[ToastComponent shareToastComponent] showWithMessage:@"操作失败，请重试"];
        }
    }];
}

- (void)addSubviewAndConstraints {
    NSInteger groupNum = 4;
    for (int i = 0; i < groupNum; i++) {
        KTVRoomItemButton *button = [[KTVRoomItemButton alloc] init];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonLists addObject:button];
        [self.contentView addSubview:button];
    }
}

#pragma mark - Publish Action

- (void)updateBottomLists:(KTVUserModel *)userModel {
    _loginUserModel = userModel;
    CGFloat itemWidth = 36;
    
    NSArray *status = [self getBottomListsWithModel:userModel];
    NSNumber *number = status.firstObject;
    if (number.integerValue == KTVRoomBottomStatusInput) {
        self.inputButton.hidden = NO;
        NSMutableArray *mutableStatus = [status mutableCopy];
        [mutableStatus removeObjectAtIndex:0];
        status = [mutableStatus copy];
    } else {
        self.inputButton.hidden = YES;
    }
    self.pickSongButton.hidden = ![status containsObject:@(KTVRoomBottomStatusLocalMic)];
    
    NSMutableArray *lists = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.buttonLists.count; i++) {
        KTVRoomItemButton *button = self.buttonLists[i];
        if (i < status.count) {
            NSNumber *number = status[i];
            KTVRoomBottomStatus bottomStatus = number.integerValue;
            
            button.tagNum = bottomStatus;
            NSString *imageName = [self getImageWithStatus:bottomStatus];
            UIImage *image = [UIImage imageNamed:imageName bundleName:HomeBundleName];
            [button bingImage:image status:ButtonStatusNone];
            [button bingImage:[self getSelectImageWithStatus:bottomStatus] status:ButtonStatusActive];
            button.hidden = NO;
            button.status = ButtonStatusNone;
            [lists addObject:button];
        } else {
            button.hidden = YES;
        }
    }
    
    if (lists.count > 1) {
        [lists mas_remakeConstraints:^(MASConstraintMaker *make) {
                
        }];
        [lists mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:itemWidth leadSpacing:0 tailSpacing:0];
        [lists mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.height.mas_equalTo(36);
        }];
    } else {
        KTVRoomItemButton *button = lists.firstObject;
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.height.mas_equalTo(36);
            make.right.equalTo(self.contentView);
            make.width.mas_equalTo(itemWidth);
        }];
    }
    
    CGFloat counentWidth = (itemWidth * status.count) + ((status.count - 1) * 12);
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(counentWidth);
        make.right.equalTo(self).offset(self.pickSongButton.isHidden? 0:-94);
    }];
}

- (void)updateButtonStatus:(KTVRoomBottomStatus)status isSelect:(BOOL)isSelect {
    KTVRoomItemButton *selectButton = nil;
    for (KTVRoomItemButton *button in self.buttonLists) {
        if (button.tagNum == status) {
            selectButton = button;
            break;
        }
    }
    if (selectButton) {
        selectButton.status = isSelect ? ButtonStatusActive : ButtonStatusNone;
    }
}

- (void)updateButtonStatus:(KTVRoomBottomStatus)status isRed:(BOOL)isRed {
    KTVRoomItemButton *selectButton = nil;
    for (KTVRoomItemButton *button in self.buttonLists) {
        if (button.tagNum == status) {
            selectButton = button;
            break;
        }
    }
    if (selectButton) {
        selectButton.isRed = isRed;
    }
}

- (void)updatePickedSongCount:(NSInteger)count {
    self.songCountLabel.hidden = (count == 0);
    if (count < 10) {
        _songCountLabel.font = [UIFont systemFontOfSize:12];
        _songCountLabel.text = @(count).stringValue;
    }
    else if (count < 100) {
        _songCountLabel.font = [UIFont systemFontOfSize:10];
        _songCountLabel.text = @(count).stringValue;
    }
    else {
        _songCountLabel.font = [UIFont systemFontOfSize:8];
        _songCountLabel.text = @"99+";
    }
}

#pragma mark - Private Action

- (NSArray *)getBottomListsWithModel:(KTVUserModel *)userModel {
    NSArray *bottomLists = nil;
    if (KTVUserRoleHost == userModel.userRole) {
        bottomLists = @[@(KTVRoomBottomStatusInput),
                        @(KTVRoomBottomStatusPhone),
                        @(KTVRoomBottomStatusLocalMic),
                        @(KTVRoomBottomStatusEnd)];
    } else {
        if (KTVUserStatusActive == userModel.status) {
            bottomLists = @[@(KTVRoomBottomStatusInput),
                            @(KTVRoomBottomStatusLocalMic),
                            @(KTVRoomBottomStatusEnd)];
        } else {
            bottomLists = @[@(KTVRoomBottomStatusInput),
                            @(KTVRoomBottomStatusEnd)];
        }
    }
    return bottomLists;
}

- (NSString *)getImageWithStatus:(KTVRoomBottomStatus)status {
    NSString *name = @"";
    switch (status) {
        case KTVRoomBottomStatusPhone:
            name = @"KTV_bottom_phone";
            break;
        case KTVRoomBottomStatusMusic:
            name = @"KTV_music";
            break;
        case KTVRoomBottomStatusLocalMic:
            name = @"KTV_bottom_mic";
            break;
        case KTVRoomBottomStatusEnd:
            name = @"KTV_bottom_end";
            break;
        default:
            break;
    }
    return name;
}

- (UIImage *)getSelectImageWithStatus:(KTVRoomBottomStatus)status {
    NSString *name = @"";
    switch (status) {
        case KTVRoomBottomStatusPhone:
            name = @"KTV_bottom_phone";
            break;
        case KTVRoomBottomStatusMusic:
            name = @"KTV_music";
            break;
        case KTVRoomBottomStatusLocalMic:
            name = @"KTV_localmic_s";
            break;
        case KTVRoomBottomStatusEnd:
            name = @"KTV_bottom_end";
            break;
        default:
            break;
    }
    return [UIImage imageNamed:name bundleName:HomeBundleName];
}

- (void)pickSongButtonClick {
    if ([self.delegate respondsToSelector:@selector(KTVRoomBottomView:itemButton:didSelectStatus:)]) {
        [self.delegate KTVRoomBottomView:self itemButton:self.pickSongButton didSelectStatus:KTVRoomBottomStatusPickSong];
    }
}

#pragma mark - getter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

- (NSMutableArray *)buttonLists {
    if (!_buttonLists) {
        _buttonLists = [[NSMutableArray alloc] init];
    }
    return _buttonLists;
}

- (KTVRoomItemButton *)inputButton {
    if (!_inputButton) {
        _inputButton = [[KTVRoomItemButton alloc] init];
        [_inputButton setBackgroundImage:[UIImage imageNamed:@"KTV_input" bundleName:HomeBundleName] forState:UIControlStateNormal];
        [_inputButton addTarget:self action:@selector(inputButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _inputButton.hidden = YES;
    }
    return _inputButton;
}

- (KTVRoomItemButton *)pickSongButton {
    if (!_pickSongButton) {
        _pickSongButton = [[KTVRoomItemButton alloc] initWithFrame:CGRectMake(0, 0, 82, 36)];
        [_pickSongButton addTarget:self action:@selector(pickSongButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_pickSongButton setBackgroundImage:[UIImage imageNamed:@"KTV_pick_song_pick_button" bundleName:HomeBundleName] forState:UIControlStateNormal];
        [_pickSongButton setBackgroundImage:[UIImage imageNamed:@"KTV_pick_song_pick_button" bundleName:HomeBundleName] forState:UIControlStateHighlighted];
        _pickSongButton.hidden = YES;
        [_pickSongButton addSubview:self.songCountLabel];
        [self.songCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_pickSongButton);
            make.centerY.equalTo(_pickSongButton.mas_top);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    return _pickSongButton;
}

- (UILabel *)songCountLabel {
    if (!_songCountLabel) {
        _songCountLabel = [[UILabel alloc] init];
        _songCountLabel.layer.cornerRadius = 10;
        _songCountLabel.layer.masksToBounds = YES;
        _songCountLabel.layer.borderWidth = 2;
        _songCountLabel.layer.borderColor = UIColor.whiteColor.CGColor;
        _songCountLabel.textAlignment = NSTextAlignmentCenter;
        _songCountLabel.font = [UIFont systemFontOfSize:12];
        _songCountLabel.textColor = UIColor.whiteColor;
        _songCountLabel.backgroundColor = [UIColor colorFromHexString:@"#EE77C6"];
        _songCountLabel.hidden = YES;
    }
    return _songCountLabel;
}

@end
