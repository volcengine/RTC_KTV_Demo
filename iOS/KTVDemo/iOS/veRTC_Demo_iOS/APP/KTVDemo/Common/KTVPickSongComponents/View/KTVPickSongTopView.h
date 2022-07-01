//
//  KTVPickSongTopView.h
//  veRTC_Demo
//
//  Created by bytedance on 2022/1/19.
//  Copyright © 2022 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KTVPickSongTopView : UIView

@property (nonatomic, copy) void(^selectedChangedBlock)(NSInteger index);

- (void)updatePickedSongCount:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
