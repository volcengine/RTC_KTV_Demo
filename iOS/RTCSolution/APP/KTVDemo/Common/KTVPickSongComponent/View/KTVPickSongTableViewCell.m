// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import "KTVPickSongTableViewCell.h"
#import "KTVSongModel.h"
#import "UIImageView+WebCache.h"

@interface KTVPickSongTableViewCell ()

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *songLabel;
@property (nonatomic, strong) UILabel *singerLabel;
@property (nonatomic, strong) UIButton *pickButton;
@property (nonatomic, strong) UIImageView *singingView;

@end

@implementation KTVPickSongTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.coverImageView];
    [self.contentView addSubview:self.songLabel];
    [self.contentView addSubview:self.singerLabel];
    [self.contentView addSubview:self.pickButton];
    [self.contentView addSubview:self.singingView];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(40);
    }];
    [self.songLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImageView.mas_right).offset(12);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-1.5);
    }];
    [self.singerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImageView.mas_right).offset(12);
        make.top.equalTo(self.contentView.mas_centerY).offset(1.5);
    }];
    [self.pickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-16);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(54, 28));
    }];
    [self.singingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-16);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.singingView.hidden = YES;
}

#pragma mark - methods

- (void)setType:(KTVSongListViewType)type {
    _type = type;
    
    self.pickButton.hidden = (type == KTVSongListViewTypePicked);
}

- (void)setSongModel:(KTVSongModel *)songModel {
    _songModel = songModel;
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:songModel.coverURLString] placeholderImage:nil];

    self.songLabel.text = songModel.musicName;
    if (self.type == KTVSongListViewTypeOnline) {
        self.singerLabel.text = [NSString stringWithFormat:@"原唱：%@", songModel.singerUserName];
    }
    else {
        self.singerLabel.text = [NSString stringWithFormat:@"点唱者：%@", songModel.pickedUserName];
        self.singingView.hidden = (songModel.singStatus != KTVSongModelSingStatusSinging);
    }
    
    if (songModel.isPicked) {
        [_pickButton setTitle:@"已点" forState:UIControlStateNormal];
        
        [_pickButton setBackgroundImage:nil forState:UIControlStateNormal];
        [_pickButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _pickButton.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.2];
    }
    else {
        [_pickButton setBackgroundImage:[UIImage imageNamed:@"KTV_pick_song_button" bundleName:HomeBundleName] forState:UIControlStateNormal];
        [_pickButton setTitleColor:[UIColor colorFromHexString:@"#E275D2"] forState:UIControlStateNormal];
        _pickButton.backgroundColor = UIColor.clearColor;

        switch (songModel.status) {
            case KTVSongModelStatusDownloaded:
            case KTVSongModelStatusNormal: {
                [_pickButton setTitle:@"点歌" forState:UIControlStateNormal];
            }
                break;
            case KTVSongModelStatusWaitingDownload: {
                [_pickButton setTitle:@"等待中" forState:UIControlStateNormal];
            }
                break;
            case KTVSongModelStatusDownloading: {
                [_pickButton setTitle:@"下载中" forState:UIControlStateNormal];
            }
                break;            
            default:
                break;
        }
    }
}

- (void)pickButtonClick {
    
    if ((self.songModel.status == KTVSongModelStatusNormal || self.songModel.status == KTVSongModelStatusDownloaded) && !self.songModel.isPicked) {
        if (self.pickSongBlock) {
            self.pickSongBlock(self.songModel);
        }
    }
}

#pragma mark - getter
- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.layer.cornerRadius = 2;
        _coverImageView.layer.masksToBounds = YES;
    }
    return _coverImageView;
}

- (UILabel *)songLabel {
    if (!_songLabel) {
        _songLabel = [[UILabel alloc] init];
        _songLabel.font = [UIFont systemFontOfSize:14];
        _songLabel.textColor = UIColor.whiteColor;
    }
    return _songLabel;
}

- (UILabel *)singerLabel {
    if (!_singerLabel) {
        _singerLabel = [[UILabel alloc] init];
        _singerLabel.font = [UIFont systemFontOfSize:10];
        _singerLabel.textColor = [UIColor.whiteColor colorWithAlphaComponent:0.7];
    }
    return _singerLabel;
}

- (UIButton *)pickButton {
    if (!_pickButton) {
        _pickButton = [[UIButton alloc] init];
        _pickButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_pickButton setBackgroundImage:[UIImage imageNamed:@"KTV_pick_song_button" bundleName:HomeBundleName] forState:UIControlStateNormal];
        [_pickButton setTitle:@"点歌" forState:UIControlStateNormal];
        [_pickButton setTitleColor:[UIColor colorFromHexString:@"#E275D2"] forState:UIControlStateNormal];
        [_pickButton addTarget:self action:@selector(pickButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        _pickButton.layer.cornerRadius = 14;
    }
    return _pickButton;
}

- (UIImageView *)singingView {
    if (!_singingView) {
        _singingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"KTV_singing_icon" bundleName:HomeBundleName]];
        _singingView.hidden = YES;
    }
    return _singingView;
}

@end
