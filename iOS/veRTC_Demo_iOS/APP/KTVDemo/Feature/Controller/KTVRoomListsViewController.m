//
//  KTVRoomViewController.m
//  veRTC_Demo
//
//  Created by on 2021/5/18.
//  
//

#import "KTVRoomListsViewController.h"
#import "KTVCreateRoomViewController.h"
#import "KTVRoomViewController.h"
#import "KTVRoomTableView.h"
#import "KTVHiFiveManager.h"
#import "KTVPickSongManager.h"
#import "KTVRTMManager.h"

@interface KTVRoomListsViewController () <KTVRoomTableViewDelegate>

@property (nonatomic, strong) UIButton *createButton;
@property (nonatomic, strong) KTVRoomTableView *roomTableView;
@property (nonatomic, copy) NSString *currentAppid;

@end

@implementation KTVRoomListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden = NO;
    self.navView.backgroundColor = [UIColor clearColor];
    
    [KTVHiFiveManager registerHiFive];
    
    [self.view addSubview:self.roomTableView];
    [self.roomTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.navView.mas_bottom);
    }];
    
    [self.view addSubview:self.createButton];
    [self.createButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(171, 50));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(- 48 - [DeviceInforTool getVirtualHomeHeight]);
    }];
    
    [self loadDataWithGetLists];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navTitle = @"在线KTV";
    [self.rightButton setImage:[UIImage imageNamed:@"edu_refresh" bundleName:HomeBundleName] forState:UIControlStateNormal];
}

- (void)rightButtonAction:(BaseButton *)sender {
    [super rightButtonAction:sender];
    
    [self loadDataWithGetLists];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

#pragma mark - load data

- (void)loadDataWithGetLists {
    __weak __typeof(self) wself = self;
    
    [KTVRTMManager clearUser:^(RTMACKModel * _Nonnull model) {
        [KTVRTMManager getActiveLiveRoomListWithBlock:^(NSArray<KTVRoomModel *> * _Nonnull roomList, RTMACKModel * _Nonnull model) {
            if (model.result) {
                wself.roomTableView.dataLists = roomList;
            } else {
                wself.roomTableView.dataLists = @[];
                [[ToastComponent shareToastComponent] showWithMessage:model.message];
            }
        }];
    }];
}

#pragma mark - KTVRoomTableViewDelegate

- (void)KTVRoomTableView:(KTVRoomTableView *)KTVRoomTableView didSelectRowAtIndexPath:(KTVRoomModel *)model {
    [PublicParameterComponent share].roomId = model.roomID;
    KTVRoomViewController *next = [[KTVRoomViewController alloc]
                                         initWithRoomModel:model];
    [self.navigationController pushViewController:next animated:YES];
}

#pragma mark - Touch Action

- (void)createButtonAction {
    KTVCreateRoomViewController *next = [[KTVCreateRoomViewController alloc] init];
    [self.navigationController pushViewController:next animated:YES];
}

#pragma mark - getter

- (UIButton *)createButton {
    if (!_createButton) {
        _createButton = [[UIButton alloc] init];
        _createButton.backgroundColor = [UIColor colorFromHexString:@"#4080FF"];
        [_createButton addTarget:self action:@selector(createButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _createButton.layer.cornerRadius = 25;
        _createButton.layer.masksToBounds = YES;
        
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.image = [UIImage imageNamed:@"voice_add" bundleName:HomeBundleName];
        [_createButton addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerY.equalTo(_createButton);
            make.left.mas_equalTo(40);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"创建房间";
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        [_createButton addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_createButton);
            make.left.equalTo(iconImageView.mas_right).offset(8);
        }];
    }
    return _createButton;
}

- (KTVRoomTableView *)roomTableView {
    if (!_roomTableView) {
        _roomTableView = [[KTVRoomTableView alloc] init];
        _roomTableView.delegate = self;
    }
    return _roomTableView;
}

- (void)dealloc {
    [KTVPickSongManager removeLocalMusicFile];
    [PublicParameterComponent clear];
    [[KTVRTCManager shareRtc] disconnect];
}


@end
