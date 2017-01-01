//
//  UIImage+CCExtension.m
//  Rainville
//
//  Created by 冯明庆 on 17/1/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "UIImage+CCExtension.h"

@implementation UIImage (CCExtension)

+ (instancetype) ccImageWithName : (NSString *) stringImageName
               withCacheInMemory : (BOOL) isNeedCache {
    return isNeedCache ? [self imageNamed:stringImageName] : [self imageWithContentsOfFile:stringImageName];
}

@end
