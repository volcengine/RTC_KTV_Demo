//
//  KTVSeatItemView.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/11/29.
//  Copyright © 2021 . All rights reserved.
//

#import <UIKit/UIKit.h>
@class KTVSeatModel;
@class KTVSongModel;

@interface KTVSeatItemView : UIView

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) KTVSeatModel *seatModel;

@property (nonatomic, copy) void (^clickBlock)(KTVSeatModel *seatModel);

- (void)updateCurrentSongModel:(KTVSongModel *)songModel;

@end
