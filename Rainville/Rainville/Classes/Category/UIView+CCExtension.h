//
//  UIView+CCExtension.h
//  Rainville
//
//  Created by 冯明庆 on 17/1/2.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CCExtension)

@property (nonatomic , assign) CGFloat left;
@property (nonatomic , assign) CGFloat top;
@property (nonatomic , assign) CGFloat right;
@property (nonatomic , assign) CGFloat bottom;

@property (nonatomic , assign) CGFloat x;
@property (nonatomic , assign) CGFloat y;

@property (nonatomic , assign) CGFloat width;
@property (nonatomic , assign) CGFloat height;

@property (nonatomic , assign) CGFloat centerX;
@property (nonatomic , assign) CGFloat centerY;

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

@end
