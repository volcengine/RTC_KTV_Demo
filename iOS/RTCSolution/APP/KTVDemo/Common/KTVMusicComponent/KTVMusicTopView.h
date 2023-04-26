// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import <UIKit/UIKit.h>
#import "KTVSongModel.h"

typedef NS_ENUM(NSInteger, MusicTopState) {
    MusicTopStateNone = 0,
    MusicTopStateOriginal,
    MusicTopStateTuning,
    MusicTopStatePause,
    MusicTopStateNext,
};

NS_ASSUME_NONNULL_BEGIN

@interface KTVMusicTopView : UIView

@property (nonatomic, copy) void (^clickButtonBlock) (MusicTopState state,
                                                      BOOL isSelect);

@property (nonatomic, assign) NSTimeInterval time;

- (void)updateWithSongModel:(KTVSongModel *)songModel
             loginUserModel:(KTVUserModel *)loginUserModel;

@end

NS_ASSUME_NONNULL_END
