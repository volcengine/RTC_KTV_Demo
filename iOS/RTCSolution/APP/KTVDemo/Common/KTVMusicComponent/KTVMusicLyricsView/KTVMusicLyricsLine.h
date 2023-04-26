// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KTVMusicLyricsLine : NSObject

@property (nonatomic, assign) NSTimeInterval startTime; // 毫秒

@property (nonatomic, copy) NSString * lrc;

@end

NS_ASSUME_NONNULL_END
