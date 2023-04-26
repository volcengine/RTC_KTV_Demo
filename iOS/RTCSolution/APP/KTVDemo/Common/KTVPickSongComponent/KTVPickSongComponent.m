// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import "KTVPickSongComponent.h"
#import "KTVPickSongTopView.h"
#import "KTVPickSongListView.h"
#import "KTVPickSongManager.h"
#import "KTVHiFiveManager.h"
#import "KTVRTSManager.h"

@interface KTVPickSongComponent ()

@property (nonatomic, copy) NSString *roomID;

@property (nonatomic, weak) UIView *superView;
@property (nonatomic, strong) UIView *pickSongView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) KTVPickSongTopView *topView;
@property (nonatomic, strong) KTVPickSongListView *onlineListView;
@property (nonatomic, strong) KTVPickSongListView *pickedListView;
@property (nonatomic, strong) KTVPickSongManager *pickSongManager;

@end

@implementation KTVPickSongComponent

- (instancetype)initWithSuperView:(UIView *)superView roomID:(nonnull NSString *)roomID {
    if (self = [super init]) {
        self.superView = superView;
        self.roomID = roomID;
        
        [self setupView];
        
        [self requestHiFiveSongList];
        [self requestPickedSongList];
    }
    return self;
}

- (void)setupView {
    [self.pickSongView addSubview:self.backView];
    [self.pickSongView addSubview:self.contentView];
    [self.contentView addSubview:self.topView];
    [self.contentView addSubview:self.onlineListView];
    [self.contentView addSubview:self.pickedListView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
    }];
    [self.onlineListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.top.equalTo(self.topView.mas_bottom);
    }];
    [self.pickedListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.onlineListView);
    }];
}

#pragma mark - HTTP
- (void)requestHiFiveSongList {
    __weak typeof(self) weakSelf = self;
    [KTVHiFiveManager requestHiFiveSongListComplete:^(NSArray<KTVSongModel *> * _Nullable list, NSString * _Nullable errorMessage) {

        if (errorMessage) {
            [[ToastComponent shareToastComponent] showWithMessage:errorMessage];
        } else {
            weakSelf.onlineListView.dataArray = list;
            [weakSelf updateUI];
        }
        
    }];
}

- (void)requestPickedSongList {
    __weak typeof(self) weakSelf = self;
    [KTVRTSManager requestPickedSongList:self.roomID block:^(RTSACKModel * _Nonnull model, NSArray<KTVSongModel *> * _Nonnull list) {
        
        weakSelf.pickedListView.dataArray = list;
        [weakSelf syncSongListStstus];
        
        if ([weakSelf.delegate respondsToSelector:@selector(ktvPickSongComponent:pickedSongCountChanged:)]) {
            [weakSelf.delegate ktvPickSongComponent:weakSelf pickedSongCountChanged:list.count];
        }
        [weakSelf updateUI];
    }];
}

#pragma mark - methods
- (void)show {
    [self.superView addSubview:self.pickSongView];
    [self updateUI];
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.bottom = SCREEN_HEIGHT;
    }];
}

- (void)dismissView {
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self.pickSongView removeFromSuperview];
    }];
}

- (void)changedSongListView:(NSInteger)index {
    if (index == 0) {
        self.onlineListView.hidden = NO;
        self.pickedListView.hidden = YES;
    }
    else {
        self.onlineListView.hidden = YES;
        self.pickedListView.hidden = NO;
    }
    
    [self updateUI];
}

- (void)updateUI {
    if (self.pickSongView.superview) {
        
        [self.topView updatePickedSongCount:self.pickedListView.dataArray.count];
        
        if (self.onlineListView.isHidden) {
            [self.pickedListView refreshView];
        }
        else {
            [self.onlineListView refreshView];
        }
    }
}

- (void)refreshDownloadStstus:(KTVSongModel *)model {

    [self updateUI];
}

- (void)syncSongListStstus {
    for (KTVSongModel *model in self.onlineListView.dataArray) {
        model.isPicked = NO;
        for (KTVSongModel *pickedModel in self.pickedListView.dataArray) {
            if ([pickedModel.pickedUserID isEqualToString:[LocalUserComponent userModel].uid] &&
                [pickedModel.musicId isEqualToString:model.musicId]) {
                model.isPicked = YES;
            }
        }
    }
}

- (void)updatePickedSongList {
    [self requestPickedSongList];
}

#pragma mark - getter

- (UIView *)pickSongView {
    if (!_pickSongView) {
        _pickSongView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    }
    return _pickSongView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        [_backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)]];
    }
    return _backView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 360 + 48 + [DeviceInforTool getVirtualHomeHeight])];
        _contentView.backgroundColor = [[UIColor colorFromHexString:@"#0E0825F2"] colorWithAlphaComponent:0.95];
    }
    return _contentView;
}

- (KTVPickSongTopView *)topView {
    if (!_topView) {
        _topView = [[KTVPickSongTopView alloc] init];
        __weak typeof(self) weakSelf = self;
        _topView.selectedChangedBlock = ^(NSInteger index) {
            [weakSelf changedSongListView:index];
        };
    }
    return _topView;
}

- (KTVPickSongListView *)onlineListView {
    if (!_onlineListView) {
        _onlineListView = [[KTVPickSongListView alloc] initWithType:KTVSongListViewTypeOnline];
        __weak typeof(self) weakSelf = self;
        _onlineListView.pickSongBlock = ^(KTVSongModel * _Nonnull songModel) {
            [weakSelf.pickSongManager pickSong:songModel];
        };
    }
    return _onlineListView;
}

- (KTVPickSongListView *)pickedListView {
    if (!_pickedListView) {
        _pickedListView = [[KTVPickSongListView alloc] initWithType:KTVSongListViewTypePicked];
        _pickedListView.hidden = YES;
    }
    return _pickedListView;
}

- (KTVPickSongManager *)pickSongManager {
    if (!_pickSongManager) {
        _pickSongManager = [[KTVPickSongManager alloc] initWithRoomID:self.roomID];
        __weak typeof(self) weakSelf = self;
        _pickSongManager.refreshModelBlock = ^(KTVSongModel * _Nonnull model) {
            [weakSelf refreshDownloadStstus:model];
        };
    }
    return _pickSongManager;
}

@end
