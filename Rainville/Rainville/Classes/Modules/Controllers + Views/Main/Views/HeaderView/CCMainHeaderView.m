//
//  CCMainHeaderView.m
//  Rainville
//
//  Created by 冯明庆 on 17/1/3.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "CCMainHeaderView.h"

#import "UIView+CCExtension.h"
#import "UILabel+CCExtension.h"
#import "UIFont+CCExtension.h"
#import "CCLocalizedHelper.h"

@interface CCMainHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *viewBackGround;
@property (weak, nonatomic) IBOutlet UILabel *labelUpDown;
@property (weak, nonatomic) IBOutlet UILabel *labelIcon;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlayPause;
@property (weak, nonatomic) IBOutlet UILabel *labelDesc;
@property (weak, nonatomic) IBOutlet UILabel *labelAppName;
@property (weak, nonatomic) IBOutlet UIView *viewLightLine;

- (IBAction)ccButtonPlayPauseActon:(UIButton *)sender;

- (void) ccInitSubViewSettings ;
- (void) ccSetBackGroundOpaque : (BOOL) isOpaque ;
- (void) ccSetBriefInfoHidden : (BOOL) isHidden ;
- (void) ccShowIcon ;

@end

@implementation CCMainHeaderView

- (instancetype) initFromNib {
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                          owner:nil
                                        options:nil] firstObject];
    self.frame = CGRectMake(0, 0, _CC_ScreenWidth(), _CC_ScreenHeight());
    if (self) {
        [self ccSetUpDownLabel:YES];
        [self ccInitSubViewSettings];
        [self ccShowIcon];
    }
    return self;
}

- (void) ccSetUpDownLabel : (BOOL) isUp {
    [_labelUpDown ccElegantIconsWithFontSize:25.0f
                                  withString:(isUp ? @"6" : @"7")];
    [_labelUpDown sizeToFit];
    
    [self ccSetBackGroundOpaque:!isUp];
    [self ccSetBriefInfoHidden:!isUp];
}

- (void) ccSetBackGroundOpaque : (BOOL) isOpaque {
    ccWeakSelf;
    [UIView animateWithDuration:0.5f animations:^{
        pSelf.viewBackGround.alpha = isOpaque ? 0.65f : 0.95f;
    }];
}

- (void) ccSetBriefInfoHidden : (BOOL) isHidden {
    ccWeakSelf;
    [UIView animateWithDuration:0.5f animations:^{
        pSelf.labelAppName.alpha = isHidden ? 0.0f : 1.0f ;
        pSelf.labelDesc.alpha = isHidden ? 0.0f : 1.0f ;
        pSelf.viewLightLine.alpha = isHidden ? 0.0f : 1.0f ;
    }];
}

#pragma mark - Private (s)

- (void) ccInitSubViewSettings {
    if ([_CC_LANGUAGE_() containsString:@"English"]) {
        [_labelAppName ccMusketWithFontSize:30.0f
                                 withString:_CC_APP_NAME_()];
    } else _labelAppName.text = _CC_APP_NAME_() ;
    [_labelAppName sizeToFit];
    
    [_labelDesc ccMusketWithString:_CC_APP_DESP_()];
    [_labelDesc sizeToFit];
    
    [_labelIcon ccWeatherIconsWithFontSize:70.0f
                                withString:@"\uf006"];
    [_labelIcon sizeToFit];
    
    [_labelCountingDown ccMusketWithFontSize:25.0f
                                  withString:@"00 : 00"];
    _labelCountingDown.hidden = YES;
    
    if ([_CC_LANGUAGE_() containsString:@"English"]) {
        _buttonPlayPause.titleLabel.font = [UIFont ccMusketFontWithSize:15.0f];
    }
    [_buttonPlayPause setTitle:_CC_PLAY_()
                      forState:UIControlStateNormal];
    [_buttonPlayPause setTitle:_CC_STOP_()
                      forState:UIControlStateSelected];

    _buttonPlayPause.width = _labelIcon.width - 20.0f ;
}

- (void) ccShowIcon {
    _labelIcon.alpha = 0.0f;
    ccWeakSelf;
    [UIView  animateWithDuration:1.0f animations:^{
        pSelf.labelIcon.alpha = 1.0f;
    }];
}

- (IBAction)ccButtonPlayPauseActon:(UIButton *)sender {
    sender.selected = !sender.selected ;
    
    [sender setBackgroundColor:_CC_HexColor((sender.selected ? 0x22A1A2 : 0x333333))];
    
    if ([_delegate respondsToSelector:@selector(ccHeaderButtonActionWithPlayOrPause:)]) {
        [_delegate ccHeaderButtonActionWithPlayOrPause:sender.selected];
    }
}

_CC_DETECT_DEALLOC_

@end
