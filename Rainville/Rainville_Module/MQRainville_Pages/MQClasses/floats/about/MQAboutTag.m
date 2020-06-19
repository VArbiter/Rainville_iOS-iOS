//
//  MQAboutTag.m
//  Rainville_Module
//
//  Created by 冯明庆 on 2020/6/17.
//

#import "MQAboutTag.h"

@interface MQAboutTag () <UIGestureRecognizerDelegate>

@property (nonatomic , strong) UIView *vw_whe_con; // 白色标签

@property (nonatomic , strong) UIImageView *img_logo;
@property (nonatomic , strong) UIControl *ctl;
@property (nonatomic , strong) UILabel *lb_title;
@property (nonatomic , strong) UILabel *lb_version;
@property (nonatomic , strong) MQButton *btn_github;
@property (nonatomic , strong) MQButton *btn_email;

@property (nonatomic , strong) UILabel *lb_fonts_auth; // 使用字体已获得非商业用途授权
@property (nonatomic , strong) UILabel *lb_fonts;

- (void) prepare ;
- (void) mq_config_text ;
- (void) mq_tap_action : (UITapGestureRecognizer *) tp;
- (void) mq_lang_change : (NSNotification *) nt;

@end

@implementation MQAboutTag

+ (instancetype) mq_about {
    MQAboutTag *t = [[MQAboutTag alloc] init];
    return t;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self prepare];
    }
    return self;
}

- (void) mq_anim_inout : (BOOL) bout
                    on : (void(^_Nullable)(void)) completion {
    __weak typeof(self) weak_self = self;
    if (bout) {
        // 移出
        [UIView animateKeyframesWithDuration:.5f delay:0 options:0 animations:^{
            __strong typeof(weak_self) strong_self = weak_self;
            strong_self.vw_whe_con.alpha = 0;
            strong_self.vw_whe_con.transform = CGAffineTransformMakeTranslation(0, -300);
        } completion:^(BOOL finished) {
            if (completion) completion();
        }];
    } else {
        // 进入
        self.vw_whe_con.transform = CGAffineTransformMakeTranslation(0, -300);
        self.vw_whe_con.alpha = 0;
        [UIView animateKeyframesWithDuration:.5f delay:0 options:0 animations:^{
            __strong typeof(weak_self) strong_self = weak_self;
            strong_self.vw_whe_con.alpha = 1;
            strong_self.vw_whe_con.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
            if (completion) completion();
        }];
    }
}

- (void) mq_anim_out {
    __weak typeof(self) weak_self = self;
    [self mq_anim_inout:YES on:^{
        __strong typeof(weak_self) strong_self = weak_self;
        [strong_self removeFromSuperview];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    __weak typeof(self) weak_self = self;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(UIView.mq_width);
        CGFloat f = UIView.mq_height - mq_fit_navigation_bottom();
        make.height.mas_equalTo(f);
    }];
    
    [self.vw_whe_con mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak typeof(weak_self) strong_self = weak_self;
        make.top.equalTo(strong_self);
        make.right.mas_equalTo(strong_self.mas_right).offset(-MQScaleW(20));
        make.left.mas_equalTo(strong_self.mas_left).offset(MQScaleW(20));
    }];
    
    [self.img_logo mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak typeof(weak_self) strong_self = weak_self;
        make.top.left.equalTo(strong_self.vw_whe_con).offset(MQScaleW(20));
        make.size.mas_equalTo(40);
    }];
    [self.ctl mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak typeof(weak_self) strong_self = weak_self;
        make.size.equalTo(strong_self.img_logo);
        make.center.equalTo(strong_self.img_logo);
    }];
    
    [self.lb_title mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak typeof(weak_self) strong_self = weak_self;
        make.left.mas_equalTo(strong_self.img_logo.mas_right).offset(MQScaleW(20));
        make.centerY.equalTo(strong_self.img_logo);
    }];
    
    [self.lb_version mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak typeof(weak_self) strong_self = weak_self;
        make.top.mas_equalTo(strong_self.img_logo.mas_bottom).offset(MQScaleW(20));
        make.left.equalTo(strong_self.img_logo);
    }];
    
    [self.btn_github mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak typeof(weak_self) strong_self = weak_self;
        make.top.mas_equalTo(strong_self.lb_version.mas_bottom).offset(MQScaleW(10));
        make.left.equalTo(strong_self.lb_version);
    }];
    
    [self.btn_email mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak typeof(weak_self) strong_self = weak_self;
        make.top.mas_equalTo(strong_self.btn_github.mas_bottom).offset(MQScaleW(10));
        make.left.equalTo(strong_self.btn_github);
    }];
    
    [self.lb_fonts_auth mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak typeof(weak_self) strong_self = weak_self;
        make.top.mas_equalTo(strong_self.btn_email.mas_bottom).offset(MQScaleW(10));
        make.left.equalTo(strong_self.btn_email);
        make.right.equalTo(strong_self.vw_whe_con.mas_right).offset(-MQScaleW(20));
    }];
    
    [self.lb_fonts mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak typeof(weak_self) strong_self = weak_self;
        make.top.mas_equalTo(strong_self.lb_fonts_auth.mas_bottom).offset(MQScaleW(10));
        make.left.equalTo(strong_self.lb_fonts_auth);
    }];
    
    [self.lb_fonts mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak typeof(weak_self) strong_self = weak_self;
        make.bottom.equalTo(strong_self.vw_whe_con).offset(-10);
    }];
}

#pragma mark - --

- (void) prepare {
    self.layer.masksToBounds = YES;
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mq_tap_action:)];
    tp.numberOfTapsRequired = 1;
    tp.delegate = self; // 因为 触摸 和 事件有冲突
    [self addGestureRecognizer:tp];
    
    self.vw_whe_con = [[UIView alloc] init];
    self.vw_whe_con.backgroundColor = MQ_COLOR_HEX(css_color_main_white, 1.f);
    [self.vw_whe_con mq_radius:5 masks:false];
    [self mq_add:self.vw_whe_con ];
    
    self.img_logo = [[UIImageView alloc] init];
    NSString *sp = mq_res_for_bundle(@"logo-1024", @"png", @"MQRainville_Pages");
    self.img_logo.image = [UIImage imageWithContentsOfFile:sp];
    [self.vw_whe_con mq_add:self.img_logo ];
    
    self.img_logo.userInteractionEnabled = YES;
    self.ctl = [[UIControl alloc] init];
    self.ctl.userInteractionEnabled = YES;
    [self.vw_whe_con mq_add:self.ctl];
    
    __weak typeof(self) weak_self = self;
    [self.ctl mq_actions:^(UIControl *sender) {
        __strong typeof(weak_self) strong_self = weak_self;
        if ([strong_self.img_logo.layer animationForKey:@"rotation"]) {
            [strong_self.img_logo.layer removeAnimationForKey:@"rotation"];
        }
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        anim.fromValue = @0.0f;
        anim.toValue = @(M_PI * 2.0f);
        anim.duration  = 0.8f;
        anim.autoreverses = false;
        anim.fillMode = kCAFillModeForwards;
        anim.repeatCount = 1;
        anim.removedOnCompletion = true;
        [strong_self.img_logo.layer addAnimation:anim
                                          forKey:@"rotation"];
    }];
    
    self.lb_title = [[UILabel alloc] init];
    self.lb_title.textColor = MQ_COLOR_HEX(css_color_text_black, 1.f);
    [self.vw_whe_con mq_add:self.lb_title ];
    
    self.lb_version = [[UILabel alloc] init];
    self.lb_version.textColor = MQ_COLOR_HEX(css_color_text_black, 1.f);
    [self.vw_whe_con mq_add:self.lb_version ];
    
    self.btn_github = [[MQButton alloc] init];
    self.btn_github.label.textColor = MQ_COLOR_HEX(css_color_text_black, 1.f);
    self.btn_github.label.text = @"GitHub : https://github.com/VArbiter";
    [self.vw_whe_con mq_add:self.btn_github ];
    
    [self.btn_github mq_actions:^(MQButton *sender) {
        __strong typeof(weak_self) strong_self = weak_self;
        if (strong_self.delegate
            && [strong_self.delegate respondsToSelector:@selector(mq_opening_github)]) {
            [strong_self.delegate mq_opening_github];
        }
    }];
    
    self.btn_email = [[MQButton alloc] init];
    self.btn_email.label.textColor = MQ_COLOR_HEX(css_color_text_black, 1.f);
    self.btn_email.label.text = @"E-mail : elwinfrederick@163.com";
    [self.vw_whe_con mq_add:self.btn_email ];
    
    [self.btn_email mq_actions:^(MQButton *sender) {
        __strong typeof(weak_self) strong_self = weak_self;
        if (strong_self.delegate
            && [strong_self.delegate respondsToSelector:@selector(mq_sending_email)]) {
            [strong_self.delegate mq_sending_email];
        }
    }];
    
    self.lb_fonts_auth = [[UILabel alloc] init];
    self.lb_fonts_auth.numberOfLines = 0;
    self.lb_fonts_auth.textColor = MQ_COLOR_HEX(css_color_text_black, 1.f);
    [self.vw_whe_con mq_add:self.lb_fonts_auth ];
    
    self.lb_fonts = [[UILabel alloc] init];
    self.lb_fonts.textColor = MQ_COLOR_HEX(css_color_text_black, 1.f);
    [self.vw_whe_con mq_add:self.lb_fonts ];
    
    [self mq_config_text];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mq_lang_change:)
                                                 name:HEADER_LANG_SWITCHED_NOTIFICATION
                                               object:nil];
}

- (void) mq_config_text {
    NSString *lang = [[NSUserDefaults standardUserDefaults] valueForKey:rainville_user_lang_settings];
    BOOL cn_flag = ![lang containsString:@"en"];
    NSNotification *nt = [[NSNotification alloc] initWithName:HEADER_LANG_SWITCHED_NOTIFICATION
                                                       object:nil
                                                     userInfo:@{@"cn_flag":@(cn_flag)}];
    [self mq_lang_change:nt];
}

- (void) mq_tap_action : (UITapGestureRecognizer *) tp {
    [self mq_anim_out];
}

- (void) mq_lang_change : (NSNotification *) nt {
    __block BOOL cn_flag = [nt.userInfo[@"cn_flag"] boolValue];
    
    NSDictionary *d = (cn_flag ? RAINVILLE_DISPLAY_ZH_HANS : RAINVILLE_DISPLAY_EN);
    
    UIFont *(^fonts)(float) = ^(float f) {
        return (cn_flag ? mq_zh_hans_font_with : mq_en_font_with)(MQScaleW(f));
    };
    
    self.lb_title.font = fonts(css_size_text_large);
    self.lb_version.font = fonts(css_size_text_default);
    self.btn_github.label.font = fonts(css_size_text_default);
    self.btn_email.label.font = fonts(css_size_text_default);
    self.lb_fonts_auth.font = fonts(css_size_text_default);
    self.lb_fonts.font = fonts(css_size_text_default);
    
    self.lb_title.text = d[@"app"][@"app-name"];
    self.lb_version.text = @"".s(d[@"action"][@"version"]).s(@" : ").s([NSBundle mq_app_version]);
    self.lb_fonts_auth.text = cn_flag ? @"声明 : 此 App 所使用字体均已获得非商业授权 ." : @"Statement : All fonts this app used was already obtained non-commercial authorization.";
    
    self.lb_fonts.text = @"".s(cn_flag ? @"字体" : @"Fonts")
                            .s(@" : ").s(@"方圆准圆体 , American Fox");
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([self.img_logo.layer animationForKey:@"rotation"]) {
        [self.img_logo.layer removeAnimationForKey:@"rotation"];
    }
    
    self.delegate = nil;
}

#pragma mark - --

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.vw_whe_con) {
        return false;
    }
    if ([touch.view isKindOfClass:[MQAboutTag class]]) {
        return true;
    }
    return false;
}

@end
