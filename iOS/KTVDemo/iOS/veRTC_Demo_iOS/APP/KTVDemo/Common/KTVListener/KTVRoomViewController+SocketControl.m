//
//  KTVRoomViewController+SocketControl.m
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/28.
//  Copyright © 2021 . All rights reserved.
//

#import "KTVRoomViewController+SocketControl.h"
#import "KTVPickSongManager.h"

@implementation KTVRoomViewController (SocketControl)

- (void)addSocketListener {
    __weak __typeof(self) wself = self;
    [KTVRTMManager onAudienceJoinRoomWithBlock:^(KTVUserModel * _Nonnull userModel, NSInteger count) {
        if (wself) {
            [wself receivedJoinUser:userModel count:count];
        }
    }];
    
    
    [KTVRTMManager onAudienceLeaveRoomWithBlock:^(KTVUserModel * _Nonnull userModel, NSInteger count) {
        if (wself) {
            [wself receivedLeaveUser:userModel count:count];
        }
    }];

    
    [KTVRTMManager onFinishLiveWithBlock:^(NSString * _Nonnull rommID, NSInteger type) {
        if (wself) {
            [wself receivedFinishLive:type roomID:rommID];
        }
    }];

    
    [KTVRTMManager onJoinInteractWithBlock:^(KTVUserModel * _Nonnull userModel, NSString * _Nonnull seatID) {
        if (wself) {
            [wself receivedJoinInteractWithUser:userModel seatID:seatID];
        }
    }];

    
    [KTVRTMManager onFinishInteractWithBlock:^(KTVUserModel * _Nonnull userModel, NSString * _Nonnull seatID, NSInteger type) {
        if (wself) {
            [wself receivedLeaveInteractWithUser:userModel seatID:seatID type:type];
        }
    }];

    
    [KTVRTMManager onSeatStatusChangeWithBlock:^(NSString * _Nonnull seatID, NSInteger type) {
        if (wself) {
            [wself receivedSeatStatusChange:seatID type:type];
        }
    }];

    
    [KTVRTMManager onMediaStatusChangeWithBlock:^(KTVUserModel * _Nonnull userModel, NSString * _Nonnull seatID, NSInteger mic) {
        if (wself) {
            [wself receivedMediaStatusChangeWithUser:userModel seatID:seatID mic:mic];
        }
    }];

    
    [KTVRTMManager onMessageWithBlock:^(KTVUserModel * _Nonnull userModel, NSString * _Nonnull message) {
        if (wself) {
            message = [message stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [wself receivedMessageWithUser:userModel message:message];
        }
    }];

    //Single Notification Message
    
    [KTVRTMManager onInviteInteractWithBlock:^(KTVUserModel * _Nonnull hostUserModel, NSString * _Nonnull seatID) {
        if (wself) {
            [wself receivedInviteInteractWithUser:hostUserModel seatID:seatID];
        }
    }];
    
    [KTVRTMManager onApplyInteractWithBlock:^(KTVUserModel * _Nonnull userModel, NSString * _Nonnull seatID) {
        if (wself) {
            [wself receivedApplyInteractWithUser:userModel seatID:seatID];
        }
    }];

    [KTVRTMManager onInviteResultWithBlock:^(KTVUserModel * _Nonnull userModel, NSInteger reply) {
        if (wself) {
            [wself receivedInviteResultWithUser:userModel reply:reply];
        }
    }];
    
    [KTVRTMManager onMediaOperateWithBlock:^(NSInteger mic) {
        if (wself) {
            [wself receivedMediaOperatWithUid:mic];
        }
    }];
    
    [KTVRTMManager onClearUserWithBlock:^(NSString * _Nonnull uid) {
        if (wself) {
            [wself receivedClearUserWithUid:uid];
        }
    }];
    
    [KTVRTMManager onPickSongBlock:^(KTVSongModel * _Nonnull songModel) {
        [wself receivedPickedSong:songModel];
    }];
    
    [KTVRTMManager onStartSingSongBlock:^(KTVSongModel * _Nonnull songModel) {
        [wself receivedStartSingSong:songModel];
    }];
    
    [KTVRTMManager onFinishSingSongBlock:^(KTVSongModel * _Nonnull nextSongModel, NSInteger score) {
        [wself receivedFinishSingSong:score nextSongModel:nextSongModel];
    }];
}
@end
