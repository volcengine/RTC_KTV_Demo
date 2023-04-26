// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import <Foundation/Foundation.h>
#import "KTVSongModel.h"
#import "KTVDownloadSongModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KTVPickSongManager : NSObject

- (instancetype)initWithRoomID:(NSString *)roomID;

@property (nonatomic, copy) void(^refreshModelBlock)(KTVSongModel *model);

/// Pick song
/// @param model Song model
- (void)pickSong:(KTVSongModel *)model;

/// Request download song model
/// @param songModel Song model
/// @param complete Callback
+ (void)requestDownSongModel:(KTVSongModel *)songModel complete:(void(^)(KTVDownloadSongModel *downloadSongModel))complete;

/// Get MP3 local file path
/// @param downloadSongModel Download song model
/// @param complete Callback
+ (void)getMP3FilePath:(KTVDownloadSongModel *)downloadSongModel complete:(void(^)(NSString * _Nullable filePath))complete;

/// Get lrc local file path
/// @param downloadSongModel Download song model
/// @param complete Callback
+ (void)getLRCFilePath:(KTVDownloadSongModel *)downloadSongModel complete:(void(^)(NSString * _Nullable filePath))complete;

/// Remove MP3 lrc loacl file
+ (void)removeLocalMusicFile;

@end

NS_ASSUME_NONNULL_END
