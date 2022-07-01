//
//  KTVRoomUserListView.m
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/18.
//  Copyright © 2021 . All rights reserved.
//

#import "KTVRoomAudienceListsView.h"
#import "KTVEmptyCompoments.h"

@interface KTVRoomAudienceListsView ()<UITableViewDelegate, UITableViewDataSource, KTVRoomUserListtCellDelegate>

@property (nonatomic, strong) UITableView *roomTableView;
@property (nonatomic, strong) KTVEmptyCompoments *emptyCompoments;

@end


@implementation KTVRoomAudienceListsView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.roomTableView];
        [self.roomTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - Publish Action

- (void)setDataLists:(NSArray *)dataLists {
    _dataLists = dataLists;
    
    [self.roomTableView reloadData];
    if (dataLists.count <= 0) {
        [self.emptyCompoments show];
    } else {
        [self.emptyCompoments dismiss];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KTVRoomUserListtCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KTVRoomUserListtCellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataLists[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataLists.count;
}

#pragma mark - KTVRoomUserListtCellDelegate

- (void)KTVRoomUserListtCell:(KTVRoomUserListtCell *)KTVRoomUserListtCell clickButton:(id)model {
    if ([self.delegate respondsToSelector:@selector(KTVRoomAudienceListsView:clickButton:)]) {
        [self.delegate KTVRoomAudienceListsView:self clickButton:model];
    }
}

#pragma mark - getter

- (UITableView *)roomTableView {
    if (!_roomTableView) {
        _roomTableView = [[UITableView alloc] init];
        _roomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _roomTableView.delegate = self;
        _roomTableView.dataSource = self;
        [_roomTableView registerClass:KTVRoomUserListtCell.class forCellReuseIdentifier:@"KTVRoomUserListtCellID"];
        _roomTableView.backgroundColor = [UIColor clearColor];
    }
    return _roomTableView;
}

- (KTVEmptyCompoments *)emptyCompoments {
    if (!_emptyCompoments) {
        _emptyCompoments = [[KTVEmptyCompoments alloc] initWithView:self
                                                                  message:@"暂无在线观众"];
    }
    return _emptyCompoments;
}

- (void)dealloc {
    NSLog(@"dealloc %@",NSStringFromClass([self class]));
}

@end
