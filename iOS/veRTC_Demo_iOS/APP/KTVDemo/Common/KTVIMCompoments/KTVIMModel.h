//
//  KTVIMModel.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/28.
//  Copyright © 2021 . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KTVIMModel : NSObject

@property (nonatomic, assign) BOOL isJoin;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) KTVUserModel *userModel;

@end

NS_ASSUME_NONNULL_END
