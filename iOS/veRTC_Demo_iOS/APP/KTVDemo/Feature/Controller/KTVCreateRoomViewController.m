//
//  CreateRoomViewController.m
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/18.
//  Copyright © 2021 . All rights reserved.
//

#import "KTVCreateRoomViewController.h"
#import "KTVRoomViewController.h"
#import "KTVCreateRoomTipView.h"
#import "KTVSelectBgView.h"

@interface KTVCreateRoomViewController ()

@property (nonatomic, strong) KTVCreateRoomTipView *tipView;
@property (nonatomic, strong) UILabel *roomTitleLabel;
@property (nonatomic, strong) UILabel *roomNameLabel;

@property (nonatomic, strong) UILabel *bgTitleLabel;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) KTVSelectBgView *selectBgView;
@property (nonatomic, strong) UIButton *joinButton;
@property (nonatomic, copy) NSString *bgImageName;

@end

@implementation KTVCreateRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHexString:@"#272E3B"];
    [self addSubviewAndConstraints];
    self.bgImageView.image = [UIImage imageNamed:[self.selectBgView getDefaults]];
    _bgImageName = [self.selectBgView getDefaults];
    
    __weak __typeof(self) wself = self;
    self.selectBgView.clickBlock = ^(NSString * _Nonnull imageName,
                                     NSString * _Nonnull smallImageName) {
        wself.bgImageView.image = [UIImage imageNamed:imageName];
        wself.bgImageName = imageName;
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navTitle = @"";
    [self.leftButton setImage:[UIImage imageNamed:@"voice_cancel" bundleName:HomeBundleName] forState:UIControlStateNormal];
}

- (void)joinButtonAction:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    __weak __typeof(self) wself = self;
    [KTVRTMManager startLive:self.roomNameLabel.text
                                 userName:[LocalUserComponents userModel].name
                              bgImageName:_bgImageName
                                    block:^(NSString * _Nonnull RTCToken,
                                            KTVRoomModel * _Nonnull roomModel,
                                            KTVUserModel * _Nonnull hostUserModel,
                                            RTMACKModel * _Nonnull model) {
        if (model.result) {
            [PublicParameterCompoments share].roomId = roomModel.roomID;
            KTVRoomViewController *next = [[KTVRoomViewController alloc]
                                                 initWithRoomModel:roomModel
                                                 rtcToken:RTCToken
                                                 hostUserModel:hostUserModel];
            [wself.navigationController pushViewController:next animated:YES];
        } else {
            [[ToastComponents shareToastComponents] showWithMessage:model.message];
        }
        sender.userInteractionEnabled = YES;
    }];
}

#pragma mark - Private Action

- (void)addSubviewAndConstraints {
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.leftButton];
    [self.leftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(24);
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self.navView).offset([DeviceInforTool getStatusBarHight]/2);
    }];
    
    [self.view addSubview:self.tipView];
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.top.equalTo(self.leftButton.mas_bottom).offset(8);
    }];
    
    [self.view addSubview:self.roomTitleLabel];
    [self.roomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.equalTo(self.leftButton.mas_bottom).offset(86);
    }];
    
    [self.view addSubview:self.roomNameLabel];
    [self.roomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.roomTitleLabel);
        make.top.equalTo(self.roomTitleLabel.mas_bottom).offset(12);
    }];
    
    [self.view addSubview:self.bgTitleLabel];
    [self.bgTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.roomTitleLabel);
        make.top.equalTo(self.roomNameLabel.mas_bottom).offset(24);
    }];
    
    CGFloat selectBgViewHeight = ((SCREEN_WIDTH - (30 * 2)) - (12 * 2)) / 3;
    [self.view addSubview:self.selectBgView];
    [self.selectBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(selectBgViewHeight);
        make.top.equalTo(self.bgTitleLabel.mas_bottom).offset(12);
    }];
    
    [self.view addSubview:self.joinButton];
    [self.joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(50);
        make.top.equalTo(self.selectBgView.mas_bottom).offset(40);
    }];
}

#pragma mark - getter

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
    }
    return _bgImageView;
}

- (UILabel *)roomTitleLabel {
    if (!_roomTitleLabel) {
        _roomTitleLabel = [[UILabel alloc] init];
        _roomTitleLabel.font = [UIFont systemFontOfSize:16];
        _roomTitleLabel.textColor = [UIColor colorFromHexString:@"#C9CDD4"];
        _roomTitleLabel.text = @"名称";
    }
    return _roomTitleLabel;
}

- (UILabel *)roomNameLabel {
    if (!_roomNameLabel) {
        _roomNameLabel = [[UILabel alloc] init];
        _roomNameLabel.font = [UIFont systemFontOfSize:14];
        _roomNameLabel.textColor = [UIColor colorFromHexString:@"#FFFFFF"];
        _roomNameLabel.text = [NSString stringWithFormat:@"%@的K歌房", [LocalUserComponents userModel].name];
    }
    return _roomNameLabel;
}

- (UILabel *)bgTitleLabel {
    if (!_bgTitleLabel) {
        _bgTitleLabel = [[UILabel alloc] init];
        _bgTitleLabel.font = [UIFont systemFontOfSize:16];
        _bgTitleLabel.textColor = [UIColor colorFromHexString:@"#C9CDD4"];
        _bgTitleLabel.text = @"背景";
    }
    return _bgTitleLabel;
}

- (KTVSelectBgView *)selectBgView {
    if (!_selectBgView) {
        _selectBgView = [[KTVSelectBgView alloc] init];
        _selectBgView.backgroundColor = [UIColor clearColor];
    }
    return _selectBgView;
}

- (UIButton *)joinButton {
    if (!_joinButton) {
        _joinButton = [[UIButton alloc] init];
        [_joinButton setBackgroundImage:[UIImage imageNamed:@"voicechar_join" bundleName:HomeBundleName] forState:UIControlStateNormal];
        [_joinButton setTitle:@"开启KTV" forState:UIControlStateNormal];
        [_joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _joinButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        [_joinButton addTarget:self action:@selector(joinButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _joinButton.layer.cornerRadius = 22;
        _joinButton.layer.masksToBounds = YES;
    }
    return _joinButton;
}

- (KTVCreateRoomTipView *)tipView {
    if (!_tipView) {
        _tipView = [[KTVCreateRoomTipView alloc] init];
        _tipView.message = @"本产品仅用于功能体验，单次直播时长不超20分钟";
    }
    return _tipView;
}


@end
