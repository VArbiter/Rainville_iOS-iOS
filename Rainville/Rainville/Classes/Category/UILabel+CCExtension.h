//
//  UILabel+CCExtension.h
//  Rainville
//
//  Created by 冯明庆 on 17/1/3.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CCExtension)

- (instancetype) ccMusketWithFontSize : (float) floatSize
                           withString : (NSString *) string ;

- (instancetype) ccMusketWithString : (NSString *) string ;

- (instancetype) ccWeatherIconsWithFontSize : (float) floatSize
                                 withString : (NSString *) string ;

- (instancetype) ccWeatherIconsWithString : (NSString *) string ;

- (instancetype) ccElegantIconsWithFontSize : (float) floatSize
                                 withString : (NSString *) string ;

- (instancetype) ccElegantIconsWithString : (NSString *) string ;

@end
