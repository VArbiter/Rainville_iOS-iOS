//
//  MQDefines.h
//  JSONKit
//
//  Created by 冯明庆 on 2020/6/15.
//

#import <Foundation/Foundation.h>
#import <MQExtensionKit/MQExtensionKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSNotificationName const TIMER_STOPPED_NOTIFICATION;
FOUNDATION_EXPORT NSNotificationName const TIMER_COUNTDOWN_ENDS_NOTIFICATION;

typedef NSString * RainvilleKey_UserDefault;

FOUNDATION_EXPORT RainvilleKey_UserDefault const rainville_user_lang_settings;

typedef NSString * RainvilleKey_JSON;
FOUNDATION_EXPORT RainvilleKey_JSON const rainville_zh_hans;
FOUNDATION_EXPORT RainvilleKey_JSON const rainville_en;

FOUNDATION_EXPORT NSDictionary * RAINVILLE_TOTAL;

FOUNDATION_EXPORT NSDictionary * RAINVILLE_DISPLAY_ZH_HANS;
FOUNDATION_EXPORT NSDictionary * RAINVILLE_DISPLAY_EN;

FOUNDATION_EXPORT NSArray * RAINVILLE_DATA_VOLUMES;
FOUNDATION_EXPORT NSArray * RAINVILLE_TIMERS;
FOUNDATION_EXPORT NSDictionary * RAINVILLE_ICONS_KEYMAP;

id mq_res_for_bundle(NSString * res_name ,
                     NSString * res_type ,
                     NSString * bundle_name);

typedef int RainvilleCSS;
FOUNDATION_EXPORT RainvilleCSS css_color_main;
FOUNDATION_EXPORT RainvilleCSS css_color_main_white;
FOUNDATION_EXPORT RainvilleCSS css_color_icon_inner;
FOUNDATION_EXPORT RainvilleCSS css_color_text_black;
FOUNDATION_EXPORT RainvilleCSS css_color_text_white;

FOUNDATION_EXPORT RainvilleCSS css_size_text_default;
FOUNDATION_EXPORT RainvilleCSS css_size_text_large;
FOUNDATION_EXPORT RainvilleCSS css_size_text_medium;
FOUNDATION_EXPORT RainvilleCSS css_size_text_small;

@interface MQDefines : NSObject

@end

NS_ASSUME_NONNULL_END
