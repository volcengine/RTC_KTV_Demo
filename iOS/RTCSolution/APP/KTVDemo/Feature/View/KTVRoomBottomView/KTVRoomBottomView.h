// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import <UIKit/UIKit.h>
#import "KTVRoomItemButton.h"
@class KTVRoomBottomView;

typedef NS_ENUM(NSInteger, KTVRoomBottomStatus) {
    KTVRoomBottomStatusPhone = 0,
    KTVRoomBottomStatusMusic,
    KTVRoomBottomStatusLocalMic,
    KTVRoomBottomStatusEnd,
    KTVRoomBottomStatusInput,
    KTVRoomBottomStatusPickSong,
};

@protocol KTVRoomBottomViewDelegate <NSObject>

- (void)KTVRoomBottomView:(KTVRoomBottomView *_Nonnull)KTVRoomBottomView
                     itemButton:(KTVRoomItemButton *_Nullable)itemButton
                didSelectStatus:(KTVRoomBottomStatus)status;

@end

NS_ASSUME_NONNULL_BEGIN

@interface KTVRoomBottomView : UIView

@property (nonatomic, weak) id<KTVRoomBottomViewDelegate> delegate;

- (void)updateBottomLists:(KTVUserModel *)userModel;

- (void)updateButtonStatus:(KTVRoomBottomStatus)status isSelect:(BOOL)isSelect;

- (void)updateButtonStatus:(KTVRoomBottomStatus)status isRed:(BOOL)isRed;

- (void)updatePickedSongCount:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
