//
//  KTVIMComponent.h
//  veRTC_Demo
//
//  Created by on 2021/5/23.
//  
//

#import <Foundation/Foundation.h>
#import "KTVIMModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KTVIMComponent : NSObject

- (instancetype)initWithSuperView:(UIView *)superView;

- (void)addIM:(KTVIMModel *)model;

@end

NS_ASSUME_NONNULL_END
