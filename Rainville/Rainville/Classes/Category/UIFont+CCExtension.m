//
//  UIFont+CCExtension.m
//  Rainville
//
//  Created by 冯明庆 on 17/1/2.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIFont+CCExtension.h"

@implementation UIFont (CCExtension)

+ (instancetype) ccMusketFontWithSize : (float) floatSize {
    return [self fontWithName:@"Musket"
                         size:floatSize];
}

+ (instancetype) ccWeatherIconsWithSize : (float) floatSize {
    return [self fontWithName:@"Weather Icons"
                         size:floatSize];
}

+ (instancetype) ccElegantIconsWithSize : (float) floatSize {
    return [self fontWithName:@"ElegantIcons"
                         size:floatSize];
}

@end
