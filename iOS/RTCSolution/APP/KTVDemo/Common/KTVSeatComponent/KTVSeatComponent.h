// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import <Foundation/Foundation.h>
#import "KTVSheetView.h"
@class KTVSeatComponent;

NS_ASSUME_NONNULL_BEGIN

@protocol KTVSeatDelegate <NSObject>

- (void)KTVSeatComponent:(KTVSeatComponent *)KTVSeatComponent
                    clickButton:(KTVSeatModel *)seatModel
                    sheetStatus:(KTVSheetStatus)sheetStatus;

@end

@interface KTVSeatComponent : NSObject

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
