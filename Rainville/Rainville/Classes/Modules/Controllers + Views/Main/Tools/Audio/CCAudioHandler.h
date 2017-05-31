//
//  CCAudioHandler.h
//  Rainville
//
//  Created by 冯明庆 on 31/05/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , CCPlayOption) {
    CCPlayOptionNone = 0 ,
    CCPlayOptionPlay ,
    CCPlayOptionPause
};

@interface CCAudioHandler : NSObject

+ (instancetype) sharedAudioHandler ;

- (void) ccSetAudioPlayerWithVolumeArray : (NSArray *) arrayVolume
                     withCompleteHandler : (dispatch_block_t) block;

- (void) ccPausePlayingWithCompleteHandler : (dispatch_block_t) block
                                withOption : (CCPlayOption) option ;

- (void) ccSetInstantPlayingInfo : (NSString *) stringKey ;

- (void) ccSetAutoStopWithSeconds : (NSInteger) integerSeconds
                        withBlock : (CCCommonBlock) block;

@end
