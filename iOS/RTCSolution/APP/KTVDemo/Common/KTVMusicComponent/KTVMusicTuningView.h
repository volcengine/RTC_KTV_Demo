// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KTVMusicTuningView : UIView

- (void)resetUI;

/// 音频播放路由改变
- (void)updateAudioRouteChanged;

@end

NS_ASSUME_NONNULL_END
