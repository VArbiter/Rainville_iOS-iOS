//
//  UIPickerView+CCExtension.m
//  Rainville
//
//  Created by 冯明庆 on 17/1/7.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIPickerView+CCExtension.h"
#import "UIView+CCExtension.h"

@implementation UIPickerView (CCExtension)

- (void) ccCyanSeperateLine {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.frame.size.height < 1) {
            if ([obj respondsToSelector:@selector(setBackgroundColor:)]) {
                [obj setBackgroundColor:_CC_HexColor(0x22A1A2)];
            }
            if ([obj respondsToSelector:@selector(setHeight:)]) {
                [obj setHeight:2.0f];
            }
        }
    }];
}

@end
