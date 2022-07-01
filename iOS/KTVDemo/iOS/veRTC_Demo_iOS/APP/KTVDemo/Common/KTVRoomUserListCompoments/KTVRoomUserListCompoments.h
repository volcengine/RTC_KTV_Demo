//
//  KTVRoomUserListCompoments.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/19.
//  Copyright © 2021 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTVRoomAudienceListsView.h"
#import "KTVRoomRaiseHandListsView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KTVRoomUserListCompoments : NSObject

- (void)showRoomModel:(KTVRoomModel *)roomModel
               seatID:(NSString *)seatID
         dismissBlock:(void (^)(void))dismissBlock;

- (void)update;

- (void)updateWithRed:(BOOL)isRed;

@end

NS_ASSUME_NONNULL_END
