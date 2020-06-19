//
//  MQProgress.h
//  Rainville_Module
//
//  Created by 冯明庆 on 2020/6/17.
//

#import <UIKit/UIKit.h>
#import "MQViewsCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface MQProgress : UIView

- (void) mq_draw_with : (float) f_pgs; // 0 ~ 1

@end

@interface MQProgress_Loading : UIView

+ (instancetype) mq_loading ;
- (void) mq_selfify_anim : (BOOL) begin ;

@end

NS_ASSUME_NONNULL_END
