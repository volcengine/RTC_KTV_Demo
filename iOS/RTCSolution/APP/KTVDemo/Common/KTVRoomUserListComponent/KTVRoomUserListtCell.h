// 
// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT
// 

#import <UIKit/UIKit.h>

@class KTVRoomUserListtCell;

NS_ASSUME_NONNULL_BEGIN

@protocol KTVRoomUserListtCellDelegate <NSObject>

- (void)KTVRoomUserListtCell:(KTVRoomUserListtCell *)KTVRoomUserListtCell clickButton:(id)model;

@end

@interface KTVRoomUserListtCell : UITableViewCell

@property (nonatomic, strong) KTVUserModel *model;

@property (nonatomic, weak) id<KTVRoomUserListtCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
