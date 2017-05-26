//
//  CCAudioHandlerLocal.h
//  Rainville
//
//  Created by 冯明庆 on 26/05/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , CCPlayOption) {
    CCPlayOptionNone = 0 ,
    CCPlayOptionPlay ,
    CCPlayOptionPause 
};

@interface CCAudioHandlerLocal : NSObject

+ (instancetype) sharedAudioHandlerLocal ;

- (void) ccSetAudioPlayerWithVolumeArray : (NSArray *) arrayVolume
                     withCompleteHandler : (dispatch_block_t) block;

- (void) ccPausePlayingWithCompleteHandler : (dispatch_block_t) block
                                withOption : (CCPlayOption) option ;

- (void) ccSetInstantPlayingInfo : (NSString *) stringKey ;

- (void) ccSetAutoStopWithSeconds : (NSInteger) integerSeconds
                        withBlock : (CCCommonBlock) block;

@end
