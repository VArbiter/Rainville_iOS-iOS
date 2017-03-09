//
//  CCHintHandler.m
//  Rainville
//
//  Created by 冯明庆 on 17/1/2.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "CCHintHandler.h"

#import "MBProgressHUD.h"
#import <UIKit/UIKit.h>
#import "CCLocalizedHelper.h"

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

#pragma mark - AlertController

+ (UIAlertController *) ccShowAlertControllerWithTitle : (NSString *) stringTitle
                                           withMessage : (NSString *) stringMessage
                                       withNeedActions : (BOOL) isNeed
                                    withHideAfterDelay : (float) floatDelay
                                   withCompleteHandler : (void(^)(CCClickOption)) block {
    __block UIAlertController *controller = [UIAlertController alertControllerWithTitle:stringTitle
                                                                                message:stringMessage
                                                                         preferredStyle:UIAlertControllerStyleAlert];
    if (isNeed) {
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:_CC_CONFIRM_()
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
            _CC_Safe_Async_Block(block , ^{
                block(CCClickOptionConfirm);
            });
        }];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:_CC_CANCEL_()
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
            _CC_Safe_Async_Block(block , ^{
                block(CCClickOptionCancel);
            });
        }];
        [controller addAction:actionConfirm];
        [controller addAction:actionCancel];
    }
    _CC_Safe_Async_Block(block , ^{
        [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:controller
                                                                                             animated:YES
                                                                                           completion:^{
            if (!isNeed) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                             (int64_t)(floatDelay * NSEC_PER_SEC)),
                               dispatch_get_main_queue(),
                               ^{
                    [controller dismissViewControllerAnimated:YES completion:^{
                        block(CCClickOptionAutoDismiss);
                    }];
                });
            }
        }];
    });
    return controller;
}

+ (UIAlertController *) ccShowAlertControllerWithTitle : (NSString *) stringTitle
                                           withMessage : (NSString *) stringMessage {
    return [self ccShowAlertControllerWithTitle:stringTitle
                                    withMessage:stringMessage
                                withNeedActions:NO
                             withHideAfterDelay:_CC_HINT_DELAY_
                            withCompleteHandler:nil];
}

+ (UIAlertController *) ccShowAlertControllerMessage : (NSString *) stringMessage {
    return [self ccShowAlertControllerWithTitle:nil
                                    withMessage:stringMessage];
}

+ (UIAlertController *) ccShowAlertControllerTitle : (NSString *) stringTitle {
    return [self ccShowAlertControllerWithTitle:stringTitle
                                    withMessage:nil];
}


@end
