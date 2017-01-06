//
//  CCCountDownView.m
//  Rainville
//
//  Created by 冯明庆 on 17/1/7.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "CCCountDownView.h"

#import "UIView+CCExtension.h"
#import "CCLocalizedHelper.h"
#import "UILabel+CCExtension.h"
#import "UIFont+CCExtension.h"

@interface CCCountDownView () <UIPickerViewDataSource , UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerViewTime;
@property (weak, nonatomic) IBOutlet UILabel *labelLeft;
@property (weak, nonatomic) IBOutlet UILabel *labelRight;

@property (nonatomic , strong) NSArray *arrayData ;

- (void) ccDefaultSettings ;

@end

@implementation CCCountDownView

- (instancetype) initFromNib {
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                          owner:nil
                                        options:nil] firstObject];
    self.frame = CGRectMake(_CC_ScreenWidth(),
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
    [_labelLeft ccMusketWithFontSize:12.0f
                          withString:_CC_SET_CLOSE_TIMER_()];
    [_labelRight ccMusketWithFontSize:12.0f
                           withString:_CC_SET_CLOSE_MINUTES_()];
    
    _pickerViewTime.delegate = self;
    _pickerViewTime.dataSource = self;
    
    _arrayData = @[_CC_CANCEL_() , @"5" , @"10" , @"15" , @"20" , @"25" , @"30" , @"35" , @"40" , @"45" , @"50" , @"55" , @"60" , @"90" , @"120" ];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _arrayData.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _arrayData[row];
}

- (CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return _CC_ScreenHeight() * 0.3f * 0.35f ;
}
- (UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *labelPicker = (UILabel *)view;
    if (!labelPicker) {
        labelPicker = [[UILabel alloc] init];
        labelPicker.font = [UIFont ccMusketFontWithSize:11.0f];
        [labelPicker setTextAlignment:NSTextAlignmentCenter];
        labelPicker.backgroundColor = [UIColor clearColor];
        labelPicker.textColor = _CC_HexColor(0xFEFEFE);
    }
    labelPicker.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return labelPicker;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}


_CC_DETECT_DEALLOC_

@end
