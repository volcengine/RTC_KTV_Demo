//
//  KTVMusicLyricsInfo.h
//  veRTC_Demo
//
//  Created by bytedance on 2022/1/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class KTVMusicLyricsLine;
@interface KTVMusicLyricsInfo : NSObject

@property (nonatomic, strong) NSArray<KTVMusicLyricsLine *> * lrcArray;

@property (nonatomic, assign, readonly) NSUInteger numberOfLines;

@end

NS_ASSUME_NONNULL_END
