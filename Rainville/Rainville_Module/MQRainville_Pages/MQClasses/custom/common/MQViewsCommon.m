//
//  UIFont+MQRainville.m
//  Rainville_Module
//
//  Created by 冯明庆 on 2020/6/15.
//

#import "MQViewsCommon.h"

NSNotificationName HEADER_LANG_SWITCHED_NOTIFICATION = @"mq_header_lang_switched";

UIFont * mq_en_font_with(float sz) {
    UIFont *f = [UIFont fontWithName:@"American Fox" size:sz];
    return f ? f : [UIFont systemFontOfSize:sz];
}
UIFont * mq_zh_hans_font_with(float sz) {
    // ... 安装字体名称就是这个 , 是 "方圆准圆体" 😂😂😂
    UIFont *f = [UIFont fontWithName:@"????????®" size:sz];
    return f ? f : [UIFont systemFontOfSize:sz];
}
UIFont * mq_icon_with(float sz) {
    UIFont *f = [UIFont fontWithName:@"iconfont" size:sz];
    return f ? f : [UIFont systemFontOfSize:sz];
}

#pragma mark - --

@interface MQButton ()

@property (nonatomic , strong , readwrite) UILabel *label;
- (void) prepare ;

@end

@implementation MQButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepare];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void) prepare {
    self.label = [[UILabel alloc] init];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self insertSubview:self.label belowSubview:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    __weak typeof(self) weak_self = self;
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.width.height.equalTo(strong_self);
        make.center.equalTo(strong_self);
    }];
}

@end
