//
//  MQDefines.m
//  JSONKit
//
//  Created by 冯明庆 on 2020/6/15.
//

#import "MQDefines.h"

NSNotificationName const TIMER_STOPPED_NOTIFICATION = @"mq_timer_stopped";
NSNotificationName const TIMER_COUNTDOWN_ENDS_NOTIFICATION = @"mq_timer_countdown_ends";

RainvilleKey_UserDefault const rainville_user_lang_settings = @"mq_usr_lang_settings";

RainvilleKey_JSON const rainville_zh_hans = @"zh-hans";
RainvilleKey_JSON const rainville_en = @"en";

NSDictionary * RAINVILLE_TOTAL;

NSDictionary * RAINVILLE_DISPLAY_ZH_HANS;
NSDictionary * RAINVILLE_DISPLAY_EN;

NSArray * RAINVILLE_DATA_VOLUMES;
NSArray * RAINVILLE_TIMERS;
NSDictionary * RAINVILLE_ICONS_KEYMAP;

id mq_res_for_bundle( NSString * res_name ,
                      NSString * res_type ,
                      NSString * bundle_name) {
    NSString *fmt = [@"" stringByAppendingFormat:
                     @"Rainville_Module.framework/%@.bundle",
                     bundle_name];
    NSString *p = [[[NSBundle mainBundle] privateFrameworksPath] stringByAppendingPathComponent:fmt];
    NSBundle *b = [NSBundle bundleWithPath:p];
    return [b pathForResource:res_name ofType:res_type];
}

RainvilleCSS css_color_main = 0x272C32;
RainvilleCSS css_color_main_white = 0xD4D5DA;
RainvilleCSS css_color_icon_inner = 0xD4D5DA;
RainvilleCSS css_color_text_black = 0x272C32;
RainvilleCSS css_color_text_white = 0xD4D5DA;

RainvilleCSS css_size_text_default = 28; // 14
RainvilleCSS css_size_text_large = 48; // 24
RainvilleCSS css_size_text_medium = 40; // 20
RainvilleCSS css_size_text_small = 20; // 10

@implementation MQDefines

+ (void)load {
    NSString * p = mq_res_for_bundle(@"rainville_strings", @"json", @"MQRainville_Defines");
    NSData * jd = [NSData dataWithContentsOfFile:p];
    if (jd && jd.length) {
        NSError *e;
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:jd options:NSJSONReadingAllowFragments error:&e];
        if (!e) {
            RAINVILLE_TOTAL = d;
            RAINVILLE_DISPLAY_ZH_HANS = RAINVILLE_TOTAL[@"display"][@"zh-hans"];
            RAINVILLE_DISPLAY_EN = RAINVILLE_TOTAL[@"display"][@"en"];
            RAINVILLE_TIMERS = RAINVILLE_TOTAL[@"timers"];
            RAINVILLE_DATA_VOLUMES = [[RAINVILLE_TOTAL[@"data-volume"] allValues]
                                      sortedArrayUsingComparator:
                                      ^NSComparisonResult(NSDictionary * obj1, NSDictionary * obj2) {
                return [obj1[@"ol"] compare:obj2[@"ol"]] == NSOrderedDescending;
            }];
        }
    }
    RAINVILLE_ICONS_KEYMAP = @{@"smile" : @"\ue752",
                               
                               @"shang" : @"\ue642" , @"xia" : @"\ue643" ,
                               @"en" : @"\ue6c1" , @"zh-hans" : @"\ue6c6" ,
                               
                               @"xue" : @"\ue63c" , @"yin" : @"\ue612" ,
                               @"yun" : @"\ue610" , @"qing" : @"\ue609" ,
                               @"wu" : @"\ue60a" , @"shachen" : @"\ue78c" ,
                               @"lei" : @"\ue78d" , @"yu" : @"\ue78e" ,
                               @"bingbao" : @"\ue667"};
}

@end
