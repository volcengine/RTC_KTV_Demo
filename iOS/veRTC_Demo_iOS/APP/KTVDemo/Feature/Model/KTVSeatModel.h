//
//  KTVSeatModel.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/11/23.
//  Copyright © 2021 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTVUserModel.h"

@interface KTVSeatModel : NSObject

/// status: 0 close, 1 open
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) KTVUserModel *userModel;

@end
