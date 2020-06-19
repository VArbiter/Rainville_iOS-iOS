//
//  MQLaunchController.h
//  Masonry
//
//  Created by 冯明庆 on 2020/6/16.
//

#import <UIKit/UIKit.h>
#import "MQViewsCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface MQLaunch: UIView

+ (instancetype) mq_launch ;
- (void) mq_remove_self_after : (CGFloat) secs;

@end

NS_ASSUME_NONNULL_END
