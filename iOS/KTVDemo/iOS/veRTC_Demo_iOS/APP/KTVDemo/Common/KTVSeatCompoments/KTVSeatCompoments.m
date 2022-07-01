//
//  KTVSeatCompoments.m
//  veRTC_Demo
//
//  Created by bytedance on 2021/12/1.
//  Copyright © 2021 . All rights reserved.
//

#import "KTVSeatCompoments.h"
#import "KTVSeatView.h"
#import "KTVRTMManager.h"

@interface KTVSeatCompoments () <KTVSheetViewDelegate>

@property (nonatomic, weak) KTVSeatView *seatView;
@property (nonatomic, weak) KTVSheetView *sheetView;
@property (nonatomic, weak) UIView *superView;
@property (nonatomic, strong) KTVUserModel *loginUserModel;

@end

@implementation KTVSeatCompoments

- (instancetype)initWithSuperView:(UIView *)superView {
    self = [super init];
    if (self) {
        _superView = superView;
    }
    return self;
}

#pragma mark - Publish Action

- (void)showSeatView:(NSArray<KTVSeatModel *> *)seatList
      loginUserModel:(KTVUserModel *)loginUserModel {
    _loginUserModel = loginUserModel;
    
    if (!_seatView) {
        CGFloat space = (SCREEN_WIDTH - 32 * 7 - 1)/9;
        KTVSeatView *seatView = [[KTVSeatView alloc] init];
        [_superView addSubview:seatView];
        [seatView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_superView);
            make.right.equalTo(_superView).offset(-space);
            make.size.mas_equalTo(CGSizeMake(32*6 + space*5, 55));
        }];
        _seatView = seatView;
    }
    _seatView.seatList = seatList;
    
    __weak __typeof(self) wself = self;
    _seatView.clickBlock = ^(KTVSeatModel * _Nonnull seatModel) {
        KTVSheetView *sheetView = [[KTVSheetView alloc] init];
        sheetView.delegate = wself;
        [wself.superView.superview addSubview:sheetView];
        [sheetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(wself.superView.superview);
        }];
        [sheetView showWithSeatModel:seatModel
                      loginUserModel:wself.loginUserModel];
        wself.sheetView = sheetView;
    };
}

- (void)addSeatModel:(KTVSeatModel *)seatModel {
    [_seatView addSeatModel:seatModel];
    [self updateSeatModel:seatModel];
}

- (void)removeUserModel:(KTVUserModel *)userModel {
    [_seatView removeUserModel:userModel];
    if ([userModel.uid isEqualToString:_loginUserModel.uid]) {
        _loginUserModel = userModel;
    }
    NSString *sheetUid = self.sheetView.seatModel.userModel.uid;
    if (self.sheetView &&
        [userModel.uid isEqualToString:sheetUid]) {
        // update the new one to open the sheet user
        [self.sheetView dismiss];
    }
}

- (void)updateSeatModel:(KTVSeatModel *)seatModel {
    [_seatView updateSeatModel:seatModel];
    if ([seatModel.userModel.uid isEqualToString:_loginUserModel.uid]) {
        _loginUserModel = seatModel.userModel;
    }
    NSString *sheetUid = self.sheetView.seatModel.userModel.uid;
    if (self.sheetView &&
        [seatModel.userModel.uid isEqualToString:sheetUid]) {
        // update the new one to open the sheet user
        [self.sheetView dismiss];
    }
}

- (void)updateSeatVolume:(NSDictionary *)volumeDic {
    [_seatView updateSeatVolume:volumeDic];
}

- (void)updateCurrentSongModel:(KTVSongModel *)songModel {
    [_seatView updateCurrentSongModel:songModel];
}

#pragma mark - KTVSheetViewDelegate

- (void)KTVSheetView:(KTVSheetView *)KTVSheetView
               clickButton:(KTVSheetStatus)sheetState {
    if (sheetState == KTVSheetStatusInvite) {
        if ([self.delegate respondsToSelector:@selector
             (KTVSeatCompoments:clickButton:sheetStatus:)]) {
            [self.delegate KTVSeatCompoments:self
                                       clickButton:KTVSheetView.seatModel
                                       sheetStatus:sheetState];
        }
        [KTVSheetView dismiss];
    } else if (sheetState == KTVSheetStatusKick) {
        [self loadDataManager:5 sheetView:KTVSheetView];
    } else if (sheetState == KTVSheetStatusOpenMic) {
        [self loadDataManager:4 sheetView:KTVSheetView];
    } else if (sheetState == KTVSheetStatusCloseMic) {
        [self loadDataManager:3 sheetView:KTVSheetView];
    } else if (sheetState == KTVSheetStatusLock) {
        [self showAlertWithLockSeat:KTVSheetView];
    } else if (sheetState == KTVSheetStatusUnlock) {
        [self loadDataManager:2 sheetView:KTVSheetView];
    } else if (sheetState == KTVSheetStatusApply) {
        [self loadDataApply:KTVSheetView];
    } else if (sheetState == KTVSheetStatusLeave) {
        [self loadDataLeave:KTVSheetView];
    } else {
        //error
    }
}

#pragma mark - Private Action

- (void)loadDataManager:(NSInteger)type
              sheetView:(KTVSheetView *)KTVSheetView {
    NSString *seatID = [NSString stringWithFormat:@"%ld", (long)KTVSheetView.seatModel.index];
    [KTVRTMManager managerSeat:KTVSheetView.loginUserModel.roomID
                                     seatID:seatID
                                       type:type
                         block:^(RTMACKModel * _Nonnull model) {
        if (!model.result) {
            [[ToastComponents shareToastComponents] showWithMessage:@"操作失败，请重试"];
        } else {
            [KTVSheetView dismiss];
        }
    }];
}

- (void)loadDataApply:(KTVSheetView *)KTVSheetView {
    NSString *seatID = [NSString stringWithFormat:@"%ld", (long)KTVSheetView.seatModel.index];
    [KTVRTMManager applyInteract:KTVSheetView.loginUserModel.roomID
                                       seatID:seatID
                                        block:^(BOOL isNeedApply, RTMACKModel * _Nonnull model) {
  
        if (!model.result) {
            [[ToastComponents shareToastComponents] showWithMessage:model.message];
        } else {
            if (isNeedApply) {
                KTVSheetView.loginUserModel.status = KTVUserStatusApply;
                [[ToastComponents shareToastComponents] showWithMessage:@"已向主播发送申请"];
            }
            [KTVSheetView dismiss];
        }
    }];
}

- (void)loadDataLeave:(KTVSheetView *)KTVSheetView {
    NSString *seatID = [NSString stringWithFormat:@"%ld", (long)KTVSheetView.seatModel.index];
    [KTVRTMManager finishInteract:KTVSheetView.loginUserModel.roomID
                                        seatID:seatID
                                         block:^(RTMACKModel * _Nonnull model) {
   
        if (!model.result) {
            [[ToastComponents shareToastComponents] showWithMessage:@"操作失败，请重试"];
        } else {
            [KTVSheetView dismiss];
        }
    }];
}

- (void)showAlertWithLockSeat:(KTVSheetView *)KTVSheetView {
    AlertActionModel *alertModel = [[AlertActionModel alloc] init];
    alertModel.title = @"确定";
    AlertActionModel *cancelModel = [[AlertActionModel alloc] init];
    cancelModel.title = @"取消";
    [[AlertActionManager shareAlertActionManager] showWithMessage:@"确定封锁麦位？封锁麦位后，观众无法在此麦位上麦； 且此麦位上嘉宾将被下麦" actions:@[ cancelModel, alertModel ]];
    __weak __typeof(self) wself = self;
    alertModel.alertModelClickBlock = ^(UIAlertAction *_Nonnull action) {
        if ([action.title isEqualToString:@"确定"]) {
            [wself loadDataManager:1 sheetView:KTVSheetView];
        }
    };
}



@end
