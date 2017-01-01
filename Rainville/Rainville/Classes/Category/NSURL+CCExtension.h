//
//  NSURL+CCExtension.h
//  Rainville
//
//  Created by 冯明庆 on 17/1/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (CCExtension)

+ (instancetype) ccURL : (NSString *) string
            withIsFile : (BOOL) isFile ;

@end
