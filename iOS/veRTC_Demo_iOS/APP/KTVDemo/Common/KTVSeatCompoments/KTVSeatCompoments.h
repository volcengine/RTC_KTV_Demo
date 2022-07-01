//
//  KTVSeatCompoments.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/12/1.
//  Copyright © 2021 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTVSheetView.h"
@class KTVSeatCompoments;

NS_ASSUME_NONNULL_BEGIN

@protocol KTVSeatDelegate <NSObject>

- (void)KTVSeatCompoments:(KTVSeatCompoments *)KTVSeatCompoments
                    clickButton:(KTVSeatModel *)seatModel
                    sheetStatus:(KTVSheetStatus)sheetStatus;

@end

@interface KTVSeatCompoments : NSObject

@property (nonatomic, weak) id<KTVSeatDelegate> delegate;

- (instancetype)initWithSuperView:(UIView *)superView;

- (void)showSeatView:(NSArray<KTVSeatModel *> *)seatList
      loginUserModel:(KTVUserModel *)loginUserModel;

- (void)addSeatModel:(KTVSeatModel *)seatModel;

- (void)removeUserModel:(KTVUserModel *)userModel;

- (void)updateSeatModel:(KTVSeatModel *)seatModel;

- (void)updateSeatVolume:(NSDictionary *)volumeDic;

- (void)updateCurrentSongModel:(KTVSongModel *)songModel;

@end

NS_ASSUME_NONNULL_END
