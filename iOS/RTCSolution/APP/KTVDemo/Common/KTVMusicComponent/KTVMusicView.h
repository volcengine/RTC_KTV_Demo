// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import <UIKit/UIKit.h>
#import "KTVUserModel.h"
#import "KTVSongModel.h"
@class KTVMusicView;

NS_ASSUME_NONNULL_BEGIN

@protocol KTVMusicViewdelegate <NSObject>

- (void)musicViewdelegate:(KTVMusicView *)musicViewdelegate topViewClickCut:(BOOL)isResult;

@end

@interface KTVMusicView : UIView

@property (nonatomic, assign) NSTimeInterval time;

@property (nonatomic, weak) id<KTVMusicViewdelegate> musicDelegate;

- (void)updateTopWithSongModel:(KTVSongModel *)songModel
                loginUserModel:(KTVUserModel *)loginUserModel;

- (void)dismissTuningPanel;

- (void)resetTuningView;

- (void)loadLrcByPath:(NSString *)filePath;

- (void)updateLrcHidden:(BOOL)isHidden;

/// 音频播放路由改变
- (void)updateAudioRouteChanged;

@end

NS_ASSUME_NONNULL_END
