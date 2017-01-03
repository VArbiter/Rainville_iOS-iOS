//
//  CCHintHandler.h
//  Rainville
//
//  Created by 冯明庆 on 17/1/2.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBProgressHUD;
@class UIAlertController;

typedef NS_ENUM(NSInteger , CCClickOption) {
    CCClickOptionConfirm = 0 ,
    CCClickOptionCancel ,
    CCClickOptionAutoDismiss
};

@interface CCHintHandler : NSObject

+ (MBProgressHUD * ) ccShowAlertWithTitle : (NSString *) stringTitle
                              withMessage : (NSString *) stringMessage
                       withHideAfterDelay : (float) floatDelay
                      withCompleteHandler : (CCCommonBlock) block ;

+ (MBProgressHUD * ) ccShowAlertWithTitle : (NSString *) stringTitle
                              withMessage : (NSString *) stringMessage;

+ (MBProgressHUD *) ccShowMessage : (NSString *) stringMessage ;

+ (MBProgressHUD *) ccShowTitle : (NSString *) stringTitle ;

#pragma mark - AlertController

+ (UIAlertController *) ccShowAlertControllerWithTitle : (NSString *) stringTitle
                                           withMessage : (NSString *) stringMessage
                                       withNeedActions : (BOOL) isNeed 
                                    withHideAfterDelay : (float) floatDelay // <=0 Can not disapper by its self .
                                   withCompleteHandler : (void(^)(CCClickOption)) block ;

+ (UIAlertController *) ccShowAlertControllerWithTitle : (NSString *) stringTitle
                                           withMessage : (NSString *) stringMessage;

+ (UIAlertController *) ccShowAlertControllerMessage : (NSString *) stringMessage ;

+ (UIAlertController *) ccShowAlertControllerTitle : (NSString *) stringTitle ;

@end
