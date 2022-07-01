//
//  KTVDownloadSongComponment.m
//  veRTC_Demo
//
//  Created by bytedance on 2022/1/20.
//  Copyright © 2022 bytedance. All rights reserved.
//

#import "KTVDownloadSongComponment.h"
#import "AFNetworking.h"

@interface KTVDownloadSongComponment ()

@property (nonatomic, strong) AFURLSessionManager *manager;

@end

@implementation KTVDownloadSongComponment

+ (instancetype)shared {
    static KTVDownloadSongComponment *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KTVDownloadSongComponment alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

+ (void)downloadWithURL:(NSString *)urlString filePath:(NSString *)filePath progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock complete:(void(^)(NSError *error))complete {
    if (!urlString) {
        NSError *error = [[NSError alloc] initWithDomain:@"地址不存在" code:-1 userInfo:nil];
        !complete? :complete(error);
        return;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        !complete? :complete(nil);
        return;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[[KTVDownloadSongComponment shared].manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        !downloadProgressBlock? :downloadProgressBlock(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        !complete? :complete(error);
    }] resume];
}

@end
