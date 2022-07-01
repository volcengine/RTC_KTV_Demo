//
//  KTVMusicEndView.h
//  veRTC_Demo
//
//  Created by bytedance on 2022/1/20.
//  Copyright © 2022 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTVSongModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KTVMusicEndView : UIView

- (void)showWithModel:(KTVSongModel *)songModel
                score:(NSInteger)score
                block:(void (^)(BOOL result))block;

@end

NS_ASSUME_NONNULL_END
