//
//  MQRainList.h
//  Rainville_Module
//
//  Created by 冯明庆 on 2020/6/17.
//

#import <UIKit/UIKit.h>
#import "MQViewsCommon.h"

NS_ASSUME_NONNULL_BEGIN

@class MQRainList;
@protocol MQRainListDelegate <NSObject>

- (void) mq_rainlist : (MQRainList *) rl
         posted_data : (NSDictionary *) item;

@end

@interface MQRainList : UIView

+ (instancetype) mq_rainlist;
- (void) mq_anim_inout : (BOOL) bout
                    on : (void(^ _Nullable)(void)) completion;
@property (nonatomic , assign) _Nullable id < MQRainListDelegate > delegate ;

- (void) mq_anim_out;

@end

@interface MQRainCell : UITableViewCell

@property (nonatomic , strong , readonly) UILabel *lb;

@end

NS_ASSUME_NONNULL_END
