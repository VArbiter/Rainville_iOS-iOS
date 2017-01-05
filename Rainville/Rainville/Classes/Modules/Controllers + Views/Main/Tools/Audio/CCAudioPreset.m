//
//  CCAudioPreset.m
//  Rainville
//
//  Created by 冯明庆 on 17/1/6.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "CCAudioPreset.h"
#import "CCLocalizedHelper.h"

@implementation CCAudioPreset

+ (NSDictionary *) ccDefaultAudioSet {
    NSArray * _CC_FAIRY_RAIN_ = @[@(.0f),@(.0f),@(.0f),@(.0f),@(.1f),@(.2f),@(.3f),@(.4f),@(.5f),@(.6f)];
    
    NSArray * _CC_BEDROOM_ = @[@(.0f),@(.0f),@(.0f),@(.0f),@(.1f),@(.2f),@(.3f),@(.2f),@(.1f),@(.0f)];
    
    NSArray * _CC_UNDER_THE_PORCH_ = @[@(.0f),@(.3f),@(.25),@(.25f),@(.3f),@(.25f),@(.2f),@(.15f),@(.1f),@(.0f)];
    
    NSArray * _CC_DISTANT_STORM_ = @[@(.7f),@(.6f),@(.5f),@(.4f),@(.3f),@(.2f),@(.2f),@(.3f),@(.2f),@(.1f)];
    
    NSArray * _CC_GETTING_WET_ = @[@(.7f),@(.5f),@(.2f),@(.35f),@(.55f),@(.35f),@(.3f),@(.5f),@(.2f),@(.2f)];
    
    NSArray * _CC_ONLY_RUMBLE_ = @[@(.7f),@(.5f),@(.15f),@(.15f),@(.15f),@(.15f),@(.1f),@(.1f),@(.0f),@(.0f)];
    
    NSArray * _CC_UNDER_THE_LEAVES_ = @[@(.3f),@(.3f),@(.0f),@(.0f),@(.0f),@(.3f),@(.0f),@(.0f),@(.1f),@(.2f)];
    
    NSArray * _CC_DARK_RAIN_ = @[@(.0f),@(.5f),@(.4f),@(.3f),@(.2f),@(.0f),@(.0f),@(.1f),@(.1f),@(.0f)];
    
    NSArray * _CC_JUNGLE_LODGE_ = @[@(.7f),@(.0f),@(.2f),@(.0f),@(.25f),@(.0f),@(.25f),@(.0f),@(.2f),@(.0f)];
    
    
//    NSArray * _CC_BROWN_NOISE_ = @[@(.65f),@(.6f),@(.55f),@(5.0f),@(.45f),@(.4f),@(.35f),@(.3f),@(.25),@(.2f)];
#warning ASK >>> 5f or .5f ?
    NSArray * _CC_BROWN_NOISE_ = @[@(.65f),@(.6f),@(.55f),@(.5f),@(.45f),@(.4f),@(.35f),@(.3f),@(.25),@(.2f)];
    
    NSArray * _CC_PINK_NOISE_ = @[@(.3f),@(.3f),@(.3f),@(.3f),@(.3f),@(.3f),@(.3f),@(.3f),@(.3f),@(.3f)];
    
    NSArray * _CC_WHITE_NOISE_ = @[@(.2f),@(.25f),@(.3f),@(.35f),@(.4f),@(.45f),@(.5f),@(.55f),@(.6f),@(.65f)];
    
    NSArray * _CC_GREY_NOISE_ = @[@(.5f),@(.45f),@(.4f),@(.3f),@(.3f),@(.3f),@(.25f),@(.25f),@(.3f),@(.35f)];
    
    
    NSArray * _CC_60_HZ_ = @[@(.4f),@(.5f),@(.4f),@(.0f),@(.0f),@(.0f),@(.0f),@(.0f),@(.0f),@(.0f)];
    
    NSArray * _CC_125_HZ_ = @[@(.0f),@(.4f),@(.5f),@(.4f),@(.0f),@(.0f),@(.0f),@(.0f),@(.0f),@(.0f)];
    
    NSArray * _CC_250_HZ_ = @[@(.0f),@(.0f),@(.4f),@(.5f),@(.4f),@(.0f),@(.0f),@(.0f),@(.0f),@(.0f)];
    
    NSArray * _CC_500_HZ_ = @[@(.0f),@(.0f),@(.0f),@(.4f),@(.5f),@(.4f),@(.0f),@(.0f),@(.0f),@(.0f)];
    
    NSArray * _CC_1K_HZ_ = @[@(.0f),@(.0f),@(.0f),@(.0f),@(.4f),@(.5f),@(.4f),@(.0f),@(.0f),@(.0f)];
    
    NSArray * _CC_2K_HZ_ = @[@(.0f),@(.0f),@(.0f),@(.0f),@(.0f),@(.4f),@(.5f),@(.4f),@(.0f),@(.0f)];
    
    NSArray * _CC_4K_HZ_ = @[@(.0f),@(.0f),@(.0f),@(.0f),@(.0f),@(.0f),@(.4f),@(.5f),@(.4f),@(.0f)];
    
    NSArray * _CC_8K_HZ_ = @[@(.0f),@(.0f),@(.0f),@(.0f),@(.0f),@(.0f),@(.0f),@(.4f),@(.5f),@(.6f)];
    
    
    NSArray * _CC_DEFAULT_PRESET_ = _CC_PINK_NOISE_;
    
    NSArray *array = _CC_ARRAY_ITEM_();
    NSDictionary *dictionary = @{array[0] : _CC_DEFAULT_PRESET_,
                                 array[1] : _CC_FAIRY_RAIN_,
                                 array[2] : _CC_BEDROOM_,
                                 array[3] : _CC_UNDER_THE_PORCH_,
                                 array[4] : _CC_DISTANT_STORM_,
                                 array[5] : _CC_GETTING_WET_,
                                 array[6] : _CC_ONLY_RUMBLE_,
                                 array[7] : _CC_UNDER_THE_LEAVES_,
                                 array[8] : _CC_DARK_RAIN_,
                                 array[9] : _CC_JUNGLE_LODGE_,
                                 array[10] : _CC_BROWN_NOISE_,
                                 array[11] : _CC_PINK_NOISE_,
                                 array[12] : _CC_WHITE_NOISE_,
                                 array[13] : _CC_GREY_NOISE_,
                                 array[14] : _CC_60_HZ_,
                                 array[15] : _CC_125_HZ_,
                                 array[16] : _CC_250_HZ_,
                                 array[17] : _CC_500_HZ_,
                                 array[18] : _CC_1K_HZ_,
                                 array[19] : _CC_2K_HZ_,
                                 array[20] : _CC_4K_HZ_,
                                 array[21] : _CC_8K_HZ_};
    return dictionary;
}

+ (NSArray *) ccAudioFilePath {
    NSMutableArray *array = [NSMutableArray array];
    for (short i = 0; i < 10; i++) {
        NSString *stringPath = [[NSBundle mainBundle] pathForResource:ccStringFormat(@"_%d",i) ofType:@"wav"];
        [array addObject:_CC_URL(stringPath, YES)];
    }
    return array;
}

@end
