//
//  KTVRoomParamInfoModel.m
//  veRTC_Demo
//
//  Created by bytedance on 2021/6/2.
//  Copyright © 2021 . All rights reserved.
//

#import "KTVRoomParamInfoModel.h"

@implementation KTVRoomParamInfoModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _rtt = @"0";
        _sendLossRate = @"0";
        _receivedLossRate = @"0";
    }
    return self;
}

@end
