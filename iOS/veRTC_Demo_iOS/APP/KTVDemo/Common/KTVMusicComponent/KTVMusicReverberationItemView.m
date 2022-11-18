//
//  KTVMusicReverberationItemView.m
//  veRTC_Demo
//
//  Created by on 2022/1/19.
//  
//

#import "KTVMusicReverberationItemView.h"

@interface KTVMusicReverberationItemView ()

@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation KTVMusicReverberationItemView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 25;
        self.layer.masksToBounds = YES;
        self.isSelect = NO;
        [self addSubview:self.messageLabel];
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return self;
}

- (void)setMessage:(NSString *)message {
    _message = message;
    self.messageLabel.text = message;
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    
    if (isSelect) {
        self.backgroundColor = [UIColor colorFromRGBHexString:@"#1664FF"];
    } else {
        self.backgroundColor = [UIColor colorFromRGBHexString:@"#FFFFFF" andAlpha:0.1 * 255];
    }
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.font = [UIFont systemFontOfSize:12];
        _messageLabel.userInteractionEnabled = NO;
    }
    return _messageLabel;
}

@end
