//
//  CCAudioHandler.m
//  Rainville
//
//  Created by 冯明庆 on 17/1/3.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "CCAudioHandler.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CCAudioPreset.h"

#import "CCLocalizedHelper.h"

static CCAudioHandler *_handler = nil;

@interface CCAudioHandler ()

@property (nonatomic , strong) NSMutableArray *arrayPlayer ;
@property (nonatomic , strong) NSTimer *timer ;
@property (nonatomic , assign) NSInteger integerCountTime ;

@property (nonatomic , copy) CCCommonBlock block;

- (void) ccDefaultSettings ;

- (void) ccSetAudioPlayer ;
- (id) ccAudioPlayerSetWithPath : (NSURL *) urlPath ;
- (void) ccTimerAction : (NSTimer *) sender ;

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
                if (![audioPlayer isPlaying]) {
                    [pSelf ccPausePlayingWithCompleteHandler:nil
                                                  withOption:CCPlayOptionPlay];
                }
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

- (void) ccSetInstantPlayingInfo : (NSString *) stringKey {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:stringKey forKey:MPMediaItemPropertyTitle];
    [dictionary setValue:_CC_APP_NAME_() forKey:MPMediaItemPropertyArtist];
    
#warning TODO >>> 
    // 暂时没有理想的封面图
//    MPMediaItemArtwork *artImage = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"ic_Launcher"]];
//    [dictionary setValue:artImage forKey:MPMediaItemPropertyArtwork];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dictionary];
}

- (void) ccSetAutoStopWithSeconds : (NSInteger) integerSeconds
                        withBlock : (CCCommonBlock) block {
    [_timer invalidate];
    _timer = nil;
    if (integerSeconds == 0) {
        _integerCountTime = 0;
        if (block) {
            _CC_Safe_Async_Block(^{
                block(YES , @"00 : 00");
            });
        }
        return ;
    }
    _integerCountTime = integerSeconds;
    _block = [block copy];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                              target:self
                                            selector:@selector(ccTimerAction:)
                                            userInfo:nil
                                             repeats:YES];
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
    
    _integerCountTime = 0;
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

- (void) ccTimerAction : (NSTimer *) sender {
    BOOL isStop = --_integerCountTime <= 0;
    CCLog(@"_CC_COUNT_TIME_REMAIN_%ld",_integerCountTime);
    if (isStop) {
        [_timer invalidate];
        _timer = nil;
        [self ccPausePlayingWithCompleteHandler:nil
                                     withOption:CCPlayOptionStop];
    }
#warning TODO >>> 变成时间样式
    if (_block) {
        ccWeakSelf;
        _CC_Safe_Async_Block(^{
            pSelf.block(isStop , ccStringFormat(@"%ld",pSelf.integerCountTime));
        });
    }
}


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
