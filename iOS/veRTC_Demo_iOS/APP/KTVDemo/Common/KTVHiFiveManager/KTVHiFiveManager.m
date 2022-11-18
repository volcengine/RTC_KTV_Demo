//
//  KTVHiFiveManager.m
//  veRTC_Demo
//
//  Created by on 2022/1/21.
//  
//

#import "KTVHiFiveManager.h"
#import <HFOpenApi/HFOpenApi.h>
#import "KTVDownloadSongModel.h"

@implementation KTVHiFiveManager

#pragma mark - HiFive
+ (void)registerHiFive {
    
    NSString *userID = [LocalUserComponent userModel].uid;
    NSString *appID = HiFiveAppID;
    NSString *serverCode = HiFiveServerCode;
    [[HFOpenApiManager shared] registerAppWithAppId:appID serverCode:serverCode clientId:userID version:@"V4.1.2" success:^(id  _Nullable response) {
        
    } fail:^(NSError * _Nullable error) {
        
    }];
}

+ (void)requestHiFiveSongListComplete:(void (^)(NSArray<KTVSongModel *> * _Nullable, NSString * _Nullable))complete {

    [[HFOpenApiManager shared] channelSheetWithGroupId:HiFiveGroupID language:@"0" recoNum:@"5" page:@"1" pageSize:@"100" success:^(id  _Nullable response) {
        
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSArray *list = response[@"record"];
            NSDictionary *dict = list.firstObject;
            NSString *sheetID = [dict[@"sheetId"] description];
            [self requestHiFiveSongList:sheetID complete:complete];
        } else {
            if (complete) {
                complete(nil, @"data formate error");
            }
        }
        
    } fail:^(NSError * _Nullable error) {
        if (complete) {
            complete(nil, error.description);
        }
    }];
}

+ (void)requestHiFiveSongList:(NSString *)sheetID complete:(void (^)(NSArray<KTVSongModel *> * _Nullable, NSString * _Nullable))complete {
    [[HFOpenApiManager shared] sheetMusicWithSheetId:sheetID language:@"0" page:@"1" pageSize:@"100" success:^(id  _Nullable response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSArray *list = response[@"record"];
            NSArray *listModel = [NSArray yy_modelArrayWithClass:[KTVSongModel class] json:list];
            if (complete) {
                complete(listModel, nil);
            }
        } else {
            if (complete) {
                complete(nil, @"data formate error");
            }
        }
        
    } fail:^(NSError * _Nullable error) {
        if (complete) {
            complete(nil, error.description);
        }
    }];
}

+ (void)requestDownloadSongModel:(KTVSongModel *)songModel complete:(void(^)(KTVDownloadSongModel *downloadSongModel))complete {
    
    if (!songModel) {
        !complete? :complete(nil);
        return;
    }
    
    [[HFOpenApiManager shared] kHQListenWithMusicId:songModel.musicId audioFormat:@"mp3" audioRate:@"320" success:^(id  _Nullable response) {
        
        KTVDownloadSongModel *downloadModel = [KTVDownloadSongModel yy_modelWithJSON:response];
        !complete? :complete(downloadModel);
        
    } fail:^(NSError * _Nullable error) {
        [[ToastComponent shareToastComponent] showWithMessage:error.description];
        !complete? :complete(nil);
    }];
}

@end
