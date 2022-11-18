//
//  KTVMusicLyricsView.h
//  veRTC_Demo
//
//  Created by on 2022/1/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KTVMusicLyricsView : UIView

/// 加载歌词
/// @param path 歌词文件路径
/// @param error 歌词文件读取的错误
- (void)loadLrcByPath:(NSString *)path error:(NSError * _Nullable *)error;

/// 加载歌词
/// @param string 歌词
- (void)loadLrcBylrcString:(NSString *)string;

/// 播放歌词
/// @param time 当前音乐播放时间，时间：秒
- (void)playAtTime:(NSTimeInterval)time;

/// 重置状态
- (void)resetStatus;

@end

NS_ASSUME_NONNULL_END
