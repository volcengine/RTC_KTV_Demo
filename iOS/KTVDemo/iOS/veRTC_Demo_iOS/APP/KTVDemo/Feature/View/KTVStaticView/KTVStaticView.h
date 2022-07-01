//
//  KTVStaticView.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/11/29.
//  Copyright © 2021 . All rights reserved.
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
