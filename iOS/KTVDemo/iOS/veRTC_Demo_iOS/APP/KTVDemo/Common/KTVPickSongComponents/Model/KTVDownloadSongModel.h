//
//  KTVDownloadSongModel.h
//  veRTC_Demo
//
//  Created by bytedance on 2022/1/20.
//  Copyright © 2022 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 获取歌曲歌词下载地址模型
/// Get song lyrics download address model
@interface KTVDownloadSongModel : NSObject

@property (nonatomic, copy) NSString *musicId;
@property (nonatomic, copy) NSString *mp3URLString;
@property (nonatomic, copy) NSString *dynamicLyricUrl;
@property (nonatomic, strong) NSArray *subVersions;



@end

NS_ASSUME_NONNULL_END
