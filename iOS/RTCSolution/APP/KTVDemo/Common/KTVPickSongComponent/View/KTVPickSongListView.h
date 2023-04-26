// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
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
