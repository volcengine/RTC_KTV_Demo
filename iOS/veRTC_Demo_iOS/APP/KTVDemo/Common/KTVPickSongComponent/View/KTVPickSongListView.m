//
//  KTVPickSongListView.m
//  veRTC_Demo
//
//  Created by on 2022/1/19.
//  
//

#import "KTVPickSongListView.h"

@interface KTVPickSongListView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) KTVSongListViewType type;

@end

@implementation KTVPickSongListView

- (instancetype)initWithType:(KTVSongListViewType)type {
    if (self = [super init]) {
        self.type = type;
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KTVPickSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([KTVPickSongTableViewCell class]) forIndexPath:indexPath];
    cell.type = self.type;
    
    if (indexPath.row < self.dataArray.count) {
        cell.songModel = self.dataArray[indexPath.row];
    }
    
    __weak typeof(self) weakSelf = self;
    cell.pickSongBlock = ^(KTVSongModel * _Nonnull model) {
    
        if (weakSelf.pickSongBlock) {
            weakSelf.pickSongBlock(model);
        }
    };
    return cell;
}

- (void)refreshView {
    [self.tableView reloadData];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 47;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, [DeviceInforTool getVirtualHomeHeight], 0);
        _tableView.backgroundColor = UIColor.clearColor;
        
        [_tableView registerClass:[KTVPickSongTableViewCell class] forCellReuseIdentifier:NSStringFromClass([KTVPickSongTableViewCell class])];
    }
    return _tableView;
}

@end
