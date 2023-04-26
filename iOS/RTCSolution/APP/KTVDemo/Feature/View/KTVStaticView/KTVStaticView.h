// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import <UIKit/UIKit.h>
@class KTVRoomModel;
@class KTVRoomParamInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface KTVStaticView : UIView

@property (nonatomic, strong) KTVRoomModel *roomModel;

- (void)updatePeopleNum:(NSInteger)count;

- (void)updateParamInfoModel:(KTVRoomParamInfoModel *)paramInfoModel;

@end

NS_ASSUME_NONNULL_END
