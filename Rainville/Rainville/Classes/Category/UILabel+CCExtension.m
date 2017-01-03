//
//  UILabel+CCExtension.m
//  Rainville
//
//  Created by 冯明庆 on 17/1/3.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UILabel+CCExtension.h"

#import "UIFont+CCExtension.h"

static const float _CC_SYSTEM_FONT_SIZE_ = 17.0f;

@implementation UILabel (CCExtension)

- (instancetype) ccMusketWithFontSize : (float) floatSize
                           withString : (NSString *) string  {
    self.font = [UIFont ccMusketFontWithSize:floatSize];
    self.text = string;
    return self;
}

- (instancetype) ccMusketWithString : (NSString *) string {
    return [self ccMusketWithFontSize:_CC_SYSTEM_FONT_SIZE_
                           withString:string];
}

- (instancetype) ccWeatherIconsWithFontSize : (float) floatSize
                                 withString : (NSString *) string {
    self.font = [UIFont ccWeatherIconsWithSize:floatSize];
    self.text = string;
    return self;
}

- (instancetype) ccWeatherIconsWithString : (NSString *) string {
    return [self ccWeatherIconsWithFontSize:_CC_SYSTEM_FONT_SIZE_
                                 withString:string];
}

- (instancetype) ccElegantIconsWithFontSize : (float) floatSize
                                 withString : (NSString *) string {
    self.font = [UIFont ccElegantIconsWithSize:floatSize];
    self.text = string;
    return self;
}

- (instancetype) ccElegantIconsWithString : (NSString *) string {
    return [self ccElegantIconsWithFontSize:_CC_SYSTEM_FONT_SIZE_
                                 withString:string];
}

@end
