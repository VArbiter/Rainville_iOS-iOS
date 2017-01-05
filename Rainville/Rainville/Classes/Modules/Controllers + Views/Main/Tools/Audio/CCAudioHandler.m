//
//  CCAudioHandler.m
//  Rainville
//
//  Created by 冯明庆 on 17/1/3.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "CCAudioHandler.h"

#import <AVFoundation/AVFoundation.h>

#import "CCAudioPreset.h"

static CCAudioHandler *_handler = nil;

@interface CCAudioHandler ()

@property (nonatomic , strong) NSMutableArray *arrayPlayer ;

- (void) ccDefaultSettings ;

- (void) ccSetAudioPlayer ;
- (id) ccAudioPlayerSetWithPath : (NSURL *) urlPath ;

//char * ccStringCat(char * char1 , char * char2) ;

@end

@implementation CCAudioHandler

+ (instancetype) sharedAudioHandler {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _handler = [[CCAudioHandler alloc] init];
    });
    return _handler;
}

- (void) ccSetAudioPlayerWithVolumeArray : (NSArray *) arrayVolume
                     withCompleteHandler : (dispatch_block_t) block {
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_async(queue, ^{
        [self ccPausePlayingWithCompleteHandler:nil
                                     withOption:CCPlayOptionStop];
    });
    dispatch_group_t tGroup = dispatch_group_create() ;
    ccWeakSelf;
    for (short i = 0; i < 10; i++) {
        const char * str = [ccStringFormat(@"queue_%d",i) UTF8String];
        dispatch_queue_t tQueue = dispatch_queue_create(str , DISPATCH_QUEUE_PRIORITY_DEFAULT);
        dispatch_group_async(tGroup, tQueue, ^{
            id player = _arrayPlayer[i];
            if ([player isKindOfClass:[AVAudioPlayer class]]) {
                AVAudioPlayer *audioPlayer = (AVAudioPlayer *) player ;
                audioPlayer.volume = [arrayVolume[i] floatValue];
                [pSelf ccPausePlayingWithCompleteHandler:nil
                                              withOption:CCPlayOptionPlay];
            }
        });
    }
    dispatch_group_notify(tGroup, dispatch_get_main_queue(), ^{
        if (block) {
            _CC_Safe_Async_Block(^{
                block();
            });
        }
    });
}

- (void) ccPausePlayingWithCompleteHandler : (dispatch_block_t) block
                                withOption : (CCPlayOption) option {
    for (short i = 0; i < 10; i++) {
        id player = _arrayPlayer[i];
        if ([player isKindOfClass:[AVAudioPlayer class]]) {
            AVAudioPlayer *audioPlayer = (AVAudioPlayer *) player ;
            _CC_Safe_Async_Block(^{
                switch (option) {
                    case CCPlayOptionStop:{
                        [audioPlayer stop];
                    }break;
                    case CCPlayOptionPlay:{
                        [audioPlayer play];
                    }break;
                    case CCPlayOptionPause:{
                        [audioPlayer pause];
                    }
                        
                    default:
                        break;
                }
            });
        }
    }
    if (block) {
        _CC_Safe_Async_Block(^{
            block();
        });
    }
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

- (void) ccSetAudioPlayer {
    _arrayPlayer = [NSMutableArray array];
    NSArray *arrayWavFile = [CCAudioPreset ccAudioFilePath];
    for (short i = 0; i < 10; i++) {
        [_arrayPlayer addObject:[self ccAudioPlayerSetWithPath:arrayWavFile[i]]];
    }
}

- (id) ccAudioPlayerSetWithPath : (NSURL *) urlPath {
    NSError *error ;

    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:urlPath
                                                                   error:&error];
    if (error) {
        CCLog(@"_CC_AUDIO_PLAYER_ERROR_ %@",error);
        return [NSNull null];
    }
    player.volume = 0.0f ;
    player.numberOfLoops = -1 ;
    [player prepareToPlay];
    return player;
}
/*
char * ccStringCat(char * char1 , char * char2) {
    char *charResult = malloc(strlen(char1) + strlen(char2) + 1);
    if (charResult == NULL) return "";
    strcpy(charResult, char1);
    strcat(charResult, char2);
    return charResult;
}
*/
#pragma mark - System

- (instancetype)init {
    if ((self = [super init])) {
        [self ccDefaultSettings];
        [self ccSetAudioPlayer];
    }
    return self ;
}

_CC_DETECT_DEALLOC_

@end
