//
//  KTVRoomParamInfoView.m
//  veRTC_Demo
//
//  Created by bytedance on 2021/4/9.
//  Copyright © 2021 . All rights reserved.
//

#import "KTVRoomParamInfoView.h"
#import "UIView+Fillet.h"

@interface KTVRoomParamInfoView ()

@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation KTVRoomParamInfoView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.messageLabel];
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - Publish Action


- (void)setParamInfoModel:(KTVRoomParamInfoModel *)paramInfoModel {
    _paramInfoModel = paramInfoModel;
    
    self.messageLabel.text = [NSString stringWithFormat:@"延迟 %@ms  上行丢包率 %@%%  下行丢包率 %@%%",
                              paramInfoModel.rtt,
                              paramInfoModel.sendLossRate,
                              paramInfoModel.receivedLossRate];
    
}

#pragma mark - Private Action

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = [UIFont systemFontOfSize:12];
        _messageLabel.textColor = [UIColor colorFromHexString:@"#00CF31"];
    }
    return _messageLabel;
}

@end
