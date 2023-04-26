// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import "BaseButton.h"

typedef NS_ENUM(NSInteger, KTVSheetStatus) {
    KTVSheetStatusInvite = 0,
    KTVSheetStatusKick,
    KTVSheetStatusOpenMic,
    KTVSheetStatusCloseMic,
    KTVSheetStatusLock,
    KTVSheetStatusUnlock,
    KTVSheetStatusApply,      //观众申请上麦
    KTVSheetStatusLeave,      //嘉宾主动下麦
};

NS_ASSUME_NONNULL_BEGIN

@interface KTVSeatItemButton : BaseButton

@property (nonatomic, copy) NSString *desTitle;

@property (nonatomic, assign) KTVSheetStatus sheetState;

@end

NS_ASSUME_NONNULL_END
