//
//  CCAppDelegate.m
//  Rainville
//
//  Created by 冯明庆 on 16/12/12.
//  Copyright © 2016年 冯明庆. All rights reserved.
//

#import "CCAppDelegate.h"

#import "CCMainViewController.h"

@implementation CCAppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    _window.rootViewController = [[CCMainViewController alloc] initWithNibName:NSStringFromClass([CCMainViewController class])
                                                                        bundle:[NSBundle mainBundle]];
    [_window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type != UIEventTypeRemoteControl) return;
    NSInteger integerOrder = -1;
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPause: integerOrder = UIEventSubtypeRemoteControlPause ; break;
        case UIEventSubtypeRemoteControlPlay: integerOrder = UIEventSubtypeRemoteControlPlay ; break;
        case UIEventSubtypeRemoteControlNextTrack: integerOrder = UIEventSubtypeRemoteControlNextTrack ; break;
        case UIEventSubtypeRemoteControlPreviousTrack: integerOrder = UIEventSubtypeRemoteControlPreviousTrack ; break;
        case UIEventSubtypeRemoteControlTogglePlayPause: integerOrder = UIEventSubtypeRemoteControlTogglePlayPause ; break;
            
        default: integerOrder = -1 ; break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:_CC_APP_DID_RECEIVE_REMOTE_NOTIFICATION_
                                                        object:nil
                                                      userInfo:@{@"key" : @(integerOrder)}];
}

- (void) applicationWillResignActive:(UIApplication *)application {
    
}

@end
