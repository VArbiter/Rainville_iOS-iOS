//
//  CCAudioHandler.h
//  Rainville
//
//  Created by 冯明庆 on 17/1/3.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVAudioSession;

typedef NS_ENUM(NSInteger , CCPlayOption) {
    CCPlayOptionPlay = 0 ,
    CCPlayOptionPause ,
    CCPlayOptionStop 
};

@interface CCAudioHandler : NSObject

@property (nonatomic , strong) AVAudioSession *audioSession ;

+ (instancetype) sharedAudioHandler ;

- (void) ccSetAudioPlayerWithVolumeArray : (NSArray *) arrayVolume
                     withCompleteHandler : (dispatch_block_t) block ;

- (void) ccPausePlayingWithCompleteHandler : (dispatch_block_t) block
                                withOption : (CCPlayOption) option ;

- (void) ccSetInstantPlayingInfo : (NSString *) stringKey ;

- (void) ccSetAutoStopWithSeconds : (NSInteger) integerSeconds
                        withBlock : (CCCommonBlock) block;

@end
