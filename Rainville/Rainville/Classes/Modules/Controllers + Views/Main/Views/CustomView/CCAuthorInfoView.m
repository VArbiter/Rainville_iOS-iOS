//
//  CCAuthorInfoView.m
//  Rainville
//
//  Created by 冯明庆 on 17/1/7.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "CCAuthorInfoView.h"

#import "CCLocalizedHelper.h"
#import "UILabel+CCExtension.h"
#import "UIFont+CCExtension.h"

@interface CCAuthorInfoView ()
@property (weak, nonatomic) IBOutlet UILabel *labelAppName;
@property (weak, nonatomic) IBOutlet UILabel *labelVersion;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;

@property (weak, nonatomic) IBOutlet UIButton *buttonLink;
- (IBAction)ccButtonLinkAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonEmail;
- (IBAction)ccButtonActionEmail:(UIButton *)sender;

- (void) ccDefaultSettings ;
- (NSString *) ccGetVersionString ;
- (void) ccRotateImageView ;

@end

@implementation CCAuthorInfoView

- (instancetype) initFromNib {
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                          owner:nil
                                        options:nil] firstObject];
    self.frame = CGRectMake(_CC_ScreenWidth() * 2,
                            0,
                            _CC_ScreenWidth(),
                            _CC_ScreenHeight() * 0.3f);
    if (self) {
        [self ccDefaultSettings];
    }
    return self;
}
#pragma mark - Private 
- (void) ccDefaultSettings {
    _buttonEmail.titleLabel.font = [UIFont ccMusketFontWithSize:12.0f];
    _buttonLink.titleLabel.font = [UIFont ccMusketFontWithSize:12.0f];
    [_labelAppName ccMusketWithFontSize:12.0f
                             withString:_CC_APP_NAME_()];
    [_labelVersion ccMusketWithFontSize:12.0f
                             withString:[self ccGetVersionString]];
}

- (NSString *) ccGetVersionString {
    NSDictionary *dictionaryInfo = [[NSBundle mainBundle] infoDictionary];
    return ccStringFormat(@"%@: %@ (%@)",_CC_VERSION_(),
                                      dictionaryInfo[@"CFBundleShortVersionString"],
                                      dictionaryInfo[@"CFBundleVersion"]);
}

- (void) ccRotateImageView {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @0.0f;
    animation.toValue = @(M_PI * 2.0f);
    animation.duration  = 0.8f;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = 1;
    [_imageViewIcon.layer addAnimation:animation
                                forKey:nil];
}

#pragma mark - Outlet
- (IBAction)ccButtonActionEmail:(UIButton *)sender {

}
- (IBAction)ccButtonLinkAction:(UIButton *)sender {
    NSURL *urlLink = _CC_URL(@"https://github.com/VArbiter", NO);
    if ([[UIApplication sharedApplication] canOpenURL:urlLink]) {
        [[UIApplication sharedApplication] openURL:urlLink];
    }
}

#pragma mark - System

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touchFocus = [touches anyObject];
    CGPoint pointFocus = [touchFocus locationInView:self];
    if (CGRectContainsPoint(_imageViewIcon.frame, pointFocus)) {
        [self ccRotateImageView];
    }
}

_CC_DETECT_DEALLOC_

@end
