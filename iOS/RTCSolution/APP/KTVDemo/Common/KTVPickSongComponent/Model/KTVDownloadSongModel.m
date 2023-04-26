// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
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
