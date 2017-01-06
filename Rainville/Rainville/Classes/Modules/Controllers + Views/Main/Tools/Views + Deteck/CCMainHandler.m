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

#import "UIView+CCExtension.h"

#ifndef __OPTMIZE__
static BOOL _isFontRegistSuccess = NO;
#endif

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
        if (block) {
            block(isHeadphoneInsert , nil);
        }
    });
    return isHeadphoneInsert;
}

+ (BOOL) ccIsMuteEnabledWithHandler : (CCCommonBlock) block {
    BOOL isMuteEnabled = NO;
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_0
#warning TODO >>> 检测 7.0 以上静音 .
#else
    CFStringRef state;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute,
                            &propertySize,
                            &state);
    isMuteEnabled = CFStringGetLength(state) == 0 ;
#endif
    _CC_Safe_Async_Block(^{
        if (block) {
            block(isMuteEnabled , nil);
        }
    });
    return isMuteEnabled;
}

#pragma mark - System

#ifndef __OPTMIZE__
+ (void)load {
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *stringFamilyName in [UIFont familyNames]) {
        if ([stringFamilyName containsString:@"Mus"] || [stringFamilyName containsString:@"cons"]) {
            [array addObject:stringFamilyName];
        }
    }
    _isFontRegistSuccess = array.count == 3;
}
#endif

#pragma mark - Views
+ (UIScrollView *) ccCreateMainBottomScrollViewWithView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                              0,
                                                                             _CC_ScreenWidth(),
                                                                             _CC_ScreenHeight() * 0.3f)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.bouncesZoom = NO;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor clearColor] ;
    scrollView.contentSize = CGSizeMake(_CC_ScreenWidth() * 3, scrollView.height);
    
    return scrollView;
}

+ (UITableView *) ccCreateContentTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           _CC_ScreenWidth(),
                                                                           _CC_ScreenHeight())
                                                          style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.alwaysBounceVertical = YES;
    tableView.backgroundColor = [UIColor clearColor];
    
    return tableView;
}

+ (UITableView *) ccCreateMainTableViewWithScrollView : (UIScrollView *) scrollView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           _CC_ScreenWidth(),
                                                                           scrollView.height)
                                                          style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorColor = _CC_HexColor(0x434D5B);
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.bounces = NO;
    [tableView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    return tableView;
}

@end
