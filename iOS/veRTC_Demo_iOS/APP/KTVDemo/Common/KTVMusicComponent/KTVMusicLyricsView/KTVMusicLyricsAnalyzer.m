//
//  KTVMusicLyricsAnalyzer.m
//  veRTC_Demo
//
//  Created by on 2022/1/18.
//

#import "KTVMusicLyricsAnalyzer.h"
#import "KTVMusicLyricsInfo.h"
#import "KTVMusicLyricsLine.h"

@implementation KTVMusicLyricsAnalyzer

+ (KTVMusicLyricsInfo *)analyzeLrcByPath:(NSString *)path error:(NSError * _Nullable __autoreleasing *)error {
    NSError *aerror = nil;
    NSString *string = [NSString stringWithContentsOfFile:path
                                                 encoding:NSUTF8StringEncoding
                                                    error:&aerror];
    if (aerror.code == 261) {
        string = [NSString stringWithContentsOfFile:path
                                           encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
                                              error:&aerror];
    }
    if (error) {
        *error = aerror;
    }
    if (!string) {
        return nil;
    }
    return [self analyzeLrc:string];
}

+ (KTVMusicLyricsInfo *)analyzeLrcBylrcString:(NSString *)string {
    return [self analyzeLrc:string];
}

+ (KTVMusicLyricsInfo *)analyzeLrc:(NSString *)lrcConnect {
    KTVMusicLyricsInfo *info = [KTVMusicLyricsInfo new];
    NSMutableArray<KTVMusicLyricsLine *> *lrcLines = [NSMutableArray array];
    NSArray<NSString *> *lrcConnectArray = [lrcConnect componentsSeparatedByString:@"\n"];
    [lrcConnectArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (IsEmptyStr(obj)) {
            return;
        }
        KTVMusicLyricsLine *line = [self analyzeEachLrc:obj];
        if (line) {
            [lrcLines addObject:line];
        }
    }];
    info.lrcArray = lrcLines.copy;
    return info;
}

/*
 * 标准lrc格式解析
 * [ti:歌曲名]
 * [ar:歌手]
 * [by:歌词创建者]
 *
 * [分钟:秒.百分秒]歌词
 */
+ (nullable KTVMusicLyricsLine *)analyzeEachLrc:(NSString *)lrcLine {
    NSLog(@"%@", lrcLine);
    NSRange start = [lrcLine rangeOfString:@"["];
    NSRange end = [lrcLine rangeOfString:@"]"];
    if (start.location == NSNotFound || end.location == NSNotFound) {
        return nil;
    }
    
    NSString *lrcStr = [lrcLine substringFromIndex:end.location+1];
    if (IsEmptyStr(lrcStr)) { // 抠除ID标签及空行
        return nil;
    }
    KTVMusicLyricsLine *line = [KTVMusicLyricsLine new];
    line.lrc = [self htmlEntityDecode:lrcStr];
    
    NSString *startTime = [lrcLine substringWithRange:NSMakeRange(start.location+1,
                                                                  end.location-start.location-1)];
    NSInteger minute = [startTime substringWithRange:NSMakeRange(0, 2)].integerValue;
    NSTimeInterval second = [startTime substringFromIndex:3].doubleValue;
    line.startTime = (minute * 60 + second) * 1000;
 
    return  line;
}

+ (NSString *)htmlEntityDecode:(NSString *)string {
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    return string;
}

@end
