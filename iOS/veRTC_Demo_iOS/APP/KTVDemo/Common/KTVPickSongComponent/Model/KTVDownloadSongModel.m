//
//  KTVDownloadSongModel.m
//  veRTC_Demo
//
//  Created by on 2022/1/20.
//  
//

#import "KTVDownloadSongModel.h"

@implementation KTVDownloadSongModel

- (void)setSubVersions:(NSArray *)subVersions {
    _subVersions = subVersions;
    for (NSDictionary *data in subVersions) {
        if ([data[@"versionName"] isEqualToString:@"左右声道_320_mp3"]) {
            self.mp3URLString = data[@"path"];
            break;
        }
    }
}

@end
