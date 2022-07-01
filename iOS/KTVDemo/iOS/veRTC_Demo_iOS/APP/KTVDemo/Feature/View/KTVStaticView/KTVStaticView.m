//
//  KTVStaticView.m
//  veRTC_Demo
//
//  Created by bytedance on 2021/11/29.
//  Copyright © 2021 . All rights reserved.
//

#import "KTVStaticView.h"
#import "KTVPeopleNumView.h"
#import "KTVRoomParamInfoView.h"
#import "KTVRoomModel.h"
#import "KTVRoomParamInfoModel.h"

@interface KTVStaticView ()

@property (nonatomic, strong) UIImageView *bgImageImageView;
@property (nonatomic, strong) UILabel *roomTitleLabel;
@property (nonatomic, strong) KTVRoomParamInfoView *paramInfoView;
@property (nonatomic, strong) KTVPeopleNumView *peopleNumView;

@end

@implementation KTVStaticView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.bgImageImageView];
        [self.bgImageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.peopleNumView];
        [self.peopleNumView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(32);
            make.right.equalTo(self).offset(-16);
            make.top.equalTo(self).offset([DeviceInforTool getStatusBarHight] + 16);
        }];
        
        [self addSubview:self.roomTitleLabel];
        [self.roomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo([DeviceInforTool getStatusBarHight] + 8);
        }];
        
        [self addSubview:self.paramInfoView];
        [self.paramInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(16);
            make.right.equalTo(self);
            make.left.mas_equalTo(16);
            make.top.equalTo(self.roomTitleLabel.mas_bottom).offset(4);
        }];
    }
    return self;
}

#pragma mark - Publish Action

- (void)setRoomModel:(KTVRoomModel *)roomModel {
    _roomModel = roomModel;
    
    self.roomTitleLabel.text = roomModel.roomName;
    NSString *bgImageName = roomModel.extDic[@"background_image_name"];
    self.bgImageImageView.image = [UIImage imageNamed:bgImageName];
    [self.peopleNumView updateTitleLabel:roomModel.audienceCount];
}

- (void)updatePeopleNum:(NSInteger)count {
    [self.peopleNumView updateTitleLabel:count];
}

- (void)updateParamInfoModel:(KTVRoomParamInfoModel *)paramInfoModel {
    self.paramInfoView.paramInfoModel = paramInfoModel;
}

#pragma mark - Getter

- (UIImageView *)bgImageImageView {
    if (!_bgImageImageView) {
        _bgImageImageView = [[UIImageView alloc] init];
        _bgImageImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageImageView.clipsToBounds = YES;
    }
    return _bgImageImageView;
}

- (UILabel *)roomTitleLabel {
    if (!_roomTitleLabel) {
        _roomTitleLabel = [[UILabel alloc] init];
        _roomTitleLabel.textColor = [UIColor whiteColor];
        _roomTitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _roomTitleLabel;
}

- (KTVRoomParamInfoView *)paramInfoView {
    if (!_paramInfoView) {
        _paramInfoView = [[KTVRoomParamInfoView alloc] init];
    }
    return _paramInfoView;
}

- (KTVPeopleNumView *)peopleNumView {
    if (!_peopleNumView) {
        _peopleNumView = [[KTVPeopleNumView alloc] init];
        _peopleNumView.backgroundColor = [UIColor colorFromRGBHexString:@"#000000" andAlpha:0.2 * 255];
        _peopleNumView.layer.cornerRadius = 16;
        _peopleNumView.layer.masksToBounds = YES;
    }
    return _peopleNumView;
}

@end
