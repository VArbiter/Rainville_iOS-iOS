//
//  MQAudioTimer.h
//  Rainville_Module
//
//  Created by 冯明庆 on 2020/6/15.
//

#import <Foundation/Foundation.h>
#import "Rainville_Module/MQDefines.h"

NS_ASSUME_NONNULL_BEGIN

@class MQAudioTimer ;
FOUNDATION_EXPORT MQAudioTimer * MQ_TIMER;

@protocol MQAudioTimerDelegate <NSObject>

- (void) mq_audio_timer_posted_countdown_time : (NSString *) str_time ;
- (void) mq_audio_timer_posted_percent : (float) fper ;
- (void) mq_audio_timer_countdown_ends ;

@end

@interface MQAudioTimer : NSObject

+ (instancetype) mq_shared;

- (void) mq_countdown_for : (NSNumber *) mins;
- (void) mq_stop_timer;

@property (nonatomic , assign) id <MQAudioTimerDelegate> delegate ;
@property (readonly) BOOL timing ;

@end

NS_ASSUME_NONNULL_END
