//
//  CCLocalizedHelper.m
//  Rainville
//
//  Created by 冯明庆 on 17/1/2.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "CCLocalizedHelper.h"

@implementation CCLocalizedHelper

NSString * _CC_LANGUAGE_() {
    return NSLocalizedString(@"_CC_LANGUAGE_", nil);
}
NSString * _CC_APP_NAME_() {
    return NSLocalizedString(@"_CC_APP_NAME_", nil);
}
NSString * _CC_APP_DESP_() {
    return NSLocalizedString(@"_CC_APP_DESP_", nil);
}

NSString * _CC_RAIN_POEM_() {
    return NSLocalizedString(@"_CC_RAIN_POEM_", nil);
}

NSString * _CC_PLAY_() {
    return NSLocalizedString(@"_CC_PLAY_", nil);
}
NSString * _CC_STOP_() {
    return NSLocalizedString(@"_CC_STOP_", nil);
}
NSString * _CC_CONFIRM_() {
    return NSLocalizedString(@"_CC_CONFIRM_", nil);
}
NSString * _CC_CANCEL_() {
    return NSLocalizedString(@"_CC_CANCEL_", nil);
}
NSString * _CC_SET_CLOSE_TIMER_() {
    return NSLocalizedString(@"_CC_SET_CLOSE_TIMER_", nil);
}
NSString * _CC_SET_CLOSE_MINUTES_() {
    return NSLocalizedString(@"_CC_SET_CLOSE_MINUTES_", nil);
}

NSString * _CC_HINT_KEEP_RUNNING_() {
    return NSLocalizedString(@"_CC_HINT_KEEP_RUNNING_", nil);
}
NSString * _CC_HINT_HEADPHONE_() {
    return NSLocalizedString(@"_CC_HINT_HEADPHONE_", nil);
}
NSString * _CC_HINT_FOCUS_PLAY_REMAIN_() {
    return NSLocalizedString(@"_CC_HINT_FOCUS_PLAY_REMAIN_", nil);
}
NSString * _CC_HINT_PLAY_WITH_SPEAKER_() {
    return NSLocalizedString(@"_CC_HINT_PLAY_WITH_SPEAKER_", nil);
}
NSString * _CC_HINT_WELCOME_USE_RAINVILLE_() {
    return NSLocalizedString(@"_CC_HINT_WELCOME_USE_RAINVILLE_", nil);
}
NSString * _CC_HINT_USE_RAINVILLE_SUMMARY_() {
    return NSLocalizedString(@"_CC_HINT_USE_RAINVILLE_SUMMARY_", nil);
}
NSString * _CC_HINT_PANEL_INTRO_() {
    return NSLocalizedString(@"_CC_HINT_PANEL_INTRO_", nil);
}
NSString * _CC_HINT_PANEL_INTRO_SUMMARY_() {
    return NSLocalizedString(@"_CC_HINT_PANEL_INTRO_SUMMARY_", nil);
}

NSString * _CC_VERSION_() {
    return NSLocalizedString(@"_CC_VERSION_", nil);
}

NSArray * _CC_ARRAY_ITEM_() {
    NSString * stringFileName = [_CC_LANGUAGE_() isEqualToString:@"简体中文"] ? @"ArrayItem_CH" : @"ArrayItem_EN" ;
    NSString * stringFilePath = [[NSBundle mainBundle] pathForResource:stringFileName
                                                                ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:stringFilePath];
}

@end
