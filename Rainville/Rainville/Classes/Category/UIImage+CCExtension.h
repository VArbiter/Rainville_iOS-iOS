//
//  UIImage+CCExtension.h
//  Rainville
//
//  Created by 冯明庆 on 17/1/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CCExtension)

+ (instancetype) ccImageWithName : (NSString *) stringImageName
               withCacheInMemory : (BOOL) isNeedCache ;

@end
