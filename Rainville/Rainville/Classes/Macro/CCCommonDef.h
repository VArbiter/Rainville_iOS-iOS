//
//  CCCommonDef.h
//  Rainville
//
//  Created by 冯明庆 on 16/12/12.
//  Copyright © 2016年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef __OPTMIZE__
    #define CCLog(fmt,...) NSLog((@"\n %s \n %s %d \n" fmt),__FILE__,__func__,__LINE__,##__VA_ARGS__)
#else
    #define CCLog(...) /* */
#endif

#define ccWeakSelf __weak typeof(&*self) pSelf = self

#define ccStringFormat(...) [NSString stringWithFormat:__VA_ARGS__]

#define _CC_DETECT_DEALLOC_ \
    - (void)dealloc { \
        CCLog(@"_CC_%@_DEALLOC_" , NSStringFromClass([self class]));\
    }\

typedef void(^CCCommonBlock)(BOOL isSucceed , id item);

@class UIColor;
@class UIImage;

@interface CCCommonDef : NSObject

extern NSString * const _CC_APP_DID_RECEIVE_REMOTE_NOTIFICATION_;

float _CC_ScreenHeight();

float _CC_ScreenWidth();

UIColor * _CC_HexColorWithAlpha(int intValue ,float floatAlpha);

UIColor * _CC_HexColor(int intValue);

UIColor * _CC_RGBColorWithAlpha(float floatR, float floatG , float floatB , float floatA) ;

UIColor * _CC_RGBColor(float floatR, float floatG , float floatB) ;

NSURL * _CC_URL(NSString * string , BOOL isFile) ;

UIImage * _CC_ImageWithCache(NSString * stringImageName , BOOL isNeedCache) ;

UIImage * _CC_Image(NSString * stringImageName) ;

void _CC_Safe_Sync_Block(dispatch_block_t block);

void _CC_Safe_Async_Block(dispatch_block_t block);

@end
