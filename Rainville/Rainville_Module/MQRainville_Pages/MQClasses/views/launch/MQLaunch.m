//
//  MQLaunchController.m
//  Masonry
//
//  Created by 冯明庆 on 2020/6/16.
//

#import "MQLaunch.h"
#import "MQProgress.h"

@interface MQLaunch ()

@property (nonatomic , strong) UIImageView *img_logo;
@property (nonatomic , strong) UILabel *lb_desp;
@property (nonatomic , strong) UIView *vw_bg;
@property (nonatomic , strong) MQProgress_Loading *ld;

- (void) prepare;
- (void) mq_begin_animation_on : (void(^)(void)) completion ;

@end

@implementation MQLaunch

+ (instancetype) mq_launch {
    MQLaunch *t = [[self alloc] initWithFrame:CGRectFull()];
    return t;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self prepare];
    }
    return self;
}

- (void) mq_remove_self_after : (CGFloat) secs {
    __weak typeof(self) weak_self = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(secs * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weak_self) strong_self = weak_self;
        [strong_self mq_begin_animation_on:^{
            [strong_self removeFromSuperview];
        }];
    });
}

#pragma mark - --

- (void) prepare {
    self.vw_bg = [[UIView alloc] init];
    self.vw_bg.backgroundColor = MQ_COLOR_HEX(css_color_main, 1.f);
    [self mq_add:self.vw_bg];
    
    self.img_logo = [[UIImageView alloc] init];
    NSString *sp = mq_res_for_bundle(@"logo-1024", @"png", @"MQRainville_Pages");
    self.img_logo.image = [UIImage imageWithContentsOfFile:sp];
    [self mq_add:self.img_logo];
    
    NSString *lang = [[NSUserDefaults standardUserDefaults] valueForKey:rainville_user_lang_settings];
    BOOL cn_flag = ![lang containsString:@"en"];
    
    NSString *s = (cn_flag ? RAINVILLE_DISPLAY_ZH_HANS : RAINVILLE_DISPLAY_EN)[@"app"][@"app-description"];
    UIFont *ft = (cn_flag ? mq_zh_hans_font_with : mq_en_font_with)(MQScaleW(css_size_text_default));
    
    self.lb_desp = [[UILabel alloc] init];
    self.lb_desp.text = s;
    self.lb_desp.font = ft;
    self.lb_desp.textColor = MQ_COLOR_HEX(css_color_text_white, 1.f);
    self.lb_desp.textAlignment = NSTextAlignmentCenter;
    [self mq_add:self.lb_desp];
    
    self.ld = [MQProgress_Loading mq_loading];
    [self mq_add:self.ld];
    [self.ld mq_selfify_anim:true];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    __weak typeof(self) weak_self = self;
    [self.vw_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.width.mas_equalTo(UIView.mq_width);
        make.height.mas_equalTo(UIView.mq_height);
        make.center.equalTo(strong_self);
    }];
    
    [self.img_logo mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.width.height.mas_equalTo(120);
        make.centerX.equalTo(strong_self);
        make.centerY.equalTo(strong_self).offset(-MQScaleW(40));
    }];
    
    [self.lb_desp mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.centerX.equalTo(strong_self.img_logo);
        make.width.equalTo(strong_self);
        make.top.mas_equalTo(strong_self.img_logo.mas_bottom).offset(MQScaleW(20));
    }];
    
    [self.ld mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.centerX.equalTo(strong_self);
        CGFloat f = - (mq_fit_safe_area_bottom_height() + MQScaleW(20)) * 2;
        make.bottom.equalTo(strong_self).offset(f);
    }];
    
    [self.vw_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.bottom.equalTo(strong_self);
    }];
}

- (void) mq_begin_animation_on : (void(^)(void)) completion {
    [self.ld mq_selfify_anim:false]; // 移除假的 loading 
    __weak typeof(self) weak_self = self;
    [UIView animateKeyframesWithDuration:.5f delay:0 options:0 animations:^{
        __strong typeof(weak_self) strong_self = weak_self;
        strong_self.transform = CGAffineTransformMakeScale(5, 5);
        strong_self.alpha = 0;
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

@end
