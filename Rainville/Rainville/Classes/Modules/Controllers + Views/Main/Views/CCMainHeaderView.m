//
//  CCMainHeaderView.m
//  Rainville
//
//  Created by 冯明庆 on 17/1/3.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "CCMainHeaderView.h"

#import "UILabel+CCExtension.h"

@interface CCMainHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *labelUpDown;
@property (weak, nonatomic) IBOutlet UIView *viewBackGround;

- (void) ccSetBackGroundOpaque : (BOOL) isOpaque ;

@end

@implementation CCMainHeaderView

- (instancetype) initFromNib {
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                          owner:nil
                                        options:nil] firstObject];
    self.frame = CGRectMake(0, 0, _CC_ScreenWidth(), _CC_ScreenHeight());
    if (self) {
        [self ccSetUpDownLabel:YES];
    }
    return self;
}

- (void) ccSetUpDownLabel : (BOOL) isUp {
    [_labelUpDown ccElegantIconsWithFontSize:25.0f
                                  withString:(isUp ? @"6" : @"7")];
    [_labelUpDown sizeToFit];
    
    [self ccSetBackGroundOpaque:!isUp];
}

- (void) ccSetBackGroundOpaque : (BOOL) isOpaque {
    ccWeakSelf;
    [UIView animateWithDuration:0.5f animations:^{
        pSelf.viewBackGround.alpha = isOpaque ? 0.65f : 0.95f;
    }];
}



@end
