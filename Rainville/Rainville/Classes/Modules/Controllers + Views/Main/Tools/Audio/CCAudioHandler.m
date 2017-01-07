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

@property (nonatomic , strong) dispatch_source_t timer ;
@property (nonatomic , assign) NSInteger integerCountTime ;

@property (nonatomic , copy) CCCommonBlock block;

- (void) ccDefaultSettings ;

- (void) ccSetAudioPlayer ;
- (id) ccAudioPlayerSetWithPath : (NSURL *) urlPath ;
- (void) ccTimerAction : (dispatch_group_t) sender ;
- (NSString *) ccFormatteTime : (NSInteger) integerSeconds ;

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
    ccWeakSelf;
    for (short i = 0; i < 10; i++) {
        id player = pSelf.arrayPlayer[i];
        if ([player isKindOfClass:[AVAudioPlayer class]]) {
            AVAudioPlayer *audioPlayer = (AVAudioPlayer *) player ;
            audioPlayer.volume = [arrayVolume[i] floatValue];
        }
    }
    [pSelf ccPausePlayingWithCompleteHandler:nil
                                  withOption:CCPlayOptionPlay];
    if (block) {
        _CC_Safe_Async_Block(^{
            block();
        });
    }
}

- (void) ccPausePlayingWithCompleteHandler : (dispatch_block_t) block
                                withOption : (CCPlayOption) option {
    dispatch_group_t tGroup = dispatch_group_create() ;
    dispatch_queue_t tQueue = dispatch_queue_create("queue_Group" , DISPATCH_QUEUE_PRIORITY_DEFAULT);
    for (short i = 0; i < 10; i++) {
        id player = _arrayPlayer[i];
        if ([player isKindOfClass:[AVAudioPlayer class]]) {
            AVAudioPlayer *audioPlayer = (AVAudioPlayer *) player ;
            if (audioPlayer.volume <= 0.0f) continue;
            dispatch_group_async(tGroup, tQueue, ^{
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
            });
        }
    }
    dispatch_group_notify(tGroup, dispatch_get_main_queue(), ^{
        if (block) {
            _CC_Safe_Async_Block(^{
                block();
            });
        }
    });
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
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
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
    
    ccWeakSelf;
    __block dispatch_group_t group = dispatch_group_create(); // 若有 , 保持队列同步 .
    dispatch_group_enter(group);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0f * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        [pSelf ccTimerAction:group];
    });
    dispatch_resume(_timer);
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

- (void) ccTimerAction : (dispatch_group_t) sender {
    BOOL isStop = --_integerCountTime <= 0;
    CCLog(@"_CC_COUNT_TIME_REMAIN_%ld",(long)_integerCountTime);
    ccWeakSelf ;
    if (isStop) {
        dispatch_source_set_cancel_handler(_timer, ^{
            [pSelf ccPausePlayingWithCompleteHandler:nil
                                          withOption:CCPlayOptionStop];
            dispatch_group_leave(sender);
        });
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    if (_block) {
        _CC_Safe_Async_Block(^{
            pSelf.block(isStop , [pSelf ccFormatteTime:pSelf.integerCountTime]);
        });
    }
}

- (NSString *) ccFormatteTime : (NSInteger) integerSeconds {
    long fSeconds = integerSeconds % 60 ;
    long fMinutes = (integerSeconds / 60) % 60 ;
    long fHours = integerSeconds / 3600 ;
    if (fHours < 1) {
        return ccStringFormat(@"%02ld : %02ld", fMinutes , fSeconds);
    }
    return ccStringFormat(@"%02ld : %02ld : %02ld",fHours , fMinutes , fSeconds);
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
