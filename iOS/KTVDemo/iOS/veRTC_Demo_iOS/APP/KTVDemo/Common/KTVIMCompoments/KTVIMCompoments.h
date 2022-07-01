//
//  KTVIMCompoments.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/23.
//  Copyright © 2021 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTVIMModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KTVIMCompoments : NSObject

- (instancetype)initWithSuperView:(UIView *)superView;

- (void)addIM:(KTVIMModel *)model;

@end

NS_ASSUME_NONNULL_END
