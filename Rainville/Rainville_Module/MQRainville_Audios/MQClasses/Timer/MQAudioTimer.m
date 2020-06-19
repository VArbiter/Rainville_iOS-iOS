//
//  MQAudioTimer.m
//  Rainville_Module
//
//  Created by 冯明庆 on 2020/6/15.
//

#import "MQAudioTimer.h"

MQAudioTimer * MQ_TIMER;

@interface MQAudioTimer ()

@property (nonatomic , assign) float time;
@property (nonatomic , assign) float total;
@property (nonatomic , retain) dispatch_source_t timer;
- (void) prepare ;
- (NSString *) mq_format_time : (long) secs;

@end

@implementation MQAudioTimer

+ (void)load {
    MQ_TIMER = [self mq_shared];
}

static MQAudioTimer * __timer = nil;
+ (instancetype)mq_shared {
    if (__timer) return __timer;
    __timer = [[MQAudioTimer alloc] init];
    [__timer prepare];
    return __timer;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (__timer) return __timer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __timer = [super allocWithZone:zone];
    });
    return __timer;
}
- (id)copyWithZone:(NSZone *)zone {
    return __timer;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return __timer;
}

static BOOL __tr_flag = false;
- (void) mq_countdown_for : (NSNumber *) mins {
    if (mins.floatValue == 0) {
        [self mq_stop_timer];
        return;
    }
    self.time = [mins floatValue] * 60;
    self.total = [mins floatValue] * 60;
    __tr_flag = true;
}
- (void) mq_stop_timer {
    self.time = 0;
    self.total = 1;
    __tr_flag = false;
    [[NSNotificationCenter defaultCenter]
    postNotificationName:TIMER_STOPPED_NOTIFICATION object:nil];
}

- (BOOL)timing {
    return __tr_flag;
}

#pragma mark --
- (void)prepare {
    self.time = 0;
    self.total = 1;
    
    // 永远执行定时 , 只是在 time 改变的时候
    // 定时才有计数 ,
    // 为什么这么做 ? 因为我懒 0.0
    
    void (^main_thread)(void(^)(void)) = ^(void(^t)(void)) {
        if ([NSThread isMainThread]) {
            t();
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                t();
            });
        }
    };
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, .1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        if (!__tr_flag) return;
        
        if (self.time <= 0) {
            self.time = 0;
            
            main_thread(^{
                [[NSNotificationCenter defaultCenter]
                postNotificationName:TIMER_COUNTDOWN_ENDS_NOTIFICATION object:nil];
                if (self.delegate
                    && [self.delegate respondsToSelector:@selector(mq_audio_timer_countdown_ends)]) {
                    [self.delegate mq_audio_timer_countdown_ends];
                }
            });
            
            __tr_flag = false;
        }
        else {
            self.time -= 1;
            main_thread(^{
                if (self.delegate
                    && [self.delegate respondsToSelector:@selector(mq_audio_timer_posted_countdown_time:)]) {
                    [self.delegate
                    mq_audio_timer_posted_countdown_time:[self mq_format_time:self.time]];
                }
                
                if (self.delegate
                    && [self.delegate respondsToSelector:@selector(mq_audio_timer_posted_percent:)]) {
                    float fper = self.time / self.total;
                    [self.delegate mq_audio_timer_posted_percent:fper];
                }
            });
        }
    });
    dispatch_resume(self.timer);
}

- (NSString *) mq_format_time : (long) secs {
    long s = secs % 60 ,
         m = (secs / 60) % 60 ,
         h = secs / 3600 ;
    return [NSString stringWithFormat:@"%02ld : %02ld : %02ld" , h , m , s];
}

@end
