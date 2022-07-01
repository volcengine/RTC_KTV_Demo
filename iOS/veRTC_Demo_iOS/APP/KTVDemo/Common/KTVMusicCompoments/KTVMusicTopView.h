//
//  KTVMusicTopView.h
//  veRTC_Demo
//
//  Created by bytedance on 2022/1/19.
//  Copyright © 2022 bytedance. All rights reserved.
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
