//
//  KTVSeatItemButton.h
//  quickstart
//
//  Created by bytedance on 2021/3/24.
//  Copyright © 2021 . All rights reserved.
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
