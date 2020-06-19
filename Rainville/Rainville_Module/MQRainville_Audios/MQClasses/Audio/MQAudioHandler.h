//
//  MQAudioHandler.h
//  JSONKit
//
//  Created by 冯明庆 on 2020/6/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSNotificationName const AUDIO_STATE_PAUSED_NOTIFICATION;
FOUNDATION_EXPORT NSNotificationName const AUDIO_STATE_PLAYING_NOTIFICATION;

@class MQAudioHandler;

FOUNDATION_EXPORT MQAudioHandler * MQ_AUDIO;

@interface MQAudioHandler : NSObject

+ (instancetype) mq_shared;

- (void) mq_play : (NSArray <NSNumber *> *) volumes
          random : (BOOL) random;
- (void) mq_pause ;
@property (readonly) BOOL playing ;

@end

NS_ASSUME_NONNULL_END
