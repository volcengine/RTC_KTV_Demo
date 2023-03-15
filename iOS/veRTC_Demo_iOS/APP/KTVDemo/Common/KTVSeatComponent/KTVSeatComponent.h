//
//  KTVSeatComponent.h
//  veRTC_Demo
//
//  Created by on 2021/12/1.
//  
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

- (void)updateLocalSeatVolume:(NSInteger)volume;

- (void)updateSeatVolume:(NSDictionary *)volumeDic;

- (void)updateCurrentSongModel:(KTVSongModel *)songModel;

@end

NS_ASSUME_NONNULL_END
