// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import "KTVMusicLyricsView.h"
#import "KTVMusicLyricsLineCell.h"
#import "KTVMusicLyricsAnalyzer.h"
#import "KTVMusicLyricsInfo.h"
#import "KTVMusicLyricsLine.h"

static const CGFloat TableViewTopMargin = 20.f;

@interface KTVMusicLyricsView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CAGradientLayer *coverLayer;

@property (nonatomic, strong, nullable) KTVMusicLyricsInfo *lyricsInfo;

@property (nonatomic, assign) NSUInteger currentRow;

@end

@implementation KTVMusicLyricsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 30;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.userInteractionEnabled = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        [_tableView registerClass:[KTVMusicLyricsLineCell class]
           forCellReuseIdentifier:[KTVMusicLyricsLineCell reuseIdentifier]];
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.offset(TableViewTopMargin);
        }];
        
        _coverLayer = [CAGradientLayer layer];
        _coverLayer.colors = @[
            (__bridge id)[UIColor colorWithRed:0.0 green:0.016 blue:0.247 alpha:0.2].CGColor,
            (__bridge id)[UIColor colorWithRed:0.0 green:0.016 blue:0.247 alpha:0.6].CGColor
        ];
        _coverLayer.locations = @[@0, @1];
        _coverLayer.startPoint = CGPointMake(0, 0);
        _coverLayer.endPoint = CGPointMake(0, 1);
        [self.layer addSublayer:_coverLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_tableView) {
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, _tableView.frame.size.height - _tableView.rowHeight, 0);
    }
    if (_coverLayer) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        CGFloat topMargin = TableViewTopMargin + 30;
        _coverLayer.frame = CGRectMake(0, topMargin, self.frame.size.width, self.frame.size.height - topMargin);
        [CATransaction commit];
    }
}

- (void)loadLrcByPath:(NSString *)path error:(NSError * _Nullable __autoreleasing *)error {
    _lyricsInfo = [KTVMusicLyricsAnalyzer analyzeLrcByPath:path error:error];
    [self resetStatus];
}

- (void)loadLrcBylrcString:(NSString *)string {
    _lyricsInfo = [KTVMusicLyricsAnalyzer analyzeLrcBylrcString:string];
    [self resetStatus];
}

- (void)playAtTime:(NSTimeInterval)time {
    if (self.tableView.dragging || self.tableView.tracking
        || self.tableView.decelerating || isnan(time)
        || !self.lyricsInfo.numberOfLines) {
        return;
    }
    time = MAX(time, 0) * 1000;
    NSUInteger currentRow = self.currentRow;
    if (currentRow >= self.lyricsInfo.numberOfLines) { // 异常保护
        [self scrollToTime:time fromIndex:0];
        return;
    }
    NSTimeInterval currentStartTime = self.lyricsInfo.lrcArray[currentRow].startTime;
    if (time < currentStartTime) {
        if (currentRow == 0) {
            return;
        }
        [self scrollToTime:time fromIndex:0];
        return;
    }
    if (currentRow == self.lyricsInfo.numberOfLines - 1) {
        return;
    }
    NSTimeInterval nextStartTime = self.lyricsInfo.lrcArray[currentRow+1].startTime;
    if (time < nextStartTime) {
        return;
    }
    [self scrollToTime:time fromIndex:currentRow+1];
}

- (void)resetStatus {
    self.currentRow = 0;
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:NO];
}

- (void)scrollToTime:(NSTimeInterval)time fromIndex:(NSUInteger)index {
    while (index<self.lyricsInfo.numberOfLines) {
        NSTimeInterval startTime = self.lyricsInfo.lrcArray[index].startTime;
        NSTimeInterval nextTime = 0;
        if (index+1 < self.lyricsInfo.numberOfLines) {
            nextTime = self.lyricsInfo.lrcArray[index+1].startTime;
        } else {
            nextTime = MAXFLOAT;
        }
        if (time >= startTime && time < nextTime) {
            self.currentRow = index;
            [self.tableView setContentOffset:CGPointMake(0, self.tableView.rowHeight * self.currentRow)
                                    animated:YES];
            NSLog(@"time %lf starTime %lf index %lu y %lf ly %@", time, startTime, index,
                  self.tableView.rowHeight * index, self.lyricsInfo.lrcArray[index].lrc);
            break;
        }
        ++index;
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lyricsInfo.numberOfLines;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KTVMusicLyricsLineCell *cell = [tableView dequeueReusableCellWithIdentifier:[KTVMusicLyricsLineCell reuseIdentifier]
                                                                   forIndexPath:indexPath];
    if (indexPath.row < self.lyricsInfo.numberOfLines) {
        [cell fillLyricsLine:self.lyricsInfo.lrcArray[indexPath.row]];
    }
    [cell showHighlighted:self.currentRow == indexPath.row];
    return cell;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self.tableView reloadData];
}

@end
