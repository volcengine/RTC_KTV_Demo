// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import <Foundation/Foundation.h>
@class KTVPickSongComponent;

NS_ASSUME_NONNULL_BEGIN

@protocol KTVPickSongComponentDelegate <NSObject>

- (void)ktvPickSongComponent:(KTVPickSongComponent *)component pickedSongCountChanged:(NSInteger)count;

@end

@interface KTVPickSongComponent : NSObject

@property (nonatomic, weak) id<KTVPickSongComponentDelegate> delegate;

- (instancetype)initWithSuperView:(UIView *)superView roomID:(NSString *)roomID;

- (void)show;

/// Update pieked song list
- (void)updatePickedSongList;

@end

NS_ASSUME_NONNULL_END
