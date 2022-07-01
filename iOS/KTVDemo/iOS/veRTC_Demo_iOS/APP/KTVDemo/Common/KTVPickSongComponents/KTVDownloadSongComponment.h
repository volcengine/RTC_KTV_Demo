//
//  KTVDownloadSongComponment.h
//  veRTC_Demo
//
//  Created by bytedance on 2022/1/20.
//  Copyright © 2022 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KTVDownloadSongComponment : NSObject

/// Download file
/// @param urlString URL string
/// @param filePath Local file path
/// @param downloadProgressBlock Download progress callback
/// @param complete Callback
+ (void)downloadWithURL:(NSString *)urlString filePath:(NSString *)filePath progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock complete:(void(^)(NSError *error))complete;


@end

NS_ASSUME_NONNULL_END
