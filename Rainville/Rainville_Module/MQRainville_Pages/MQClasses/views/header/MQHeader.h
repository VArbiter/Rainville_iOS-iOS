//
//  MQHeader.h
//  Rainville_Module
//
//  Created by 冯明庆 on 2020/6/15.
//

#import <UIKit/UIKit.h>
#import "MQViewsCommon.h"

NS_ASSUME_NONNULL_BEGIN

@class MQHeader;
@protocol MQHeaderDelegate <NSObject>

- (void) mq_header : (MQHeader *) h
  toggle_time_list : (BOOL) b;

- (void) mq_header : (MQHeader *) h
  toggle_play_list : (BOOL) b;

- (void) mq_header : (MQHeader *) h
 toggle_about_page : (BOOL) b;

- (void) mq_header : (MQHeader *) h
   stop_time_click : (BOOL) b;

@end

@interface MQHeader : UIView

+ (instancetype) mq_header;

- (void) mq_set_time : (NSString *) s;
- (void) mq_its_a_rainy_day : (NSString *) swhr ; // 下雨时候显示笑脸

@property (nonatomic , assign) id <MQHeaderDelegate> delegate ;

@end

NS_ASSUME_NONNULL_END
