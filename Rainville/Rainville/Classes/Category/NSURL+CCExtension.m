//
//  NSURL+CCExtension.m
//  Rainville
//
//  Created by 冯明庆 on 17/1/1.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "NSURL+CCExtension.h"

@implementation NSURL (CCExtension)

+ (instancetype) ccURL : (NSString *) string
            withIsFile : (BOOL) isFile {
    return isFile ? [self fileURLWithPath:string] : [self URLWithString:string];
}

@end
