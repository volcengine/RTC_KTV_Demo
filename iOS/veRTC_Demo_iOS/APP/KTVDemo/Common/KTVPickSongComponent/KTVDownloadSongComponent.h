//
//  KTVDownloadSongComponent.h
//  veRTC_Demo
//
//  Created by on 2022/1/20.
//  
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
