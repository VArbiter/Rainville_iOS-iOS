//
//  UIColor+CCExtension.m
//  Rainville
//
//  Created by 冯明庆 on 17/1/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIColor+CCExtension.h"

@implementation UIColor (CCExtension)

/// Format as 16 . eg:0x000000 , Alpha 0.0f~1.0f
+ (instancetype) ccHexColor : (int) intHex {
    return [self ccHexColor:intHex
             withFloatAlpha:1.0f];
}

+ (instancetype) ccHexColor : (int) intHex
             withFloatAlpha : (CGFloat) floatAlpha{
    return [self colorWithRed: ((CGFloat) ((intHex & 0xFF0000) >> 16)) / 255.0
                        green: ((CGFloat) ((intHex & 0xFF00) >> 8)) / 255.0
                         blue: ((CGFloat) (intHex & 0xFF)) / 255.0
                        alpha: (CGFloat) floatAlpha];
}

@end
