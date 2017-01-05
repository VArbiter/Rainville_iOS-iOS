//
//  CCCommonDef.m
//  Rainville
//
//  Created by 冯明庆 on 16/12/12.
//  Copyright © 2016年 冯明庆. All rights reserved.
//

#import "CCCommonDef.h"

#import <UIKit/UIKit.h>

#import "UIColor+CCExtension.h"
#import "NSURL+CCExtension.h"
#import "UIImage+CCExtension.h"

NSString * const _CC_APP_DID_RECEIVE_REMOTE_NOTIFICATION_ = @"CC_APP_DID_RECEIVE_REMOTE_NOTIFICATION";

@interface CCCommonDef ()

void _CC_SAFE_BLOCK(dispatch_block_t block , BOOL isSync);

@end

@implementation CCCommonDef

float _CC_ScreenHeight() {
    return [UIScreen mainScreen].bounds.size.height;
}

float _CC_ScreenWidth() {
    return [UIScreen mainScreen].bounds.size.width;
}

UIColor * _CC_HexColorWithAlpha(int intValue ,float floatAlpha){
    return [UIColor ccHexColor:intValue
                withFloatAlpha:floatAlpha];
}

UIColor * _CC_HexColor(int intValue){
    return _CC_HexColorWithAlpha(intValue, 1.0f);
}

UIColor * _CC_RGBColorWithAlpha(float floatR, float floatG , float floatB , float floatA) {
    return [UIColor colorWithRed:floatR / 255.0f
                           green:floatG / 255.0f
                            blue:floatB / 255.0f
                           alpha:floatA];
}

UIColor * _CC_RGBColor(float floatR, float floatG , float floatB) {
    return _CC_RGBColorWithAlpha(floatR, floatG, floatB, 1.0f);
}

NSURL * _CC_URL(NSString * string , BOOL isFile) {
    return [NSURL ccURL:string
             withIsFile:isFile];
}

UIImage * _CC_ImageWithCache(NSString * stringImageName , BOOL isNeedCache) {
    return [UIImage ccImageWithName:stringImageName
                  withCacheInMemory:isNeedCache];
}

UIImage * _CC_Image(NSString * stringImageName) {
    return _CC_ImageWithCache(stringImageName, YES);
}

void _CC_Safe_Sync_Block(dispatch_block_t block) {
    _CC_SAFE_BLOCK(block, YES);
}

void _CC_Safe_Async_Block(dispatch_block_t block) {
    _CC_SAFE_BLOCK(block, NO);
}

#pragma mark - Private Function (s) && Method (s)

void _CC_SAFE_BLOCK(dispatch_block_t block , BOOL isSync) {
    if (!block) return;
    if ([NSThread isMainThread]) {
        block();
    } else {
        isSync ? dispatch_sync(dispatch_get_main_queue(), block) : dispatch_async(dispatch_get_main_queue(), block) ;
    }
}


@end
