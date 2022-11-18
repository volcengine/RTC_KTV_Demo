//
//  KTVMusicReverberationView.m
//  veRTC_Demo
//
//  Created by on 2022/1/19.
//  
//

#import "KTVMusicReverberationView.h"
#import "KTVMusicReverberationItemView.h"
#import "KTVRTCManager.h"

@interface KTVMusicReverberationView ()

@property (nonatomic, copy) NSArray *dataList;
@property (nonatomic, copy) NSArray *itemList;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation KTVMusicReverberationView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.top.bottom.equalTo(self);
        }];
        
        CGFloat width = (50 * self.dataList.count) + ((self.dataList.count - 1) * 20);
        [self.scrollView addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(50);
        }];
        
        KTVMusicReverberationItemView *defaultItemView = nil;
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.dataList.count; i++) {
            KTVMusicReverberationItemView *itemView = [[KTVMusicReverberationItemView alloc] init];
            [itemView addTarget:self action:@selector(itemViewAction:) forControlEvents:UIControlEventTouchUpInside];
            itemView.message = self.dataList[i];;
            [self.contentView addSubview:itemView];
            [list addObject:itemView];
            
            if ([itemView.message isEqualToString:@"KTV"]) {
                defaultItemView = itemView;
            }
        }
        self.itemList = [list copy];
        
        if (defaultItemView) {
            [self itemViewAction:defaultItemView];
        }
        
        [list mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                       withFixedItemLength:50
                               leadSpacing:16
                               tailSpacing:16];
        [list mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.height.mas_equalTo(50);
        }];
    }
    return self;
}

- (void)itemViewAction:(KTVMusicReverberationItemView *)itemView {
    KTVMusicReverberationItemView *tempItemView = nil;
    for (KTVMusicReverberationItemView *select in self.itemList) {
        select.isSelect = NO;
        if ([select.message isEqualToString:itemView.message]) {
            tempItemView = select;
        }
    }
    if (tempItemView) {
        tempItemView.isSelect = YES;
    }
    
    if ([itemView.message isEqualToString:@"原声"]) {
        [[KTVRTCManager shareRtc] setVoiceReverbType:ByteRTCVoiceReverbOriginal];
    } else if ([itemView.message isEqualToString:@"回声"]) {
        [[KTVRTCManager shareRtc] setVoiceReverbType:ByteRTCVoiceReverbEcho];
    } else if ([itemView.message isEqualToString:@"演唱会"]) {
        [[KTVRTCManager shareRtc] setVoiceReverbType:ByteRTCVoiceReverbConcert];
    } else if ([itemView.message isEqualToString:@"空灵"]) {
        [[KTVRTCManager shareRtc] setVoiceReverbType:ByteRTCVoiceReverbEthereal];
    } else if ([itemView.message isEqualToString:@"KTV"]) {
        [[KTVRTCManager shareRtc] setVoiceReverbType:ByteRTCVoiceReverbKTV];
    } else if ([itemView.message isEqualToString:@"录音棚"]) {
        [[KTVRTCManager shareRtc] setVoiceReverbType:ByteRTCVoiceReverbStudio];
    } else {
        
    }
}

#pragma mark - Publish Action

- (void)resetItemState {
    KTVMusicReverberationItemView *defaultItemView = nil;
    for (int i = 0; i < self.contentView.subviews.count; i++) {
        KTVMusicReverberationItemView *itemView = self.contentView.subviews[i];
        if (itemView &&
            [itemView isKindOfClass:[KTVMusicReverberationItemView class]]) {
            if ([itemView.message isEqualToString:@"KTV"]) {
                defaultItemView = itemView;
                break;
            }
        }
    }
    if (defaultItemView) {
        [self itemViewAction:defaultItemView];
    }
}

#pragma mark - Getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

- (NSArray *)dataList {
    if (!_dataList) {
        _dataList = @[@"原声",
                      @"回声",
                      @"演唱会",
                      @"空灵",
                      @"KTV",
                      @"录音棚"];
    }
    return _dataList;
}

@end
