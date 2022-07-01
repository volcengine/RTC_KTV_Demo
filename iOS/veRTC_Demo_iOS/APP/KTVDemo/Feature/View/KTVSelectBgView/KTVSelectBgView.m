//
//  KTVSelectBgView.m
//  veRTC_Demo
//
//  Created by bytedance on 2021/11/26.
//  Copyright © 2021 . All rights reserved.
//

#import "KTVSelectBgView.h"
#import "KTVSelectBgItemView.h"

@interface KTVSelectBgView ()

@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation KTVSelectBgView

- (instancetype)init {
    self = [super init];
    if (self) {
        for (int i = 0; i < 3; i++) {
            KTVSelectBgItemView *itemView = [[KTVSelectBgItemView alloc] initWithIndex:i];
            [itemView addTarget:self action:@selector(itemViewAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:itemView];
            [self.list addObject:itemView];
        }
        [self.list mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:12 leadSpacing:0 tailSpacing:0];
        [self.list mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
        }];
        
        KTVSelectBgItemView *itemView = self.list.firstObject;
        itemView.isSelected = YES;
    }
    return self;
}

- (NSString *)getDefaults {
    KTVSelectBgItemView *itemView = self.list.firstObject;
    return [itemView getBackgroundImageName];
}

- (void)itemViewAction:(KTVSelectBgItemView *)itemView {
    for (KTVSelectBgItemView *item in self.list) {
        item.isSelected = NO;
    }
    itemView.isSelected = YES;
    if (self.clickBlock) {
        self.clickBlock([itemView getBackgroundImageName],
                        [itemView getBackgroundSmallImageName]);
    }
}

#pragma mark - Getter

- (NSMutableArray *)list {
    if (!_list) {
        _list = [[NSMutableArray alloc] init];
    }
    return _list;
}

@end
