// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import "KTVSheetView.h"

@interface KTVSheetView ()

@property (nonatomic, strong) UIButton *maskButton;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *buttonList;

@end

@implementation KTVSheetView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.maskButton];
        [self.maskButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.left.height.equalTo(self);
            make.top.equalTo(self).offset(SCREEN_HEIGHT);
        }];
        
        [self.maskButton addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.maskButton);
            make.height.mas_equalTo(108 + [DeviceInforTool getVirtualHomeHeight]);
        }];
        
        for (int i = 0; i < 3; i++) {
            KTVSeatItemButton *button = [[KTVSeatItemButton alloc] init];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 24, 0)];
            button.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.contentView addSubview:button];
            [self.buttonList addObject:button];
        }
    }
    return self;
}

- (void)buttonAction:(KTVSeatItemButton *)sender {
    if ([self.delegate respondsToSelector:@selector(KTVSheetView:clickButton:)]) {
        [self.delegate KTVSheetView:self clickButton:sender.sheetState];
    }
}

#pragma mark - Publish Action

- (void)showWithSeatModel:(KTVSeatModel *)seatModel
           loginUserModel:(KTVUserModel *)loginUserModel {
    _seatModel = seatModel;
    _loginUserModel = loginUserModel;
    
    NSArray *statusList = [self getSheetListWithModel:seatModel
                                       loginUserModel:loginUserModel];
    if (statusList.count <= 0) {
        [self dismiss];
        return;
    }
    // Start animation
    [self layoutIfNeeded];
    [self.maskButton.superview setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.25
                     animations:^{
        [self.maskButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
        }];
        [self.maskButton.superview layoutIfNeeded];
    }];
    CGFloat num = statusList.count;
    CGFloat itemWidth = SCREEN_WIDTH / num;
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.buttonList.count; i++) {
        KTVSeatItemButton *button = self.buttonList[i];
        if (i < num) {
            NSNumber *number = statusList[i];
            KTVSheetStatus state = number.integerValue;
            button.hidden = NO;
            UIImage *image = [UIImage imageNamed:[self getImageNameWithStatus:state] bundleName:HomeBundleName];
            [button bingImage:image status:ButtonStatusNone];
            button.desTitle = [self getTitleWithStatus:state];
            button.sheetState = state;
            [list addObject:button];
        } else {
            button.hidden = YES;
        }
    }
    if (list.count <= 1) {
        KTVSeatItemButton *button = self.buttonList.firstObject;
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(20);
            make.height.mas_equalTo(68);
            make.width.mas_equalTo(125);
            make.centerX.equalTo(self.contentView);
        }];
    } else {
        [list mas_remakeConstraints:^(MASConstraintMaker *make) {
                
        }];
        [list mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:itemWidth leadSpacing:0 tailSpacing:0];
        [list mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(20);
            make.height.mas_equalTo(68);
        }];
    }
}

- (void)dismiss {
    [self.maskButton removeFromSuperview];
    self.maskButton = nil;
    
    [self removeFromSuperview];
}

#pragma mark - Private Action

- (NSArray *)getSheetListWithModel:(KTVSeatModel *)seatModel
                    loginUserModel:(KTVUserModel *)loginUserModel {
    NSArray *list = nil;
    if (loginUserModel.userRole == KTVUserRoleHost) {
        if (seatModel) {
            if (seatModel.status == 1) {
                // unlock
                if (NOEmptyStr(seatModel.userModel.uid)) {
                    if (seatModel.userModel.mic) {
                        // 存在用户 下麦 & 静音 & 锁麦
                        list = @[@(KTVSheetStatusKick),
                                 @(KTVSheetStatusCloseMic),
                                 @(KTVSheetStatusLock)];
                    } else {
                        // 存在用户 下麦 & 打开麦克风 & 锁麦
                        list = @[@(KTVSheetStatusKick),
                                 @(KTVSheetStatusOpenMic),
                                 @(KTVSheetStatusLock)];
                    }
                } else {
                    // 不存在用户， 邀请上麦，锁麦
                    list = @[@(KTVSheetStatusInvite),
                             @(KTVSheetStatusLock)];
                }
            } else {
                // lock, 解锁
                list = @[@(KTVSheetStatusUnlock)];
            }
        } else {
            // 麦位为空，邀请上麦 & 锁麦位
            list = @[@(KTVSheetStatusInvite),
                     @(KTVSheetStatusLock)];
        }
    } else {
        if (seatModel.status == 0) {
            // 麦位被锁
        } else {
            if ([loginUserModel.uid isEqualToString:seatModel.userModel.uid]) {
                // 主动下麦
                list = @[@(KTVSheetStatusLeave)];
            } else {
                if (NOEmptyStr(seatModel.userModel.uid)) {
                    // 麦位有人
                } else {
                    if (loginUserModel.status == KTVUserStatusApply) {
                        [[ToastComponent shareToastComponent] showWithMessage:@"已向主播发送申请"];
                    } else if (loginUserModel.status == KTVUserStatusActive) {
                        [[ToastComponent shareToastComponent] showWithMessage:@"你已在麦位上"];
                    } else {
                        // 申请上麦
                        list = @[@(KTVSheetStatusApply)];
                    }
                }
            }
        }
    }
    return list;
}

- (void)maskButtonAction {
    [self dismiss];
}

- (NSString *)getImageNameWithStatus:(KTVSheetStatus)status {
    NSString *name = @"";
    switch (status) {
        case KTVSheetStatusInvite:
            name = @"KTV_sheet_phone";
            break;
        case KTVSheetStatusKick:
            name = @"KTV_sheet_leave";
            break;
        case KTVSheetStatusOpenMic:
            name = @"KTV_sheet_mic_s";
            break;
        case KTVSheetStatusCloseMic:
            name = @"KTV_sheet_mic";
            break;
        case KTVSheetStatusLock:
            name = @"KTV_sheet_lock";
            break;
        case KTVSheetStatusUnlock:
            name = @"KTV_sheet_unlock";
            break;
        case KTVSheetStatusApply:
            name = @"KTV_sheet_phone";
            break;
        case KTVSheetStatusLeave:
            name = @"KTV_sheet_leave";
            break;
        default:
            break;
    }
    return name;
}

- (NSString *)getTitleWithStatus:(KTVSheetStatus)status {
    NSString *name = @"";
    switch (status) {
        case KTVSheetStatusInvite:
            name = @"邀请上麦";
            break;
        case KTVSheetStatusKick:
            name = @"下麦嘉宾";
            break;
        case KTVSheetStatusOpenMic:
            name = @"取消静音";
            break;
        case KTVSheetStatusCloseMic:
            name = @"静音麦位";
            break;
        case KTVSheetStatusLock:
            name = @"封锁麦位";
            break;
        case KTVSheetStatusUnlock:
            name = @"解锁麦位";
            break;
        case KTVSheetStatusApply:
            name = @"上麦";
            break;
        case KTVSheetStatusLeave:
            name = @"下麦";
            break;
        default:
            break;
    }
    return name;
}

#pragma mark - Getter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor colorFromRGBHexString:@"#0E0825" andAlpha:0.95 * 255];
    }
    return _contentView;
}

- (UIButton *)maskButton {
    if (!_maskButton) {
        _maskButton = [[UIButton alloc] init];
        [_maskButton addTarget:self action:@selector(maskButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_maskButton setBackgroundColor:[UIColor clearColor]];
    }
    return _maskButton;
}

- (NSMutableArray *)buttonList {
    if (!_buttonList) {
        _buttonList = [[NSMutableArray alloc] init];
    }
    return _buttonList;
}

- (void)dealloc {
    NSLog(@"dealloc %@",NSStringFromClass([self class]));
}

@end
