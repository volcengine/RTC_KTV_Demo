//
//  KTVIMCompoments.m
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/23.
//  Copyright © 2021 . All rights reserved.
//

#import "KTVIMCompoments.h"
#import "KTVIMView.h"

@interface KTVIMCompoments ()

@property (nonatomic, strong) KTVIMView *KTVIMView;

@end

@implementation KTVIMCompoments

- (instancetype)initWithSuperView:(UIView *)superView {
    self = [super init];
    if (self) {
        [superView addSubview:self.KTVIMView];
        [self.KTVIMView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.bottom.mas_equalTo(-101 - ([DeviceInforTool getVirtualHomeHeight]));
            make.top.mas_equalTo(435 + [DeviceInforTool getStatusBarHight]);
        }];
    }
    return self;
}

#pragma mark - Publish Action

- (void)addIM:(KTVIMModel *)model {
    NSMutableArray *datas = [[NSMutableArray alloc] initWithArray:self.KTVIMView.dataLists];
    [datas addObject:model];
    self.KTVIMView.dataLists = [datas copy];
}

#pragma mark - getter

- (KTVIMView *)KTVIMView {
    if (!_KTVIMView) {
        _KTVIMView = [[KTVIMView alloc] init];
    }
    return _KTVIMView;
}

@end
