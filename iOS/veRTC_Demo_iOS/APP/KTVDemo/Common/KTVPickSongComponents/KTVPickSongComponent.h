//
//  KTVPickSongComponent.h
//  veRTC_Demo
//
//  Created by bytedance on 2022/1/18.
//  Copyright © 2022 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KTVPickSongComponent;

NS_ASSUME_NONNULL_BEGIN

@protocol KTVPickSongComponentDelegate <NSObject>

- (void)ktvPickSongComponent:(KTVPickSongComponent *)componment pickedSongCountChanged:(NSInteger)count;

@end

@interface KTVPickSongComponent : NSObject

@property (nonatomic, weak) id<KTVPickSongComponentDelegate> delegate;

- (instancetype)initWithSuperView:(UIView *)superView roomID:(NSString *)roomID;

- (void)show;

/// Update pieked song list
- (void)updatePickedSongList;

@end

NS_ASSUME_NONNULL_END
