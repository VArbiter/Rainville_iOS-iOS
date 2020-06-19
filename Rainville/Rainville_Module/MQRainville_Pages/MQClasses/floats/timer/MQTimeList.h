//
//  MQTimeList.h
//  Rainville_Module
//
//  Created by 冯明庆 on 2020/6/17.
//

#import <UIKit/UIKit.h>
#import "MQViewsCommon.h"

NS_ASSUME_NONNULL_BEGIN

@class MQTimeList;
@protocol MQTimeListDelegate <NSObject>

- (void) mq_timelist : (MQTimeList *) tl
             on_time : (NSNumber *) time ;

@end

@interface MQTimeList : UIView

+ (instancetype) mq_timelist;
- (void) mq_anim_inout : (BOOL) bout
                    on : (void(^ _Nullable)(void)) completion;

@property (nonatomic , assign) _Nullable id < MQTimeListDelegate > delegate;

- (void) mq_anim_out;

@end

NS_ASSUME_NONNULL_END
