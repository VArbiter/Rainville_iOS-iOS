//
//  MQRequester.h
//  Rainville_Module
//
//  Created by 冯明庆 on 2020/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MQRequester;
FOUNDATION_EXPORT MQRequester * MQ_REQUESTER;

@protocol MQRequesterDelegate <NSObject>

- (void) mq_requester_receive : (NSDictionary *) data
                         with : (NSError *) e;

@end

@interface MQRequester : NSObject

+ (instancetype) mq_shared;
- (void) mq_begin_request ;
- (void) mq_enable_30min_timer ; // 30 分钟请求一次天气 , 允许误差十分钟
@property (nonatomic , assign) id < MQRequesterDelegate > delegate ;

@end

NS_ASSUME_NONNULL_END
