//
//  KTVHostAvatarView.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/11/29.
//  Copyright © 2021 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTVUserModel.h"
@class KTVSongModel;

NS_ASSUME_NONNULL_BEGIN

@interface KTVHostAvatarView : UIView

@property (nonatomic, strong) KTVUserModel *userModel;

- (void)updateHostVolume:(NSNumber *)volume;

- (void)updateHostMic:(KTVUserMic)userMic;

- (void)updateCurrentSongModel:(KTVSongModel *)songModel;

@end

NS_ASSUME_NONNULL_END
