//
//  CCHintHandler.m
//  Rainville
//
//  Created by 冯明庆 on 17/1/2.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "CCHintHandler.h"

#import "MBProgressHUD.h"

static const float _CC_HINT_DELAY_ = 2.0f ;

@interface CCHintHandler ()

@end

@implementation CCHintHandler

+ (MBProgressHUD * ) ccShowAlertWithTitle : (NSString *) stringTitle
                              withMessage : (NSString *) stringMessage
                       withHideAfterDelay : (float) floatDelay
                      withCompleteHandler : (CCCommonBlock) block {
    __block MBProgressHUD * progressHUD = nil;
    if ([NSThread isMainThread]) {
        progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window
                                           animated:YES];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window
                                               animated:YES];
        });
    }
    progressHUD.label.text = stringTitle;
    progressHUD.detailsLabel.text = stringMessage;
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.userInteractionEnabled = NO;
    [progressHUD hideAnimated:YES afterDelay:floatDelay];
    if (block) {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), ^{
            block(YES , nil);
        });
    }
    
    return progressHUD;
}

+ (MBProgressHUD * ) ccShowAlertWithTitle : (NSString *) stringTitle
                              withMessage : (NSString *) stringMessage {
    return [self ccShowAlertWithTitle:stringTitle
                          withMessage:stringMessage
                   withHideAfterDelay:_CC_HINT_DELAY_
                  withCompleteHandler:nil];
}

+ (MBProgressHUD *) ccShowMessage : (NSString *) stringMessage {
    return [self ccShowAlertWithTitle:nil
                          withMessage:stringMessage];
}

+ (MBProgressHUD *) ccShowTitle : (NSString *) stringTitle {
    return [self ccShowAlertWithTitle:stringTitle
                          withMessage:nil];
}


@end
