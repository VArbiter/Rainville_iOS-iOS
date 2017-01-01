//
//  CCCommonDef.h
//  Rainville
//
//  Created by 冯明庆 on 16/12/12.
//  Copyright © 2016年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

/// DEBUG Console output
#ifndef __OPTMIZE__
#define CCLog(fmt,...) NSLog((@"\n %s \n %s %d \n" fmt),__FILE__,__func__,__LINE__,##__VA_ARGS__)
#else
#define CCLog(...) /* */
#endif

#define ccWeakSelf __weak typeof(&*self) pSelf = self

#define ccStringFormat(...) [NSString stringWithFormat:__VA_ARGS__]

#define cc_Sync_SAFE_Block(block)\
    if (!block) return ;\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_sync(dispatch_get_main_queue(), block);\
    }

#define cc_Async_SAFE_Block(block)\
    if (!block) return ;\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }

typedef void(^CCCommonBlock)(BOOL isSucceed , id item);

@class UIColor;
@class UIImage;

@interface CCCommonDef : NSObject

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
