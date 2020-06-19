//
//  UIFont+MQRainville.h
//  Rainville_Module
//
//  Created by 冯明庆 on 2020/6/15.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <MQExtensionKit/MQExtensionKit.h>
#import "Rainville_Module/MQDefines.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSNotificationName HEADER_LANG_SWITCHED_NOTIFICATION;

// 使用字体均已获得非商业用途授权
UIFont * mq_en_font_with(float) ;
UIFont * mq_zh_hans_font_with(float) ;
UIFont * mq_icon_with(float) ;

@interface MQButton : UIControl

@property (nonatomic , strong , readonly) UILabel *label;

@end

NS_ASSUME_NONNULL_END
