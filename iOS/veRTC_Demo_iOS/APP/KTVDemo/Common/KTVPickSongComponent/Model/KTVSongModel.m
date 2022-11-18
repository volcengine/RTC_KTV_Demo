//
//  KTVSongModel.m
//  veRTC_Demo
//
//  Created by on 2022/1/19.
//  
//

#import "KTVSongModel.h"

@implementation KTVSongModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"musicName" : @[@"song_name", @"musicName"],
        @"musicId" : @[@"song_id", @"musicId"],
        @"pickedUserID" : @"owner_user_id",
        @"pickedUserName" : @"owner_user_name",
        @"singStatus" : @"status",
        @"musicAllTime" : @[@"duration", @"song_duration"],
        @"singerList" : @"artist",
        @"coverList" : @"cover",
        @"coverURL" : @"cover_url",
    };
}

- (void)setSingerList:(NSArray *)singerList {
    NSDictionary *singerDict = singerList.lastObject;
    self.singerUserName = singerDict[@"name"]? :@"";
}

- (void)setCoverList:(NSArray *)coverList {
    NSDictionary *coverDict = coverList.lastObject;
    self.coverURLString = coverDict[@"url"]? :@"";
}

- (NSString *)coverURLString {
    if (_coverURLString.length > 0) {
        return _coverURLString;
    }
    return _coverURL;
}

@end
