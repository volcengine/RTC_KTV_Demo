//
//  KTVHiFiveManager.h
//  veRTC_Demo
//
//  Created by on 2022/1/21.
//  
//

#import <Foundation/Foundation.h>
@class KTVDownloadSongModel;

NS_ASSUME_NONNULL_BEGIN

@interface KTVHiFiveManager : NSObject

/// HiFive register
+ (void)registerHiFive;

/// Request HiFive song list
/// @param complete Callback
+ (void)requestHiFiveSongListComplete:(void(^)(NSArray<KTVSongModel*> *_Nullable list, NSString *_Nullable errorMessage))complete;

/// Request download song model
/// @param songModel Song model
/// @param complete Callback
+ (void)requestDownloadSongModel:(KTVSongModel *)songModel complete:(void(^)(KTVDownloadSongModel *downloadSongModel))complete;

@end

NS_ASSUME_NONNULL_END
