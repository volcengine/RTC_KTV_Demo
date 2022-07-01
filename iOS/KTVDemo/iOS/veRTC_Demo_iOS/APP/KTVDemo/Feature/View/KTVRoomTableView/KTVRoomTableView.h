//
//  KTVRoomTableView.h
//  veRTC_Demo
//
//  Created by bytedance on 2021/5/18.
//  Copyright © 2021 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTVRoomCell.h"
@class KTVRoomTableView;

NS_ASSUME_NONNULL_BEGIN

@protocol KTVRoomTableViewDelegate <NSObject>

- (void)KTVRoomTableView:(KTVRoomTableView *)KTVRoomTableView didSelectRowAtIndexPath:(KTVRoomModel *)model;

@end

@interface KTVRoomTableView : UIView

@property (nonatomic, copy) NSArray *dataLists;

@property (nonatomic, weak) id<KTVRoomTableViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
