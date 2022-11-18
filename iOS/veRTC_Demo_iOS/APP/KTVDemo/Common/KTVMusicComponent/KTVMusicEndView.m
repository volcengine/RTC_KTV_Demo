//
//  KTVMusicEndView.m
//  veRTC_Demo
//
//  Created by on 2022/1/20.
//  
//

#import "KTVMusicEndView.h"

@interface KTVMusicEndView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nextMusicLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *scoreImageView;

@end

@implementation KTVMusicEndView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.nextMusicLabel];
        [self.nextMusicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.mas_equalTo(-15);
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.mas_equalTo(40);
        }];
        
        [self addSubview:self.scoreImageView];
        [self.scoreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 80));
            make.centerX.equalTo(self);
            make.top.mas_equalTo(76);
        }];
    }
    return self;
}

#pragma mark - Publish Action

- (void)showWithModel:(KTVSongModel *)songModel
                score:(NSInteger)score
                block:(void (^)(BOOL result))block {
    if (NOEmptyStr(songModel.musicName)) {
        self.nextMusicLabel.text = [NSString stringWithFormat:@"即将播放《%@》", songModel.musicName];
    } else {
        self.nextMusicLabel.text = @"";
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (block) {
            block(YES);
        }
    });
}

#pragma mark - Getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
        _titleLabel.textColor = [UIColor colorFromHexString:@"#EE77C6"];
        _titleLabel.text = @"本次演唱得分";
    }
    return _titleLabel;
}

- (UILabel *)nextMusicLabel {
    if (!_nextMusicLabel) {
        _nextMusicLabel = [[UILabel alloc] init];
        _nextMusicLabel.font = [UIFont systemFontOfSize:12];
        _nextMusicLabel.textColor = [UIColor colorFromHexString:@"#FFFFFF"];
    }
    return _nextMusicLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"ktv_null_bg" bundleName:HomeBundleName];
    }
    return _imageView;
}

- (UIImageView *)scoreImageView {
    if (!_scoreImageView) {
        _scoreImageView = [[UIImageView alloc] init];
        _scoreImageView.image = [UIImage imageNamed:@"ktv_end_score" bundleName:HomeBundleName];
        UILabel *scoreLabel = [[UILabel alloc] init];
        scoreLabel.font = [UIFont systemFontOfSize:18];
        scoreLabel.textColor = UIColor.whiteColor;
        scoreLabel.text = @"S";
        [_scoreImageView addSubview:scoreLabel];
        [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_scoreImageView);
        }];
    }
    return _scoreImageView;
}

@end
