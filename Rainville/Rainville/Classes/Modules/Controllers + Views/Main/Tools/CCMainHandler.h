//
//  CCMainHandler.h
//  Rainville
//
//  Created by 冯明庆 on 17/1/2.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIScrollView;
@class UITableView;

@interface CCMainHandler : NSObject

+ (BOOL) ccIsHeadPhoneInsertWithHandler : (CCCommonBlock) block ;

#pragma mark - Views
+ (UIScrollView *) ccCreateMainBottomScrollViewWithView;

@end
