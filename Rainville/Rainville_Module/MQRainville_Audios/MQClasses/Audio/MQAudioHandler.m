//
//  MQAudioHandler.m
//  JSONKit
//
//  Created by 冯明庆 on 2020/6/15.
//

#import "MQAudioHandler.h"
#import "Rainville_Module/MQDefines.h"
#import <AVFoundation/AVFoundation.h>

NSNotificationName const AUDIO_STATE_PAUSED_NOTIFICATION = @"mq_audio_state_paused";
NSNotificationName const AUDIO_STATE_PLAYING_NOTIFICATION = @"mq_audio_state_playing";

MQAudioHandler * MQ_AUDIO;

@interface MQAudioHandler ()

@property (nonatomic , copy) NSArray <AVAudioPlayer *> *audio_players;
- (void) prepare;
@property (nonatomic , copy) NSArray <NSNumber *> *previous;

@end

@implementation MQAudioHandler

+ (void)load {
    MQ_AUDIO = [self mq_shared];
}

static MQAudioHandler *__handler = nil;
+ (instancetype) mq_shared {
    if (__handler) return __handler;
    __handler = [[MQAudioHandler alloc] init];
    return __handler;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (__handler) return __handler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __handler = [super allocWithZone:zone];
    });
    return __handler;
}
- (id)copyWithZone:(NSZone *)zone {
    return __handler;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return __handler;
}

- (instancetype)init {
    if (self = [super init]) {
        [self prepare];
    }
    return self;
}

- (void) mq_play : (NSArray <NSNumber *> *) volumes
          random : (BOOL) random {
    
    NSArray <NSNumber *> *(^g_random)(void) = ^{
        NSMutableArray *a = [NSMutableArray array];
        int i = 0;
        while (i < 10) {
            i ++;
            [a addObject:@(ABS(arc4random() % 11) / 10.f)];
        }
        return a;
    };
    
    if (random) {
        volumes = g_random();
    } else {
        if (!volumes.count) {
            volumes = self.previous;
        }
        if (!volumes.count) { // 如果之前也没有播放的话 (首次播放)
            volumes = g_random();
        }
    }
    
    self.previous = volumes;
    if (!self.audio_players[0].playing) {
        [self.audio_players makeObjectsPerformSelector:@selector(play)];
    }
    
    int i = 0;
    for (AVAudioPlayer *r in self.audio_players) {
        r.volume = [volumes[i] floatValue];
        i++;
    }
    [[NSNotificationCenter defaultCenter]
     postNotificationName:AUDIO_STATE_PLAYING_NOTIFICATION object:nil];
}
- (void) mq_pause {
    if (self.audio_players[0].playing) {
        [self.audio_players makeObjectsPerformSelector:@selector(pause)];
        
        [[NSNotificationCenter defaultCenter]
        postNotificationName:AUDIO_STATE_PAUSED_NOTIFICATION object:nil];
    }
}
- (BOOL)playing {
    return self.audio_players[0].playing;
}

#pragma mark --
- (void)prepare {
    NSMutableArray *a = [NSMutableArray array];
    int i = 0;
    while ( i < 10 ) {
        NSString *s = [NSString stringWithFormat:@"%d",i];
        NSString *p = mq_res_for_bundle(s , @"wav" , @"MQRainville_Audios");
        NSURL *u = [NSURL fileURLWithPath:p relativeToURL:nil];
        
        AVAudioPlayer *r = [[AVAudioPlayer alloc] initWithContentsOfURL:u
                                                                  error:nil];
        r.volume = 0.0f ;
        r.numberOfLoops = -1 ;
        [r prepareToPlay];
        
        if (r) [a addObject:r];
        i++;
    }
    
    self.audio_players = a;
}

@end
