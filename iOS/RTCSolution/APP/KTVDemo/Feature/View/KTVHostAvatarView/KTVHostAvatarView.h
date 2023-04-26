// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
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
