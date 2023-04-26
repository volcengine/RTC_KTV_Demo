// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import <UIKit/UIKit.h>
#import "KTVUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KTVMusicNullView : UIView

@property (nonatomic, strong) KTVUserModel *loginUserModel;

@property (nonatomic, copy) void (^clickPlayMusicBlock)(void);

@end

NS_ASSUME_NONNULL_END
