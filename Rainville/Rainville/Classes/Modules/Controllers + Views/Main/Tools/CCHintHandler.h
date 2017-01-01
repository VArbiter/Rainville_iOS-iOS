//
//  CCHintHandler.h
//  Rainville
//
//  Created by 冯明庆 on 17/1/2.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBProgressHUD;

@interface CCHintHandler : NSObject

+ (MBProgressHUD * ) ccShowAlertWithTitle : (NSString *) stringTitle
                              withMessage : (NSString *) stringMessage
                       withHideAfterDelay : (float) floatDelay
                      withCompleteHandler : (CCCommonBlock) block ;

+ (MBProgressHUD * ) ccShowAlertWithTitle : (NSString *) stringTitle
                              withMessage : (NSString *) stringMessage;

+ (MBProgressHUD *) ccShowMessage : (NSString *) stringMessage ;

+ (MBProgressHUD *) ccShowTitle : (NSString *) stringTitle ;

@end
