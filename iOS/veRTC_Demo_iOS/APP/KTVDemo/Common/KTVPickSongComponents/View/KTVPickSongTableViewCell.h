//
//  KTVPickSongTableViewCell.h
//  veRTC_Demo
//
//  Created by bytedance on 2022/1/19.
//  Copyright © 2022 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KTVSongModel;
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KTVSongListViewType) {
    KTVSongListViewTypeOnline,
    KTVSongListViewTypePicked,
};

@interface KTVPickSongTableViewCell : UITableViewCell

@property (nonatomic, assign) KTVSongListViewType type;

@property (nonatomic, strong) KTVSongModel *songModel;
@property (nonatomic, copy) void(^pickSongBlock)(KTVSongModel *model);

@end

NS_ASSUME_NONNULL_END
