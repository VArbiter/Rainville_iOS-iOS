//
//  CCAudioHandler.m
//  Rainville
//
//  Created by 冯明庆 on 17/1/3.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "CCAudioHandler.h"

#import <AVFoundation/AVFoundation.h>

static CCAudioHandler *_handler = nil;

@interface CCAudioHandler ()

- (void) ccDefaultSettings ;

@end

@implementation CCAudioHandler

+ (instancetype) sharedAudioHandler {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _handler = [[CCAudioHandler alloc] init];
    });
    return _handler;
}

#pragma mark - Private

- (void) ccDefaultSettings {
    NSError *errorAudio ;
    _audioSession = [AVAudioSession sharedInstance];
    [_audioSession setCategory:AVAudioSessionCategoryPlayback
                         error:&errorAudio];
    if (errorAudio) {
        CCLog(@"_CC_AUDIO_ERROR_ %@",errorAudio);
        return ;
    }
}

#pragma mark - System

- (instancetype)init {
    if ((self = [super init])) {
        [self ccDefaultSettings];
    }
    return self ;
}

_CC_DETECT_DEALLOC_

@end
