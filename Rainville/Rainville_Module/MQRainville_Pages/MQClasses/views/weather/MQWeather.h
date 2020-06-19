//
//  MQWeather.h
//  Rainville_Module
//
//  Created by 冯明庆 on 2020/6/15.
//

#import <UIKit/UIKit.h>
#import "MQViewsCommon.h"

NS_ASSUME_NONNULL_BEGIN

@class MQWeather;
@protocol MQWeatherDelegate <NSObject>

- (void) mq_weather_click_playstop : (MQWeather *) wh ;

@end

@interface MQWeather : UIView

+ (instancetype) mq_weather ;

- (void) mq_timer_operate : (BOOL) enable;
@property (nonatomic , assign) CGFloat cur_progress;

- (void) mq_set_icon : (NSString *) key;
- (void) mq_btn_shake_and_disappear ;

- (void) mq_set_data : (NSDictionary *) d ;

@property (nonatomic , assign) id < MQWeatherDelegate > delegate;

@end

NS_ASSUME_NONNULL_END
