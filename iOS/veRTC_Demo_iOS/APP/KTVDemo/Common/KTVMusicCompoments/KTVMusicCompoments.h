//
//  KTVMusicCompoments.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/11/30.
//  Copyright © 2021 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTVUserModel.h"
#import "KTVSongModel.h"
@class KTVMusicCompoments;

NS_ASSUME_NONNULL_BEGIN

@protocol MusicCompomentsDelegate <NSObject>

- (void)musicCompoments:(KTVMusicCompoments *)musicCompoments clickPlayMusic:(BOOL)isClick;

@end

@interface KTVMusicCompoments : NSObject

- (instancetype)initWithSuperView:(UIView *)view
                           roomID:(NSString *)roomID;

/// Update the currently playing song
/// @param songModel songModel
- (void)startSingWithSongModel:(KTVSongModel * _Nullable)songModel;

- (void)stopSong;

/// Show song ending UI
/// @param nextSongModel next song
/// @param score Music score
- (void)showSongEndSongModel:(KTVSongModel * _Nullable)nextSongModel
                       score:(NSInteger)score;

/// Update current user role
/// @param loginUserModel User Info
- (void)updateUserModel:(KTVUserModel *)loginUserModel;

/// Update current song progress
/// @param songTime song progress
- (void)updateCurrentSongTime:(NSInteger)songTime;

- (void)sendSongTime:(NSInteger)songTime;

- (void)dismissTuningPanel;

@property (nonatomic, weak) id<MusicCompomentsDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
