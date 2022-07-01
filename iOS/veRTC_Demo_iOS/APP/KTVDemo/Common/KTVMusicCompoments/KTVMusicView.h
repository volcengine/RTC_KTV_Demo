//
//  KTVMusicView.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/11/30.
//  Copyright © 2021 . All rights reserved.
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

@end

NS_ASSUME_NONNULL_END
