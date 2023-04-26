// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KTVDownloadSongComponent : NSObject

/// Download file
/// @param urlString URL string
/// @param filePath Local file path
/// @param downloadProgressBlock Download progress callback
/// @param complete Callback
+ (void)downloadWithURL:(NSString *)urlString filePath:(NSString *)filePath progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock complete:(void(^)(NSError *error))complete;


@end

NS_ASSUME_NONNULL_END
