//
//  UIColor+CCExtension.h
//  Rainville
//
//  Created by 冯明庆 on 17/1/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CCExtension)
/// Format as 16 . eg:0x000000 , Alpha 0.0f~1.0f
+ (instancetype) ccHexColor : (int) intHex ;

+ (instancetype) ccHexColor : (int) intHex
             withFloatAlpha : (CGFloat) floatAlpha ;

@end
