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
    
    return YES;
}

@end
