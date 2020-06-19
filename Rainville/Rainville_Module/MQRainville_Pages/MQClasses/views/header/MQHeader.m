//
//  MQHeader.m
//  Rainville_Module
//
//  Created by 冯明庆 on 2020/6/15.
//

#import "MQHeader.h"

@interface MQHeader ()

@property (nonatomic , strong) UILabel *its_rainy_day;
@property (nonatomic , strong) MQButton * btn_countdown;
@property (nonatomic , strong) MQButton * btn_timerlist;
@property (nonatomic , strong) MQButton * btn_rain;
@property (nonatomic , strong) MQButton * btn_about;
@property (nonatomic , strong) MQButton * btn_lang_switch;

@property (nonatomic , copy) NSArray <MQButton *> *btns;
@property (nonatomic , assign) BOOL cn_flag;

- (void) prepare ;

- (void) mq_lang_switch_action : (NSNotification *) nt;
- (void) mq_timer_stop : (NSNotification *) nt;

@end

@implementation MQHeader

+ (instancetype) mq_header {
    CGFloat f = mq_fit_is_has_bangs() ? mq_fit_navigation_bottom() + MQScaleW(10) : mq_fit_navigation_bottom();
    return [[self alloc] initWithFrame:(CGRect){0,0,UIView.mq_width,f}];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self prepare];
    }
    return self;
}

- (void) mq_set_time : (NSString *) s {
    self.btn_countdown.hidden = false;
    self.btn_countdown.label.text = s;
}

- (void) mq_its_a_rainy_day : (NSString *) swhr {
    self.its_rainy_day.hidden = ![swhr isEqualToString:@"yu"];
}

#pragma mark - --
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat rt_offset = -20.f;
    
    __weak typeof(self) weak_self = self;
    [self.btn_lang_switch mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.right.equalTo(strong_self).offset(rt_offset);
        make.bottom.equalTo(strong_self);
        make.height.mas_equalTo(44);
    }];
    
    [self.btn_about mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.right.mas_equalTo(strong_self.btn_lang_switch.mas_left).offset(rt_offset);
        make.bottom.height.equalTo(strong_self.btn_lang_switch);
    }];
    
    [self.btn_rain mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.right.mas_equalTo(strong_self.btn_about.mas_left).offset(rt_offset);;
        make.bottom.height.equalTo(strong_self.btn_about);
    }];
    
    [self.btn_timerlist mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.right.mas_equalTo(strong_self.btn_rain.mas_left).offset(rt_offset);;
        make.bottom.height.equalTo(strong_self.btn_rain);
    }];
    
    [self.btn_countdown mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.right.mas_equalTo(strong_self.btn_timerlist.mas_left).offset(rt_offset);;
        make.bottom.height.equalTo(strong_self.btn_timerlist);
    }];
    
    [self.its_rainy_day mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.left.equalTo(strong_self).offset(-rt_offset);
        make.centerY.equalTo(strong_self.btn_lang_switch);
    }];
}

- (void) prepare {
    
    self.its_rainy_day = [[UILabel alloc] init];
    self.its_rainy_day.font = mq_icon_with(MQScaleW(css_size_text_default));
    self.its_rainy_day.textColor = MQ_COLOR_HEX(css_color_text_white, 1.f);
    self.its_rainy_day.text = RAINVILLE_ICONS_KEYMAP[@"smile"];
    [self mq_add:self.its_rainy_day];
    self.its_rainy_day.hidden = true;
    
    self.btn_countdown = [[MQButton alloc] init];
    self.btn_timerlist = [[MQButton alloc] init];
    self.btn_rain = [[MQButton alloc] init];
    self.btn_about = [[MQButton alloc] init];
    self.btn_lang_switch = [[MQButton alloc] init];
    
    self.btns = @[self.btn_countdown , self.btn_timerlist , self.btn_rain ,
                  self.btn_about , self.btn_lang_switch];
    
    for (MQButton *b in self.btns) {
        b.label.textColor = MQ_COLOR_HEX(css_color_text_white, 1.f);
        b.label.font = mq_zh_hans_font_with(MQScaleW(css_size_text_default));
        if (b == self.btn_lang_switch) {
            b.label.font = mq_icon_with(MQScaleW(css_size_text_default));
        }
        [self mq_add:b];
    }
    
    NSString *lang = [[NSUserDefaults standardUserDefaults] valueForKey:rainville_user_lang_settings];
    self.cn_flag = ![lang containsString:@"en"];
    
    NSNotification *nt = [[NSNotification alloc] initWithName:HEADER_LANG_SWITCHED_NOTIFICATION
                                                       object:nil
                                                     userInfo:@{@"cn_flag":@(self.cn_flag)}];
    [self mq_lang_switch_action:nt];
    
    __weak typeof(self) weak_self = self;
    [self.btn_countdown mq_actions:^(MQButton *sender) {
        __strong typeof(weak_self) strong_self = weak_self;
        if (strong_self.delegate
            && [strong_self.delegate respondsToSelector:@selector(mq_header:stop_time_click:)]) {
            [strong_self.delegate mq_header:strong_self stop_time_click:true];
        }
    }];
    [self.btn_timerlist mq_actions:^(MQButton *sender) {
        __strong typeof(weak_self) strong_self = weak_self;
        if (strong_self.delegate
            && [strong_self.delegate respondsToSelector:@selector(mq_header:toggle_time_list:)]) {
            [strong_self.delegate mq_header:strong_self toggle_time_list:true];
        }
    }];
    [self.btn_rain mq_actions:^(MQButton *sender) {
        __strong typeof(weak_self) strong_self = weak_self;
        if (strong_self.delegate
            && [strong_self.delegate respondsToSelector:@selector(mq_header:toggle_play_list:)]) {
            [strong_self.delegate mq_header:strong_self toggle_play_list:true];
        }
    }];
    [self.btn_lang_switch mq_actions:^(MQButton *sender) {
        __strong typeof(weak_self) strong_self = weak_self;
        strong_self.cn_flag = !strong_self.cn_flag;
        [[NSNotificationCenter defaultCenter] postNotificationName:HEADER_LANG_SWITCHED_NOTIFICATION object:nil userInfo:@{@"cn_flag":@(strong_self.cn_flag)}];
    }];
    
    [self.btn_about mq_actions:^(MQButton *sender) {
        __strong typeof(weak_self) strong_self = weak_self;
        if (strong_self.delegate
            && [strong_self.delegate respondsToSelector:@selector(mq_header:toggle_about_page:)]) {
            [strong_self.delegate mq_header:strong_self toggle_about_page:true];
        }
    }];
    
    NSNotificationCenter *ntc = [NSNotificationCenter defaultCenter];
    [ntc addObserver:self
            selector:@selector(mq_lang_switch_action:)
                name:HEADER_LANG_SWITCHED_NOTIFICATION
              object:nil];
    
    self.btn_countdown.hidden = true;
    [ntc addObserver:self
            selector:@selector(mq_timer_stop:)
                name:TIMER_STOPPED_NOTIFICATION
              object:nil];
    [ntc addObserver:self
            selector:@selector(mq_timer_stop:)
                name:TIMER_COUNTDOWN_ENDS_NOTIFICATION
              object:nil];
}

- (void) mq_lang_switch_action : (NSNotification *) nt {
    BOOL cn_flag = [nt.userInfo[@"cn_flag"] boolValue];
    for (MQButton *b in self.btns) {
        BOOL bl = cn_flag ? (b == self.btn_lang_switch)
        : (b == self.btn_lang_switch || b == self.btn_countdown);
        if (bl) continue;
        b.label.font = (cn_flag ? mq_zh_hans_font_with : mq_en_font_with)(MQScaleW(css_size_text_default));
    }
    
    if (cn_flag) {
        self.btn_timerlist.label.text = @"定时";
        self.btn_rain.label.text = @"雨声";
        self.btn_about.label.text = @"关于";
        self.btn_lang_switch.label.text = RAINVILLE_ICONS_KEYMAP[rainville_en];
    }
    else {
        for (MQButton *b in self.btns) {
            if (b == self.btn_lang_switch || b == self.btn_countdown) continue;
            b.label.font = mq_en_font_with(MQScaleW(css_size_text_default));
        }
        self.btn_timerlist.label.text = @"Timer";
        self.btn_rain.label.text = @"Rain";
        self.btn_about.label.text = @"About";
        self.btn_lang_switch.label.text = RAINVILLE_ICONS_KEYMAP[rainville_zh_hans];
    }
}

- (void) mq_timer_stop : (NSNotification *) nt {
    self.btn_countdown.label.text = @"";
    
    // 延迟是为了让隐藏顺利执行 .
    // 通知同时接收过多 , 界面刷新频繁 , 漏刷 - -
    // 算了 ... 不改了 ...
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btn_countdown.hidden = true;
    });
}

@end
