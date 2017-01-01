//
//  CCMainHandler.m
//  Rainville
//
//  Created by 冯明庆 on 17/1/2.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "CCMainHandler.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_0
#import <AVFoundation/AVFoundation.h>
#else
#import <AudioToolbox/AudioToolbox.h>
#endif

#import <UIKit/UIKit.h>

static BOOL _isFontRegistSuccess = NO;

@interface CCMainHandler ()

@end

@implementation CCMainHandler

//获取设备状态，是否插入耳机，如果插入耳机，则返回“YES"
+ (BOOL) ccIsHeadPhoneInsertWithHandler : (CCCommonBlock) block  {
    BOOL isHeadphoneInsert = NO;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_0
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones]) {
            isHeadphoneInsert = YES;
            break ;
        } else isHeadphoneInsert = NO;
    }
#else
    UInt32 propertySize = sizeof(CFStringRef);
    CFStringRef state = nil;
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute
                            ,&propertySize,&state);
    //return @"Headphone" or @"Speaker" and so on.
    isHeadphoneInsert = [(__bridge NSString *)state isEqualToString:@"Headphone"]
                        || [(__bridge NSString *)state isEqualToString:@"HeadsetInOut"]) ;
#endif
    _CC_Safe_Async_Block(^{
        block(isHeadphoneInsert , nil);
    });
    return isHeadphoneInsert;
}

#pragma mark - System

+ (void)load {
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *stringFamilyName in [UIFont familyNames]) {
        if ([stringFamilyName containsString:@"Mus"] || [stringFamilyName containsString:@"cons"]) {
            [array addObject:stringFamilyName];
        }
    }
    _isFontRegistSuccess = array.count == 3;
}

#pragma mark - Views
+ (UIScrollView *) ccCreateMainBottomScrollViewWithView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                             _CC_ScreenHeight() - _CC_ScreenHeight() * 0.3f,
                                                                             _CC_ScreenWidth() * 2,
                                                                             _CC_ScreenHeight() * 0.3f)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.bouncesZoom = NO;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor clearColor] ;
    
    return scrollView;
}

@end
