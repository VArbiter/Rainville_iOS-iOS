//
//  main.m
//  Rainville
//
//  Created by 冯明庆 on 2020/6/12.
//  Copyright © 2020 MQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQAppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        appDelegateClassName = NSStringFromClass([MQAppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
