//
//  CCLaunchViewController.m
//  Rainville
//
//  Created by 冯明庆 on 17/1/3.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "CCLaunchViewController.h"

#import "CCLocalizedHelper.h"
#import "UILabel+CCExtension.h"

#import <MessageUI/MessageUI.h>

@interface CCLaunchViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelBrief;
@property (weak, nonatomic) IBOutlet UIButton *buttonShortInfo;

- (IBAction)ccButtonActionShortInfo:(UIButton *)sender;

- (void) ccInitViewSettings ;

@end

@implementation CCLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ccInitViewSettings];
    
    [NSThread sleepForTimeInterval:3.0f];
}

- (IBAction)ccButtonActionShortInfo:(UIButton *)sender {
    if (![MFMailComposeViewController canSendMail]) return ;
    MFMailComposeViewController * mailVC = [[MFMailComposeViewController alloc] init];
    [mailVC setToRecipients:@[@"elwinfrederick@163.com"]];
    [self presentViewController:mailVC animated:YES completion:nil];
}

- (void) ccInitViewSettings {
    [_buttonShortInfo.titleLabel ccMusketWithString:[_CC_APP_NAME_() stringByAppendingString:@"_iOS © ElwinFrederick"]];
    [_buttonShortInfo sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

_CC_DETECT_DEALLOC_

@end
