//
//  KTVMusicLyricsLineCell.m
//  veRTC_Demo
//
//  Created by on 2022/1/18.
//

#import "KTVMusicLyricsLineCell.h"
#import "KTVMusicLyricsLine.h"

@interface KTVMusicLyricsLineCell ()

@property (nonatomic, strong) UILabel *lyricsLable;

@property (nonatomic, strong) KTVMusicLyricsLine *lyricsLine;

@end

@implementation KTVMusicLyricsLineCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _lyricsLable = [[UILabel alloc] initWithFrame:self.bounds];
        _lyricsLable.textAlignment = NSTextAlignmentCenter;
        _lyricsLable.textColor = [UIColor whiteColor];
        _lyricsLable.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        [self.contentView addSubview:_lyricsLable];
        [_lyricsLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)fillLyricsLine:(KTVMusicLyricsLine *)lyricsLine {
    self.lyricsLine = lyricsLine;
    self.lyricsLable.text = lyricsLine.lrc;
}

- (void)showHighlighted:(BOOL)highlighted {
    if (highlighted) {
        self.lyricsLable.textColor = [UIColor colorFromHexString:@"#EE77C6"];
        self.lyricsLable.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    } else {
        self.lyricsLable.textColor = [UIColor whiteColor];
        self.lyricsLable.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    }
}

@end
