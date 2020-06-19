//
//  SceneDelegate.m
//  Rainville
//
//  Created by 冯明庆 on 2020/6/12.
//  Copyright © 2020 MQ. All rights reserved.
//

#import "MQSceneDelegate.h"
#import "Rainville_Module/MQHomeController.h"

@interface MQSceneDelegate ()

@end

@implementation MQSceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    if (@available(iOS 13.0 ,*)) {
        UIWindowScene *sc = (UIWindowScene *) scene;
        UIWindow *w = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [w setWindowScene:sc];
        
        MQHomeController *c = [[MQHomeController alloc] init];
        [w setRootViewController:c];
        [w makeKeyAndVisible];
        
        self.window = w;
    }
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    
}


- (void)sceneWillResignActive:(UIScene *)scene {
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
}


@end
