//
//  KTVPickSongListView.h
//  veRTC_Demo
//
//  Created by bytedance on 2022/1/19.
//  Copyright © 2022 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTVPickSongTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface KTVPickSongListView : UIView

@property (nonatomic, copy) NSArray<KTVSongModel*> *dataArray;
@property (nonatomic, copy) void(^pickSongBlock)(KTVSongModel *songModel);

- (instancetype)initWithType:(KTVSongListViewType)type;

- (void)refreshView;

@end

NS_ASSUME_NONNULL_END
