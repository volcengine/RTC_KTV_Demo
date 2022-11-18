//
//  KTVMusicLyricsAnalyzer.h
//  veRTC_Demo
//
//  Created by on 2022/1/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class KTVMusicLyricsInfo;
@interface KTVMusicLyricsAnalyzer : NSObject

+ (nullable KTVMusicLyricsInfo *)analyzeLrcByPath:(NSString *)path error:(NSError * _Nullable *)error;

+ (KTVMusicLyricsInfo *)analyzeLrcBylrcString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
