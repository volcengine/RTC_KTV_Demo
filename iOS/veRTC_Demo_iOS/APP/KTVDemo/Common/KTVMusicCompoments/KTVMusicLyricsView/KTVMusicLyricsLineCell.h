//
//  KTVMusicLyricsLineCell.h
//  veRTC_Demo
//
//  Created by bytedance on 2022/1/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class KTVMusicLyricsLine;
@interface KTVMusicLyricsLineCell : UITableViewCell

+ (NSString *)reuseIdentifier;

- (void)fillLyricsLine:(KTVMusicLyricsLine *)lyricsLine;
- (void)showHighlighted:(BOOL)highlighted;

@end

NS_ASSUME_NONNULL_END
