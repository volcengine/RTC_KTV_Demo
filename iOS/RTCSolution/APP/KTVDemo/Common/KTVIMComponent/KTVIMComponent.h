// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import <Foundation/Foundation.h>
#import "KTVIMModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KTVIMComponent : NSObject

- (instancetype)initWithSuperView:(UIView *)superView;

- (void)addIM:(KTVIMModel *)model;

@end

NS_ASSUME_NONNULL_END
