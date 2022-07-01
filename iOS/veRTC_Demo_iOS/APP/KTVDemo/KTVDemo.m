//
//  KTVDemo.m
//  KTVDemo
//
//  Created by bytedance on 2022/5/9.
//

#import "KTVDemo.h"
#import "KTVRTCManager.h"
#import <Core/NetworkReachabilityManager.h>
#import "KTVRoomListsViewController.h"

@implementation KTVDemo

- (void)pushDemoViewControllerBlock:(void (^)(BOOL result))block {
    [KTVRTCManager shareRtc].networkDelegate = [NetworkReachabilityManager sharedManager];
    [[KTVRTCManager shareRtc] connect:@"ktv"
                           loginToken:[LocalUserComponents userModel].loginToken
                                block:^(BOOL result) {
        if (result) {
            KTVRoomListsViewController *next = [[KTVRoomListsViewController alloc] init];
            UIViewController *topVC = [DeviceInforTool topViewController];
            [topVC.navigationController pushViewController:next animated:YES];
        } else {
            [[ToastComponents shareToastComponents] showWithMessage:@"连接失败"];
        }
        if (block) {
            block(result);
        }
    }];
}

@end
