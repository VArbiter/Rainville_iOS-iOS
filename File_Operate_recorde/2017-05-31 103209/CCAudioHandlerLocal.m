//
//  CCAudioHandlerLocal.m
//  Rainville
//
//  Created by 冯明庆 on 26/05/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import "CCAudioHandlerLocal.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CCAudioPreset.h"

#import "CCLocalizedHelper.h"

static CCAudioHandlerLocal *_handler = nil;

@interface CCAudioHandlerLocal ()

@property (nonatomic , strong) NSOperationQueue *operationQueue ;
@property (nonatomic , strong) CADisplayLink *displayLink ;
@property (nonatomic , strong) dispatch_source_t timer ;

@property (nonatomic , assign) NSInteger integerCountTime ;

@property (nonatomic , strong) NSArray *arrayVolume;
@property (nonatomic , strong) NSMutableArray *arrayAudioPlayer ;
@property (nonatomic , strong) NSMutableArray *arrayVolumeFrameValue;

@property (nonatomic , assign) CCPlayOption option;
@property (nonatomic , copy) dispatch_block_t block;

- (void) ccDisplayAction : (CADisplayLink *) sender ;

- (void) ccPlay ;
- (void) ccPause ;

- (CADisplayLink *) ccDisplayLink ;
- (void) ccInvalidateDisplayLink ;

- (void) ccActionLoopAudio : (NSNotification *) sender ;

- (NSString *) ccFormatteTime : (NSInteger) integerSeconds ;

@end

static NSInteger _integerDisplayCount = 0 ;

@implementation CCAudioHandlerLocal

+ (instancetype) sharedAudioHandlerLocal {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _handler = [[CCAudioHandlerLocal alloc] init];
    });
    return _handler;
}

- (void) ccSetAudioPlayerWithVolumeArray : (NSArray *) arrayVolume
                     withCompleteHandler : (dispatch_block_t) block {
    self.arrayVolume = arrayVolume;
    
    NSMutableArray *arraySilent = [NSMutableArray array];
    for (short i = 0; i < 10; i++) {
        CGFloat floatVolume = [arrayVolume[i] floatValue];
        [arraySilent addObject:@((floatVolume / 30.f))];
    }
    self.arrayVolumeFrameValue = arraySilent;
    [self ccPausePlayingWithCompleteHandler:block
                                 withOption:CCPlayOptionPlay];
}

- (void) ccPausePlayingWithCompleteHandler : (dispatch_block_t) block
                                withOption : (CCPlayOption) option {
    self.option = option;
    self.block = [block copy];
    
    dispatch_block_t blockTemp = ^{
        _CC_Safe_Async_Block(block, ^{
            block();
        });
    };
    
    [self ccInvalidateDisplayLink];
    
    switch (option) {
        case CCPlayOptionNone:{
            if (blockTemp) blockTemp();
        }break;
        case CCPlayOptionPlay:{
            [self ccPlay];
        }break;
        case CCPlayOptionPause:{
            [self ccPause];
        }break;
            
        default:{
            if (blockTemp) blockTemp();
        }break;
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
                        withBlock : (CCCommonBlock) block{
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    if (integerSeconds == 0) {
        self.integerCountTime = 0;
        _CC_Safe_Async_Block(block , ^{
            block(YES , @"00 : 00");
        });
        if (self.timer) {
            dispatch_source_cancel(self.timer);
        }
        return ;
    }
    self.integerCountTime = /*integerSeconds*/10;
    
    ccWeakSelf ;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 1.f * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        BOOL isStop = -- pSelf.integerCountTime <= 0 ;
        CCLog(@"_CC_COUNT_TIME_REMAIN_%ld",(long)pSelf.integerCountTime);
        if (isStop) {
            pSelf.option = CCPlayOptionPause;
            [pSelf ccPause];
            dispatch_source_cancel(pSelf.timer);
            dispatch_source_set_cancel_handler(self.timer, ^{
                _CC_Safe_Async_Block(block , ^{
                    block(YES , @"00 : 00");
                });
                pSelf.timer = nil;
            });
        }
        _CC_Safe_Async_Block(block , ^{
            block(isStop , [pSelf ccFormatteTime:pSelf.integerCountTime]);
        });
    });
    dispatch_resume(self.timer);
}

#pragma mark - Private

- (void) ccPlay  {
    id audioPlayer = self.arrayAudioPlayer.firstObject;
    if ([audioPlayer isKindOfClass:[AVPlayer class]]) {
        AVPlayer *player = (AVPlayer *) audioPlayer;
        if (player.rate == 1.f) {
            for (short i = 0 ; i < self.arrayAudioPlayer.count ; i ++) {
                id tempPlayer = self.arrayAudioPlayer[i];
                if ([tempPlayer isKindOfClass:[AVPlayer class]]) {
                    AVPlayer *playerTemp = (AVPlayer *)tempPlayer;
                    playerTemp.volume = [self.arrayVolume[i] floatValue];
                }
            }
            ccWeakSelf;
            _CC_Safe_Async_Block(self.block, ^{
                pSelf.block();
            });
            return ;
        }
    }
    [self ccInvalidateDisplayLink];
    [self ccDisplayLink];
}
- (void) ccPause {
    _integerDisplayCount = 0;
    [self ccInvalidateDisplayLink];
    [self ccDisplayLink];
}

- (void) ccDisplayAction : (CADisplayLink *) sender {
    if (_integerDisplayCount > 30 || _integerDisplayCount <= 0) {
        [self ccInvalidateDisplayLink];
        if (self.option == CCPlayOptionPause) {
            for (AVPlayer *player in self.arrayAudioPlayer) {
                if ([player respondsToSelector:@selector(pause)])
                    [player pause];
            }
            ccWeakSelf;
            _CC_Safe_Async_Block(self.block, ^{
                pSelf.block();
            });
            return ;
        }
    }
    
    ccWeakSelf;
    void (^blockChangeVolume)(CGFloat floatVolume , BOOL isAscending , id player) = ^(CGFloat floatVolume , BOOL isAscending , id player) {
        [pSelf.operationQueue addOperationWithBlock:^{
            if ([player isKindOfClass:[AVPlayer class]]) {
                AVPlayer *audioPlayer = (AVPlayer *) player ;
                if (isAscending) {
                    if (audioPlayer.rate != 1.0f) {
                        [audioPlayer play];
                    }
                    audioPlayer.volume += floatVolume;
                }
                else
                    audioPlayer.volume -= floatVolume;
                NSLog(@"%lf",audioPlayer.volume);
            }
        }];
    };
    
    switch (self.option) {
        case CCPlayOptionNone:{
            [self ccInvalidateDisplayLink];
            return;
        }break;
        case CCPlayOptionPlay:{
            ++ _integerDisplayCount;
            for (short i = 0; i < self.arrayAudioPlayer.count; i ++)
                if (blockChangeVolume)
                    blockChangeVolume([self.arrayVolumeFrameValue[i] floatValue] , YES , self.arrayAudioPlayer[i]);
        }break;
        case CCPlayOptionPause:{
            --_integerCountTime;
            for (short i = 0; i < self.arrayAudioPlayer.count; i ++)
                if (blockChangeVolume)
                    blockChangeVolume([self.arrayVolumeFrameValue[i] floatValue] , false , self.arrayAudioPlayer[i]);
        }break;
            
        default:{
            [self ccInvalidateDisplayLink];
            return;
        }break;
    }
}
- (CADisplayLink *) ccDisplayLink {
    [self ccInvalidateDisplayLink];
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self
                                                             selector:@selector(ccDisplayAction:)];
    displayLink.frameInterval = 2; // 30fps
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                      forMode:NSRunLoopCommonModes];
    self.displayLink = displayLink;
    return displayLink;
}
- (void) ccInvalidateDisplayLink {
    if (!self.displayLink) return ;
    self.displayLink.paused = YES;
    [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop]
                                forMode:NSRunLoopCommonModes];
    [self.displayLink invalidate];
    self.displayLink = nil;
    _integerDisplayCount = 0;
}

- (void) ccActionLoopAudio : (NSNotification *) sender {
    AVPlayerItem *item = [sender object];
    [item seekToTime:kCMTimeZero];
    [self.operationQueue addOperationWithBlock:^{
        for (id player in self.arrayAudioPlayer) {
            if ([player isKindOfClass:[AVPlayer class]]) {
                AVPlayer *audioPlayer = (AVPlayer *) player;
                if (audioPlayer.currentItem == item) {
                    [audioPlayer play];
                    return;
                }
            }
        }
    }];
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

#pragma mark - Getter
- (NSMutableArray *)arrayAudioPlayer {
    if (_arrayAudioPlayer) return _arrayAudioPlayer;
    _arrayAudioPlayer = [NSMutableArray array];
    NSArray *arrayWavFile = [CCAudioPreset ccAudioFilePath];
    self.operationQueue.maxConcurrentOperationCount = arrayWavFile.count;
    
    for (NSURL *url in arrayWavFile) {
        AVAsset *asset = [AVURLAsset URLAssetWithURL:url
                                             options:nil];
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:asset];
        AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:item];
        [_arrayAudioPlayer addObject:player];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(ccActionLoopAudio:)
                                                name:AVPlayerItemDidPlayToEndTimeNotification
                                              object:nil];
    return _arrayAudioPlayer;
}

- (NSOperationQueue *)operationQueue {
    if (_operationQueue) return _operationQueue;
    _operationQueue = [[NSOperationQueue alloc] init]; // 异步 , 并发 , 后台执行
    return _operationQueue;
}

@end
