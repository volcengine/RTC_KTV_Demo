// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import "KTVPickSongManager.h"
#import "KTVDownloadSongComponent.h"
#import "KTVRTSManager.h"
#import "KTVHiFiveManager.h"


@interface KTVPickSongManager ()

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *roomID;
@property (nonatomic, assign) BOOL isRequesting;
@property (nonatomic, strong) NSMutableArray<KTVSongModel*> *waitingDownloadArray;
@property (nonatomic, strong) KTVSongModel *downloadingModel;

@end

@implementation KTVPickSongManager

- (instancetype)initWithRoomID:(NSString *)roomID {
    if (self = [super init]) {
        self.roomID = roomID;
    }
    return self;
}

#pragma mark - queue download
- (void)pickSong:(KTVSongModel *)model {
    if (self.isRequesting) {
        model.status = KTVSongModelStatusWaitingDownload;
        [self.waitingDownloadArray addObject:model];
        if (self.refreshModelBlock) {
            self.refreshModelBlock(model);
        }
    }
    else {
        [self getMusicDownloadModel:model];
    }
}

- (void)getMusicDownloadModel:(KTVSongModel *)model {
    self.isRequesting = YES;
    model.status = KTVSongModelStatusDownloading;
    self.downloadingModel = model;
    
    if (self.refreshModelBlock) {
        self.refreshModelBlock(self.downloadingModel);
    }
    
    [KTVHiFiveManager requestDownloadSongModel:model complete:^(KTVDownloadSongModel * _Nonnull downloadSongModel) {
        if (downloadSongModel) {
            [self downloadLRC:downloadSongModel];
        }
        else {
            model.status = KTVSongModelStatusNormal;
            
            if (self.refreshModelBlock) {
                self.refreshModelBlock(self.downloadingModel);
            }
            [self executeQueue];
        }
    }];
}

- (void)downloadLRC:(KTVDownloadSongModel *)downloadModel {
    NSString *filePath = [KTVPickSongManager getLRCFilePath:downloadModel.musicId];
    
    [KTVDownloadSongComponent downloadWithURL:downloadModel.dynamicLyricUrl filePath:filePath progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } complete:^(NSError * _Nonnull error) {
        if (!error) {
            [self downloadMP3:downloadModel];
        }
        else {
            [[ToastComponent shareToastComponent] showWithMessage:error.localizedDescription];
            self.downloadingModel.status = KTVSongModelStatusNormal;
            
            if (self.refreshModelBlock) {
                self.refreshModelBlock(self.downloadingModel);
            }
            [self executeQueue];
        }
    }];
}

- (void)downloadMP3:(KTVDownloadSongModel *)downloadModel {
    
    NSString *filePath = [KTVPickSongManager getMP3FilePath:downloadModel.musicId];
    
    [KTVDownloadSongComponent downloadWithURL:downloadModel.mp3URLString filePath:filePath progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } complete:^(NSError * _Nonnull error) {
        if (!error) {
            self.downloadingModel.status = KTVSongModelStatusDownloaded;
            self.downloadingModel.isPicked = YES;
            [KTVRTSManager pickSong:self.downloadingModel
                                    roomID:self.roomID
                                     block:^(RTSACKModel * _Nonnull model) {
                if (!model.result) {
                    if (model.code == 540) {
                        [[ToastComponent shareToastComponent] showWithMessage:@"重复点歌"];
                    }
                    else {
                        [[ToastComponent shareToastComponent] showWithMessage:model.message];
                    }
                }
            }];
        }
        else {
            [[ToastComponent shareToastComponent] showWithMessage:error.localizedDescription];
            self.downloadingModel.status = KTVSongModelStatusNormal;
        }
        
        if (self.refreshModelBlock) {
            self.refreshModelBlock(self.downloadingModel);
        }
        [self executeQueue];
    }];
}

- (void)executeQueue {
    if (self.waitingDownloadArray.count > 0) {
        KTVSongModel *songModel = [self.waitingDownloadArray firstObject];
        [self.waitingDownloadArray removeObjectAtIndex:0];
        [self getMusicDownloadModel:songModel];
    }
    else {
        self.isRequesting = NO;
    }
}

#pragma mark - download

+ (void)requestDownSongModel:(KTVSongModel *)songModel complete:(void(^)(KTVDownloadSongModel *downloadSongModel))complete {
    [KTVHiFiveManager requestDownloadSongModel:songModel complete:^(KTVDownloadSongModel * _Nonnull downloadSongModel) {
        if (complete) {
            complete(downloadSongModel);
        }
    }];
}

+ (void)getMP3FilePath:(KTVDownloadSongModel *)downloadSongModel complete:(void(^)(NSString * _Nullable filePath))complete {
    NSString *filePath = [KTVPickSongManager getMP3FilePath:downloadSongModel.musicId];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        !complete? :complete(filePath);
        return;
    }
    [KTVDownloadSongComponent downloadWithURL:downloadSongModel.mp3URLString filePath:filePath progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } complete:^(NSError * _Nonnull error) {
        if (error) {
            !complete? :complete(nil);
        }
        else {
            !complete? :complete(filePath);
        }
    }];
    
}

+ (void)getLRCFilePath:(KTVDownloadSongModel *)downloadSongModel complete:(void(^)(NSString * _Nullable filePath))complete; {
    NSString *filePath = [KTVPickSongManager getLRCFilePath:downloadSongModel.musicId];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        !complete? :complete(filePath);
        return;
    }
    [KTVDownloadSongComponent downloadWithURL:downloadSongModel.dynamicLyricUrl filePath:filePath progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } complete:^(NSError * _Nonnull error) {
        if (error) {
            !complete? :complete(nil);
        }
        else {
            !complete? :complete(filePath);
        }
    }];
}

+ (void)removeLocalMusicFile {
    NSString *baseFilePath = [self basePathString];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSDirectoryEnumerator * enumerator = [fileManager enumeratorAtPath:baseFilePath];
    for (NSString *fileName in enumerator) {
        [fileManager removeItemAtPath:[baseFilePath stringByAppendingPathComponent:fileName] error:nil];
    }
}

#pragma mark - methods
+ (NSString *)getMP3FilePath:(NSString *)musicID {
    NSString *filePath = [[self basePathString] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", musicID, @"mp3"]];
    return filePath;
}

+ (NSString *)getLRCFilePath:(NSString *)musicID {
    NSString *filePath = [[self basePathString] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", musicID, @"lrc"]];
    return filePath;
}

+ (NSString *)basePathString {
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *basePath = [cachePath stringByAppendingPathComponent:@"music"];
    
    BOOL isDir = NO;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:basePath isDirectory:&isDir];
    if (!(isDir && exists)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return basePath;
}

- (NSMutableArray<KTVSongModel *> *)waitingDownloadArray {
    if (!_waitingDownloadArray) {
        _waitingDownloadArray = [NSMutableArray array];
    }
    return _waitingDownloadArray;
}

@end
