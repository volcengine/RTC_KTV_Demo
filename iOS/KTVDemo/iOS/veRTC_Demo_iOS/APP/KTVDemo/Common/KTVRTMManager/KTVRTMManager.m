//
//  KTVControlCompoments.m
//  SceneRTCDemo
//
//  Created by bytedance on 2021/3/16.
//

#import "KTVRTMManager.h"
#import "KTVRTCManager.h"

@implementation KTVRTMManager

#pragma mark - Get Voice data

+ (void)startLive:(NSString *)roomName
         userName:(NSString *)userName
      bgImageName:(NSString *)bgImageName
            block:(void (^)(NSString *RTCToken,
                            KTVRoomModel *roomModel,
                            KTVUserModel *hostUserModel,
                            RTMACKModel *model))block {
    NSDictionary *dic = @{@"room_name" : roomName,
                          @"background_image_name" : bgImageName,
                          @"user_name" : userName};
    dic = [PublicParameterCompoments addTokenToParams:dic];
    
    [[KTVRTCManager shareRtc] emitWithAck:@"ktvStartLive" with:dic block:^(RTMACKModel * _Nonnull ackModel) {

        NSString *RTCToken = @"";
        KTVRoomModel *roomModel = nil;
        KTVUserModel *hostUserModel = nil;
        if ([KTVRTMManager ackModelResponseClass:ackModel]) {
            roomModel = [KTVRoomModel yy_modelWithJSON:ackModel.response[@"room_info"]];
            hostUserModel = [KTVUserModel yy_modelWithJSON:ackModel.response[@"user_info"]];
            RTCToken = [NSString stringWithFormat:@"%@", ackModel.response[@"rtc_token"]];
        }
        if (block) {
            block(RTCToken, roomModel, hostUserModel, ackModel);
        }
        NSLog(@"[%@]-ktvStartLive %@ \n %@", [self class], dic, ackModel.response);
    }];
}

+ (void)getAudienceList:(NSString *)roomID
                  block:(void (^)(NSArray<KTVUserModel *> *userLists,
                                  RTMACKModel *model))block {
    NSDictionary *dic = @{@"room_id" : roomID};
    dic = [PublicParameterCompoments addTokenToParams:dic];
    
    [[KTVRTCManager shareRtc] emitWithAck:@"ktvGetAudienceList" with:dic block:^(RTMACKModel * _Nonnull ackModel) {
        
        NSMutableArray<KTVUserModel *> *userLists = [[NSMutableArray alloc] init];
        if ([KTVRTMManager ackModelResponseClass:ackModel]) {
            NSArray *list = ackModel.response[@"audience_list"];
            for (int i = 0; i < list.count; i++) {
                KTVUserModel *userModel = [KTVUserModel yy_modelWithJSON:list[i]];
                [userLists addObject:userModel];
            }
        }
        if (block) {
            block([userLists copy], ackModel);
        }
        NSLog(@"[%@]-ktvGetAudienceList %@ | %@", [self class], dic, ackModel.response);
    }];
}

+ (void)getApplyAudienceList:(NSString *)roomID
                       block:(void (^)(NSArray<KTVUserModel *> *userLists,
                                       RTMACKModel *model))block {
    NSDictionary *dic = @{@"room_id" : roomID};
    dic = [PublicParameterCompoments addTokenToParams:dic];
    
    [[KTVRTCManager shareRtc] emitWithAck:@"ktvGetApplyAudienceList" with:dic block:^(RTMACKModel * _Nonnull ackModel) {
        
        NSMutableArray<KTVUserModel *> *userLists = [[NSMutableArray alloc] init];
        if ([KTVRTMManager ackModelResponseClass:ackModel]) {
            NSArray *list = ackModel.response[@"audience_list"];
            for (int i = 0; i < list.count; i++) {
                KTVUserModel *userModel = [KTVUserModel yy_modelWithJSON:list[i]];
                [userLists addObject:userModel];
            }
        }
        if (block) {
            block([userLists copy], ackModel);
        }
        NSLog(@"[%@]-ktvGetApplyAudienceList %@ \n %@", [self class], dic, ackModel.response);
    }];
}

+ (void)inviteInteract:(NSString *)roomID
                   uid:(NSString *)uid
                seatID:(NSString *)seatID
                 block:(void (^)(RTMACKModel *model))block {
    NSDictionary *dic = @{@"room_id" : roomID,
                          @"audience_user_id" : uid,
                          @"seat_id" : @(seatID.integerValue)};
    dic = [PublicParameterCompoments addTokenToParams:dic];
    
    [[KTVRTCManager shareRtc] emitWithAck:@"ktvInviteInteract" with:dic block:^(RTMACKModel * _Nonnull ackModel) {
        
        if (block) {
            block(ackModel);
        }
        NSLog(@"[%@]-ktvInviteInteract %@ | %@", [self class], dic, ackModel.response);
    }];
}

+ (void)agreeApply:(NSString *)roomID
               uid:(NSString *)uid
             block:(void (^)(RTMACKModel *model))block {
    NSDictionary *dic = @{@"room_id" : roomID,
                          @"audience_user_id" : uid};
    dic = [PublicParameterCompoments addTokenToParams:dic];
    
    [[KTVRTCManager shareRtc] emitWithAck:@"ktvAgreeApply" with:dic block:^(RTMACKModel * _Nonnull ackModel) {
        
        if (block) {
            block(ackModel);
        }
        NSLog(@"[%@]-ktvAgreeApply %@ \n %@", [self class], dic, ackModel.response);
    }];
}

+ (void)managerInteractApply:(NSString *)roomID
                        type:(NSInteger)type
                       block:(void (^)(RTMACKModel *model))block {
    NSDictionary *dic = @{@"room_id" : roomID,
                          @"type" : @(type)};
    dic = [PublicParameterCompoments addTokenToParams:dic];
    
    [[KTVRTCManager shareRtc] emitWithAck:@"ktvManageInteractApply" with:dic block:^(RTMACKModel * _Nonnull ackModel) {
        
        if (block) {
            block(ackModel);
        }
        NSLog(@"[%@]-ktvManagerInteractApply %@ \n %@", [self class], dic, ackModel.response);
    }];
}

+ (void)managerSeat:(NSString *)roomID
             seatID:(NSString *)seatID
               type:(NSInteger)type
              block:(void (^)(RTMACKModel *model))block {
    NSDictionary *dic = @{@"room_id" : roomID,
                          @"seat_id" : @(seatID.integerValue),
                          @"type" : @(type)};
    dic = [PublicParameterCompoments addTokenToParams:dic];
    
    [[KTVRTCManager shareRtc] emitWithAck:@"ktvManageSeat" with:dic block:^(RTMACKModel * _Nonnull ackModel) {
        
        if (block) {
            block(ackModel);
        }
        NSLog(@"[%@]-ktvManageSeat %@ \n %@", [self class], dic, ackModel.response);
    }];
}

+ (void)finishLive:(NSString *)roomID {
    if (IsEmptyStr(roomID)) {
        return;
    }
    NSDictionary *dic = @{@"room_id" : roomID};
    dic = [PublicParameterCompoments addTokenToParams:dic];
    
    [[KTVRTCManager shareRtc] emitWithAck:@"ktvFinishLive" with:dic block:^(RTMACKModel * _Nonnull ackModel) {
        NSLog(@"[%@]-ktvFinishLive %@ \n %@", [self class], dic, ackModel.response);
    }];
}

+ (void)requestPickedSongList:(NSString *)roomID
                        block:(void(^)(RTMACKModel *model, NSArray<KTVSongModel*> *list))block {
    
    if (IsEmptyStr(roomID)) {
        return;
    }
    NSDictionary *dic = @{@"room_id" : roomID};
    dic = [PublicParameterCompoments addTokenToParams:dic];
    
    [[KTVRTCManager shareRtc] emitWithAck:@"ktvGetRequestSongList" with:dic block:^(RTMACKModel * _Nonnull ackModel) {
        
        NSArray *list = nil;
        if ([KTVRTMManager ackModelResponseClass:ackModel]) {
            list = [NSArray yy_modelArrayWithClass:[KTVSongModel class] json:ackModel.response[@"song_list"]];
        }
        if (block) {
            block(ackModel, list);
        }
        NSLog(@"[%@]-ktvGetAudienceList %@ | %@", [self class], dic, ackModel.response);
    }];
}

+ (void)pickSong:(KTVSongModel *)songModel
          roomID:(NSString *)roomID
           block:(void (^)(RTMACKModel * _Nonnull))complete {
    NSDictionary *dic = @{
        @"song_id" : songModel.musicId,
        @"room_id" : roomID,
        @"song_name" : songModel.musicName,
        @"song_duration" : @(songModel.musicAllTime),
        @"cover_url" : songModel.coverURLString,
    };
    dic = [PublicParameterCompoments addTokenToParams:dic];
    
    [[KTVRTCManager shareRtc] emitWithAck:@"ktvRequestSong" with:dic block:^(RTMACKModel * _Nonnull ackModel) {
        
        if (complete) {
            complete(ackModel);
        }
        NSLog(@"[%@]-ktvRequestSong %@ | %@", [self class], dic, ackModel.response);
    }];
}

+ (void)cutOffSong:(NSString *)roomID
             block:(void(^)(RTMACKModel *model))complete {
    NSDictionary *dic = @{
        @"room_id" : roomID,
    };
    dic = [PublicParameterCompoments addTokenToParams:dic];
    
    [[KTVRTCManager shareRtc] emitWithAck:@"ktvCutOffSong" with:dic block:^(RTMACKModel * _Nonnull ackModel) {
        
        if (complete) {
            complete(ackModel);
        }
        
        NSLog(@"[%@]-ktvCutOffSong %@ | %@", [self class], dic, ackModel.response);
    }];
}

+ (void)finishSing:(NSString *)roomID
            songID:(NSString *)songID
             score:(NSInteger)score
             block:(void(^)(KTVSongModel *songModel,
                            RTMACKModel *model))complete {
    NSDictionary *dic = @{
        @"room_id" : roomID,
        @"song_id" : songID,
        @"score" : @(score),
    };
    dic = [PublicParameterCompoments addTokenToParams:dic];
    
    [[KTVRTCManager shareRtc] emitWithAck:@"ktvFinishSing" with:dic block:^(RTMACKModel * _Nonnull ackModel) {
        
        KTVSongModel *songModel = nil;
        if ([KTVRTMManager ackModelResponseClass:ackModel]) {
            songModel = [KTVSongModel yy_modelWithJSON:ackModel.response[@"next_song"]];
        }
        
        if (complete) {
            complete(songModel, ackModel);
        }
        
        NSLog(@"[%@]-ktvFinishSing %@ | %@", [self class], dic, ackModel.response);
    }];
}


#pragma mark - Audience API

+ (void)joinLiveRoom:(NSString *)roomID
            userName:(NSString *)userName
               block:(void (^)(NSString *RTCToken,
                               KTVRoomModel *roomModel,
                               KTVUserModel *userModel,
                               KTVUserModel *hostUserModel,
                               KTVSongModel *songModel,
                               NSArray<KTVSeatModel *> *seatList,
                               RTMACKModel *model))block {
    NSDictionary *dic = @{@"room_id" : roomID,
                          @"user_name" : userName};
    dic = [PublicParameterCompoments addTokenToParams:dic];
    
    [[KTVRTCManager shareRtc] emitWithAck:@"ktvJoinLiveRoom" with:dic block:^(RTMACKModel * _Nonnull ackModel) {
        
        NSString *RTCToken = @"";
        KTVRoomModel *roomModel = nil;
        KTVUserModel *hostUserModel = nil;
        KTVUserModel *userModel = nil;
        KTVSongModel *songModel = [[KTVSongModel alloc] init];
        NSMutableArray<KTVSeatModel *> *seatList = [[NSMutableArray alloc] init];;
        if ([KTVRTMManager ackModelResponseClass:ackModel]) {
            NSDictionary *songDic = ackModel.response[@"cur_song"];
            songModel = [KTVSongModel yy_modelWithJSON:songDic];
            
            roomModel = [KTVRoomModel yy_modelWithJSON:ackModel.response[@"room_info"]];
            hostUserModel = [KTVUserModel yy_modelWithJSON:ackModel.response[@"host_info"]];
            userModel = [KTVUserModel yy_modelWithJSON:ackModel.response[@"user_info"]];
            RTCToken = [NSString stringWithFormat:@"%@", ackModel.response[@"rtc_token"]];
            NSDictionary *seatDic = ackModel.response[@"seat_list"];
            for (int i = 0; i < seatDic.allKeys.count; i++) {
                NSString *keyStr = [NSString stringWithFormat:@"%ld", (long)(i + 1)];
                KTVSeatModel *seatModel = [KTVSeatModel yy_modelWithJSON:seatDic[keyStr]];
                seatModel.index = keyStr.integerValue;
                [seatList addObject:seatModel];
            }
        }
        if (block) {
            block(RTCToken,
                  roomModel,
                  userModel,
                  hostUserModel,
                  songModel,
                  [seatList copy],
                  ackModel);
        }
        NSLog(@"[%@]-ktvJoinLiveRoom %@ \n %@", [self class], dic, ackModel.response);
    }];
}

+ (void)replyInvite:(NSString *)roomID
              reply:(NSInteger)reply
              block:(void (^)(RTMACKModel *model))block {
    NSDictionary *dic = @{@"room_id" : roomID,
                          @"reply" : @(reply)};
    dic = [PublicParameterCompoments addTokenToParams:dic];
    
    [[KTVRTCManager shareRtc] emitWithAck:@"ktvReplyInvite" with:dic block:^(RTMACKModel * _Nonnull ackModel) {
        
        if (block) {
            block(ackModel);
        }
        NSLog(@"[%@]-ktvReplyInvite %@ \n %@", [self class], dic, ackModel.response);
    }];
}

+ (void)finishInteract:(NSString *)roomID
                seatID:(NSString *)seatID
                 block:(void (^)(RTMACKModel *model))block {
    NSDictionary *dic = @{@"room_id" : roomID,
                          @"seat_id" : @(seatID.integerValue)};
    dic = [PublicParameterCompoments addTokenToParams:dic];
    
    [[KTVRTCManager shareRtc] emitWithAck:@"ktvFinishInteract" with:dic block:^(RTMACKModel * _Nonnull ackModel) {

        if (block) {
            block(ackModel);
        }
        NSLog(@"[%@]-ktvFinishInteract %@ \n %@", [self class], dic, ackModel.response);
    }];
}

+ (void)applyInteract:(NSString *)roomID
               seatID:(NSString *)seatID
                block:(void (^)(BOOL isNeedApply,
                                RTMACKModel *model))block {
    NSDictionary *dic = @{@"room_id" : roomID,
                          @"seat_id" : @(seatID.integerValue)};
    dic = [PublicParameterCompoments addTokenToParams:dic];
    
    [[KTVRTCManager shareRtc] emitWithAck:@"ktvApplyInteract" with:dic block:^(RTMACKModel * _Nonnull ackModel) {
        
        BOOL isNeedApply = NO;
        if (ackModel.response &&
            [ackModel.response isKindOfClass:[NSDictionary class]]) {
            isNeedApply = [[NSString stringWithFormat:@"%@", ackModel.response[@"is_need_apply"]] boolValue];
        }
        if (block) {
            block(isNeedApply, ackModel);
        }
        NSLog(@"[%@]-ktvApplyInteract %@ \n %@", [self class], dic, ackModel.response);
    }];
}

+ (void)leaveLiveRoom:(NSString *)roomID {
    NSDictionary *dic = @{@"room_id" : roomID};
    dic = [PublicParameterCompoments addTokenToParams:dic];
    
    [[KTVRTCManager shareRtc] emitWithAck:@"ktvLeaveLiveRoom" with:dic block:^(RTMACKModel * _Nonnull ackModel) {
        NSLog(@"[%@]-ktvLeaveLiveRoom %@ \n %@", [self class], dic, ackModel.response);
    }];
}


#pragma mark - Publish API

+ (void)getActiveLiveRoomListWithBlock:(void (^)(NSArray<KTVRoomModel *> *roomList,
                                                 RTMACKModel *model))block {
    NSDictionary *dic = [PublicParameterCompoments addTokenToParams:nil];
    
    [[KTVRTCManager shareRtc] emitWithAck:@"ktvGetActiveLiveRoomList" with:dic block:^(RTMACKModel * _Nonnull ackModel) {
        
        NSMutableArray<KTVRoomModel *> *roomModelList = [[NSMutableArray alloc] init];
        if ([KTVRTMManager ackModelResponseClass:ackModel]) {
            NSArray *list = ackModel.response[@"room_list"];
            for (int i = 0; i < list.count; i++) {
                KTVRoomModel *roomModel = [KTVRoomModel yy_modelWithJSON:list[i]];
                [roomModelList addObject:roomModel];
            }
        }
        if (block) {
            block([roomModelList copy], ackModel);
        }
        NSLog(@"[%@]-ktvGetActiveLiveRoomList %@ \n %@", [self class], dic, ackModel.response);
    }];
}

+ (void)clearUser:(void (^)(RTMACKModel *model))block {
    NSDictionary *dic = [PublicParameterCompoments addTokenToParams:nil];
    
    [[KTVRTCManager shareRtc] emitWithAck:@"ktvClearUser" with:dic block:^(RTMACKModel * _Nonnull ackModel) {
        
        if (block) {
            block(ackModel);
        }
        NSLog(@"[%@]-ktvClearUser %@ \n %@", [self class], dic, ackModel.response);
    }];
}

+ (void)sendMessage:(NSString *)roomID
            message:(NSString *)message
              block:(void (^)(RTMACKModel *model))block {
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)message,NULL,NULL,kCFStringEncodingUTF8));
    NSDictionary *dic = @{@"room_id" : roomID,
                          @"message" : encodedString};
    dic = [PublicParameterCompoments addTokenToParams:dic];
    
    [[KTVRTCManager shareRtc] emitWithAck:@"ktvSendMessage" with:dic block:^(RTMACKModel * _Nonnull ackModel) {
        
        if (block) {
            block(ackModel);
        }
        NSLog(@"[%@]-ktvSendMessage %@ \n %@", [self class], dic, ackModel.response);
    }];
}

+ (void)updateMediaStatus:(NSString *)roomID
                      mic:(NSInteger)mic
                    block:(void (^)(RTMACKModel *model))block {
    NSDictionary *dic = @{@"room_id" : roomID,
                          @"mic" : @(mic)};
    dic = [PublicParameterCompoments addTokenToParams:dic];
    
    [[KTVRTCManager shareRtc] emitWithAck:@"ktvUpdateMediaStatus" with:dic block:^(RTMACKModel * _Nonnull ackModel) {
        
        if (block) {
            block(ackModel);
        }
        NSLog(@"[%@]-ktvUpdateMediaStatus %@ \n %@", [self class], dic, ackModel.response);
    }];
}

+ (void)reconnectWithBlock:(void (^)(NSString *RTCToken,
                                     KTVRoomModel *roomModel,
                                     KTVUserModel *userModel,
                                     KTVUserModel *hostUserModel,
                                     KTVSongModel *songModel,
                                     NSArray<KTVSeatModel *> *seatList,
                                     RTMACKModel *model))block {
    NSDictionary *dic = [PublicParameterCompoments addTokenToParams:nil];
    
    [[KTVRTCManager shareRtc] emitWithAck:@"ktvReconnect" with:dic block:^(RTMACKModel * _Nonnull ackModel) {
        
        KTVRoomModel *roomModel = nil;
        KTVUserModel *hostUserModel = nil;
        KTVUserModel *userModel = nil;
        KTVSongModel *songModel = nil;
        NSMutableArray<KTVSeatModel *> *seatList = [[NSMutableArray alloc] init];
        NSString *RTCToken = @"";
        if ([KTVRTMManager ackModelResponseClass:ackModel]) {
            roomModel = [KTVRoomModel yy_modelWithJSON:ackModel.response[@"room_info"]];
            hostUserModel = [KTVUserModel yy_modelWithJSON:ackModel.response[@"host_info"]];
            userModel = [KTVUserModel yy_modelWithJSON:ackModel.response[@"user_info"]];
            songModel = [KTVSongModel yy_modelWithJSON:ackModel.response[@"cur_song"]];
            NSDictionary *seatDic = ackModel.response[@"seat_list"];
            for (int i = 0; i < seatDic.allKeys.count; i++) {
                NSString *keyStr = [NSString stringWithFormat:@"%ld", (long)(i + 1)];
                KTVSeatModel *seatModel = [KTVSeatModel yy_modelWithJSON:seatDic[keyStr]];
                seatModel.index = keyStr.integerValue;
                [seatList addObject:seatModel];
            }
            RTCToken = [NSString stringWithFormat:@"%@", ackModel.response[@"rtc_token"]];
        }
        if (block) {
            block(RTCToken,
                  roomModel,
                  userModel,
                  hostUserModel,
                  songModel,
                  [seatList copy],
                  ackModel);
        }
        NSLog(@"[%@]-ktvReconnect %@ \n %@", [self class], dic, ackModel.response);
    }];
}

#pragma mark - Notification Message

+ (void)onAudienceJoinRoomWithBlock:(void (^)(KTVUserModel *userModel,
                                              NSInteger count))block {
    [[KTVRTCManager shareRtc] onSceneListener:@"ktvOnAudienceJoinRoom" block:^(RTMNoticeModel * _Nonnull noticeModel) {
        
        KTVUserModel *model = nil;
        NSInteger count = -1;
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            model = [KTVUserModel yy_modelWithJSON:noticeModel.data[@"user_info"]];
            NSString *str = [NSString stringWithFormat:@"%@", noticeModel.data[@"audience_count"]];
            count = [str integerValue];
        }
        if (block) {
            block(model, count);
        }
        NSLog(@"[%@]-ktvOnAudienceJoinRoom %@", [self class], noticeModel.data);
    }];
}

+ (void)onAudienceLeaveRoomWithBlock:(void (^)(KTVUserModel *userModel,
                                               NSInteger count))block {
    [[KTVRTCManager shareRtc] onSceneListener:@"ktvOnAudienceLeaveRoom" block:^(RTMNoticeModel * _Nonnull noticeModel) {
        
        KTVUserModel *model = nil;
        NSInteger count = -1;
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            model = [KTVUserModel yy_modelWithJSON:noticeModel.data[@"user_info"]];
            NSString *str = [NSString stringWithFormat:@"%@", noticeModel.data[@"audience_count"]];
            count = [str integerValue];
        }
        if (block) {
            block(model, count);
        }
        NSLog(@"[%@]-ktvOnAudienceLeaveRoom %@", [self class], noticeModel.data);
    }];
}

+ (void)onFinishLiveWithBlock:(void (^)(NSString *rommID, NSInteger type))block {
    [[KTVRTCManager shareRtc] onSceneListener:@"ktvOnFinishLive" block:^(RTMNoticeModel * _Nonnull noticeModel) {
        
        NSInteger type = -1;
        NSString *rommID = @"";
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            NSString *str = [NSString stringWithFormat:@"%@", noticeModel.data[@"type"]];
            type = [str integerValue];
            rommID = [NSString stringWithFormat:@"%@", noticeModel.data[@"room_id"]];
        }
        if (block) {
            block(rommID, type);
        }
        NSLog(@"[%@]-ktvOnFinishLive %@", [self class], noticeModel.data);
    }];
}

+ (void)onJoinInteractWithBlock:(void (^)(KTVUserModel *userModel,
                                          NSString *seatID))block {
    [[KTVRTCManager shareRtc] onSceneListener:@"ktvOnJoinInteract" block:^(RTMNoticeModel * _Nonnull noticeModel) {
        
        KTVUserModel *model = nil;
        NSString *seatID = @"";
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            model = [KTVUserModel yy_modelWithJSON:noticeModel.data[@"user_info"]];
            seatID = [NSString stringWithFormat:@"%@", noticeModel.data[@"seat_id"]];
        }
        if (block) {
            block(model, seatID);
        }
        NSLog(@"[%@]-ktvOnJoinInteract %@", [self class], noticeModel.data);
    }];
}

+ (void)onFinishInteractWithBlock:(void (^)(KTVUserModel *userModel,
                                            NSString *seatID,
                                            NSInteger type))block {
    [[KTVRTCManager shareRtc] onSceneListener:@"ktvOnFinishInteract" block:^(RTMNoticeModel * _Nonnull noticeModel) {
        
        KTVUserModel *model = nil;
        NSString *seatID = @"";
        NSInteger type = -1;
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            model = [KTVUserModel yy_modelWithJSON:noticeModel.data[@"user_info"]];
            seatID = [NSString stringWithFormat:@"%@", noticeModel.data[@"seat_id"]];
            NSString *str = [NSString stringWithFormat:@"%@", noticeModel.data[@"type"]];
            type = [str integerValue];
        }
        if (block) {
            block(model, seatID, type);
        }
        NSLog(@"[%@]-ktvOnFinishInteract %@", [self class], noticeModel.data);
    }];
}

+ (void)onSeatStatusChangeWithBlock:(void (^)(NSString *seatID,
                                              NSInteger type))block {
    [[KTVRTCManager shareRtc] onSceneListener:@"ktvOnSeatStatusChange" block:^(RTMNoticeModel * _Nonnull noticeModel) {
        
        NSInteger type = -1;
        NSString *seatID = @"";
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            NSString *str = [NSString stringWithFormat:@"%@", noticeModel.data[@"type"]];
            type = [str integerValue];
            seatID = [NSString stringWithFormat:@"%@", noticeModel.data[@"seat_id"]];
        }
        if (block) {
            block(seatID, type);
        }
        NSLog(@"[%@]-ktvOnSeatStatusChange %@", [self class], noticeModel.data);
    }];
}

+ (void)onMediaStatusChangeWithBlock:(void (^)(KTVUserModel *userModel,
                                               NSString *seatID,
                                               NSInteger mic))block {
    [[KTVRTCManager shareRtc] onSceneListener:@"ktvOnMediaStatusChange" block:^(RTMNoticeModel * _Nonnull noticeModel) {
        
        KTVUserModel *model = nil;
        NSString *seatID = @"";
        NSInteger mic = -1;
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            model = [KTVUserModel yy_modelWithJSON:noticeModel.data[@"user_info"]];
            seatID = [NSString stringWithFormat:@"%@", noticeModel.data[@"seat_id"]];
            NSString *str = [NSString stringWithFormat:@"%@", noticeModel.data[@"mic"]];
            mic = [str integerValue];
        }
        if (block) {
            block(model, seatID, mic);
        }
        NSLog(@"[%@]-ktvOnMediaStatusChange %@", [self class], noticeModel.data);
    }];
}

+ (void)onMessageWithBlock:(void (^)(KTVUserModel *userModel,
                                     NSString *message))block {
    [[KTVRTCManager shareRtc] onSceneListener:@"ktvOnMessage" block:^(RTMNoticeModel * _Nonnull noticeModel) {
        
        KTVUserModel *model = nil;
        NSString *message = @"";
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            model = [KTVUserModel yy_modelWithJSON:noticeModel.data[@"user_info"]];
            message = [NSString stringWithFormat:@"%@", noticeModel.data[@"message"]];
        }
        if (block) {
            block(model, message);
        }
        NSLog(@"[%@]-ktvOnMessage %@", [self class], noticeModel.data);
    }];
}

+ (void)onPickSongBlock:(void(^)(KTVSongModel *songModel))block {
    [[KTVRTCManager shareRtc] onSceneListener:@"ktvOnRequestSong" block:^(RTMNoticeModel * _Nonnull noticeModel) {
        
        KTVSongModel *songModel = nil;
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            songModel = [KTVSongModel yy_modelWithJSON:noticeModel.data[@"song"]];
        }
        if (block) {
            block(songModel);
        }
        NSLog(@"[%@]-ktvOnRequestSong %@", [self class], noticeModel.data);
    }];
}

+ (void)onStartSingSongBlock:(void(^)(KTVSongModel *songModel))block {
    [[KTVRTCManager shareRtc] onSceneListener:@"ktvOnStartSing" block:^(RTMNoticeModel * _Nonnull noticeModel) {
        
        KTVSongModel *songModel = nil;
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            songModel = [KTVSongModel yy_modelWithJSON:noticeModel.data[@"song"]];
        }
        if (block) {
            block(songModel);
        }
        NSLog(@"[%@]-ktvOnStartSing %@", [self class], noticeModel.data);
    }];
}

+ (void)onFinishSingSongBlock:(void(^)(KTVSongModel *nextSongModel, NSInteger score))block {
    [[KTVRTCManager shareRtc] onSceneListener:@"ktvOnFinishSing" block:^(RTMNoticeModel * _Nonnull noticeModel) {
        
        KTVSongModel *nextSongModel = nil;
        NSInteger score = 0;
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            nextSongModel = [KTVSongModel yy_modelWithJSON:noticeModel.data[@"next_song"]];
            score = [noticeModel.data[@"score"] integerValue];
        }
        if (block) {
            block(nextSongModel, score);
        }
        NSLog(@"[%@]-ktvOnFinishSingSong %@", [self class], noticeModel.data);
    }];
}


#pragma mark - Single Notification Message

+ (void)onInviteInteractWithBlock:(void (^)(KTVUserModel *hostUserModel,
                                            NSString *seatID))block {
    [[KTVRTCManager shareRtc] onSceneListener:@"ktvOnInviteInteract" block:^(RTMNoticeModel * _Nonnull noticeModel) {
        
        KTVUserModel *model = nil;
        NSString *seatID = @"";
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            model = [KTVUserModel yy_modelWithJSON:noticeModel.data[@"host_info"]];
            seatID = [NSString stringWithFormat:@"%@", noticeModel.data[@"seat_id"]];
        }
        if (block) {
            block(model, seatID);
        }
        NSLog(@"[%@]-ktvOnInviteInteract %@", [self class], noticeModel.data);
    }];
}

+ (void)onInviteResultWithBlock:(void (^)(KTVUserModel *userModel,
                                          NSInteger reply))block {
    [[KTVRTCManager shareRtc] onSceneListener:@"ktvOnInviteResult" block:^(RTMNoticeModel * _Nonnull noticeModel) {
        
        KTVUserModel *model = nil;
        NSInteger reply = -1;
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            model = [KTVUserModel yy_modelWithJSON:noticeModel.data[@"user_info"]];
            NSString *str = [NSString stringWithFormat:@"%@", noticeModel.data[@"reply"]];
            reply = [str integerValue];
        }
        if (block) {
            block(model, reply);
        }
        NSLog(@"[%@]-ktvOnInviteResult %@", [self class], noticeModel.data);
    }];
}

+ (void)onApplyInteractWithBlock:(void (^)(KTVUserModel *userModel,
                                           NSString *seatID))block {
    [[KTVRTCManager shareRtc] onSceneListener:@"ktvOnApplyInteract" block:^(RTMNoticeModel * _Nonnull noticeModel) {
        
        KTVUserModel *model = nil;
        NSString *seatID = @"";
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            model = [KTVUserModel yy_modelWithJSON:noticeModel.data[@"user_info"]];
            seatID = [NSString stringWithFormat:@"%@", noticeModel.data[@"seat_id"]];
        }
        if (block) {
            block(model, seatID);
        }
        NSLog(@"[%@]-ktvOnApplyInteract %@", [self class], noticeModel.data);
    }];
}

+ (void)onMediaOperateWithBlock:(void (^)(NSInteger mic))block  {
    [[KTVRTCManager shareRtc] onSceneListener:@"ktvOnMediaOperate" block:^(RTMNoticeModel * _Nonnull noticeModel) {
        
        NSInteger mic = -1;
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            NSString *str = [NSString stringWithFormat:@"%@", noticeModel.data[@"mic"]];
            mic = [str integerValue];
        }
        if (block) {
            block(mic);
        }
        NSLog(@"[%@]-ktvOnMediaOperate %@", [self class], noticeModel.data);
    }];
}

+ (void)onClearUserWithBlock:(void (^)(NSString *uid))block {
    [[KTVRTCManager shareRtc] onSceneListener:@"ktvOnClearUser" block:^(RTMNoticeModel * _Nonnull noticeModel) {
        
        NSString *uid = @"";
        if (noticeModel.data && [noticeModel.data isKindOfClass:[NSDictionary class]]) {
            uid = [NSString stringWithFormat:@"%@", noticeModel.data[@"user_id"]];
        }
        if (block) {
            block(uid);
        }
        NSLog(@"[%@]-ktvOnClearUser %@", [self class], noticeModel.data);
    }];
}

#pragma mark - tool

+ (BOOL)ackModelResponseClass:(RTMACKModel *)ackModel {
    if ([ackModel.response isKindOfClass:[NSDictionary class]]) {
        return YES;
    } else {
        return NO;
    }
}

@end
