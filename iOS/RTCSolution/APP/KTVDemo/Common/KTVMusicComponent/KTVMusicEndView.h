// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import <UIKit/UIKit.h>
#import "KTVSongModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KTVMusicEndView : UIView

- (void)showWithModel:(KTVSongModel *)songModel
                score:(NSInteger)score
                block:(void (^)(BOOL result))block;

@end

NS_ASSUME_NONNULL_END
