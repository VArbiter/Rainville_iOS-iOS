//
//  AppDelegate.m
//  Rainville
//
//  Created by 冯明庆 on 2020/6/12.
//  Copyright © 2020 MQ. All rights reserved.
//

#import "MQAppDelegate.h"
#import "Rainville_Module/MQHomeController.h"

@interface MQAppDelegate ()

@end

@implementation MQAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (@available(iOS 13.0 , *)) {
        
    } else {
        UIWindow *w = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        MQHomeController *c = [[MQHomeController alloc] init];
        [w setRootViewController:c];
        [w makeKeyAndVisible];
        
        self.window = w;
    }
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {

}


@end
