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

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#define _CC_AUTO_ 1
#else
#define _CC_AUTO_ 0
#endif

typedef NS_ENUM(NSInteger , CCTimerType) {
    CCTimerTypeFade = 0 ,
    CCTimerTypeAutoStop
};

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

@property (nonatomic , strong) CADisplayLink *displayLink;
- (void) ccFadeWithVolume : (CGFloat) volume
               withPlayer : (AVAudioPlayer *) audioPlayer ;
- (dispatch_source_t) ccInitialTimer : (CGFloat) floatTimeSep
                            withType : (CCTimerType) type ;
- (void) ccAudioFadeAction : (CADisplayLink *) dispalyLink ;

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
    _CC_Safe_Async_Block(block , ^{
        block();
    });
}

- (void) ccPausePlayingWithCompleteHandler : (dispatch_block_t) block
                                withOption : (CCPlayOption) option {
    dispatch_group_t tGroup = dispatch_group_create() ;
    for (short i = 0; i < 10; i++) {
        id player = _arrayPlayer[i];
        if ([player isKindOfClass:[AVAudioPlayer class]]) {
            AVAudioPlayer *audioPlayer = (AVAudioPlayer *) player ;
            if (audioPlayer.volume <= 0.0f) continue;
            const char * c = ccStringFormat(@"queue_Group_%d",i).UTF8String;
            dispatch_queue_t tQueue = dispatch_queue_create(c , DISPATCH_QUEUE_CONCURRENT);
            dispatch_group_async(tGroup, tQueue, ^{
                switch (option) {
                    case CCPlayOptionPlay:{
                        [audioPlayer play];
                    }break;
                    case CCPlayOptionPause:{
                        [audioPlayer pause];
                    }break;
                    case CCPlayOptionStop:{
                        [audioPlayer stop];
                    }break;
                        
                    default:
                        break;
                }
            });
        }
    }
    dispatch_group_notify(tGroup, dispatch_get_main_queue(), ^{
        _CC_Safe_Async_Block(block , ^{
            block();
        });
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
        _CC_Safe_Async_Block(block , ^{
            block(YES , @"00 : 00");
        });
        return ;
    }
    _integerCountTime = integerSeconds;
    _block = [block copy];
    
//    ccWeakSelf;
    _timer = [self ccInitialTimer:1.0f
                         withType:CCTimerTypeAutoStop];
    /*
    __block dispatch_group_t group = dispatch_group_create(); // 若有 , 保持队列同步 .
    dispatch_group_enter(group);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0f * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        [pSelf ccTimerAction:group];
    });
    dispatch_resume(_timer);
     */
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
    _CC_Safe_Async_Block(_block , ^{
        pSelf.block(isStop , [pSelf ccFormatteTime:pSelf.integerCountTime]);
    });
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

- (void) ccFadeWithVolume : (CGFloat) volume
               withPlayer : (AVAudioPlayer *) audioPlayer {
#if _CC_AUTO_
//    [audioPlayer setVolume:volume
//              fadeDuration:.3f];
#else
//    [self ccInitialTimer:.01f
//                withType:CCTimerTypeFade];
#endif
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self
                                                             selector:@selector(ccAudioFadeAction:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                        forMode:NSRunLoopCommonModes];
    self.displayLink = displayLink;
}

- (void) ccAudioFadeAction : (CADisplayLink *) dispalyLink {
    
}

- (dispatch_source_t) ccInitialTimer : (CGFloat) floatTimeSep
                            withType : (CCTimerType) type {
    ccWeakSelf;
    __block dispatch_group_t group = dispatch_group_create(); // 若有 , 保持队列同步 .
    dispatch_group_enter(group);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), floatTimeSep * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        switch (type) {
            case CCTimerTypeFade:{
#warning TODO >>>
                /*
                    如果 , 使用音量递减的方式 , 那么volume为1.0的AudioPlayer 将会在1秒后暂停/结束 .
                    但是如果不使用 , 那么音频的淡入淡出在10.0下如何实现 ?
                 */
            }break;
            case CCTimerTypeAutoStop:{
                [pSelf ccTimerAction:group];
            }break;
                
            default:
                break;
        }
    });
    dispatch_resume(timer);
    return timer;
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
