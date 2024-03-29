// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KTVSongModelStatus) {
    KTVSongModelStatusNormal = 0,
    KTVSongModelStatusWaitingDownload = 1,
    KTVSongModelStatusDownloading = 2,
    KTVSongModelStatusDownloaded = 3,
};

typedef NS_ENUM(NSInteger, KTVSongModelSingStatus) {
    KTVSongModelSingStatusWaiting = 1,
    KTVSongModelSingStatusSinging = 2,
    KTVSongModelSingStatusFinish = 3,
};

@interface KTVSongModel : NSObject

@property (nonatomic, copy) NSString *musicName;
@property (nonatomic, copy) NSString *musicId;
@property (nonatomic, copy) NSString *singerUserName;

@property (nonatomic, assign) NSInteger musicAllTime;
@property (nonatomic, copy) NSString *coverURLString;

@property (nonatomic, copy) NSString *pickedUserID;
@property (nonatomic, copy) NSString *pickedUserName;

@property (nonatomic, copy) NSArray *singerList;
@property (nonatomic, copy) NSArray *coverList;
@property (nonatomic, copy) NSString *coverURL;

@property (nonatomic, assign) KTVSongModelStatus status;
@property (nonatomic, assign) BOOL isPicked;
@property (nonatomic, assign) KTVSongModelSingStatus singStatus;


@end

NS_ASSUME_NONNULL_END
