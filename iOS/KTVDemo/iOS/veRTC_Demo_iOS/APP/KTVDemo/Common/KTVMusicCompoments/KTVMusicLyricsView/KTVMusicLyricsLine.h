//
//  KTVMusicLyricsLine.h
//  veRTC_Demo
//
//  Created by bytedance on 2022/1/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KTVMusicLyricsLine : NSObject

@property (nonatomic, assign) NSTimeInterval startTime; // 毫秒

@property (nonatomic, copy) NSString * lrc;

@end

NS_ASSUME_NONNULL_END
