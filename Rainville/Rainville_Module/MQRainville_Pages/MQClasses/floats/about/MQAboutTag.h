//
//  MQAboutTag.h
//  Rainville_Module
//
//  Created by 冯明庆 on 2020/6/17.
//

#import <UIKit/UIKit.h>
#import "MQViewsCommon.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MQAboutTagDelegate <NSObject>

- (void) mq_opening_github ;
- (void) mq_sending_email ;

@end

@interface MQAboutTag : UIView

+ (instancetype) mq_about ;
- (void) mq_anim_inout : (BOOL) bout
                    on : (void(^ _Nullable)(void)) completion;
- (void) mq_anim_out;
@property (nonatomic , assign) _Nullable id < MQAboutTagDelegate > delegate ;

@end

NS_ASSUME_NONNULL_END
