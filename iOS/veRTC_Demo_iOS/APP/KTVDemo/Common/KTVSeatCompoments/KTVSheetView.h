//
//  KTVSheetView.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/12/1.
//  Copyright © 2021 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTVSeatItemButton.h"
@class KTVSheetView;

NS_ASSUME_NONNULL_BEGIN

@protocol KTVSheetViewDelegate <NSObject>

- (void)KTVSheetView:(KTVSheetView *)KTVSheetView
               clickButton:(KTVSheetStatus)sheetState;

@end

@interface KTVSheetView : UIView

@property (nonatomic, weak) id <KTVSheetViewDelegate> delegate;

- (void)showWithSeatModel:(KTVSeatModel *)seatModel
           loginUserModel:(KTVUserModel *)loginUserModel;

- (void)dismiss;

@property (nonatomic, strong, readonly) KTVSeatModel *seatModel;

@property (nonatomic, strong, readonly) KTVUserModel *loginUserModel;

@end

NS_ASSUME_NONNULL_END
