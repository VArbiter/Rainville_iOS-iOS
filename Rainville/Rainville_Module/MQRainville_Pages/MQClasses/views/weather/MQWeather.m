//
//  MQWeather.m
//  Rainville_Module
//
//  Created by 冯明庆 on 2020/6/15.
//

#import "MQWeather.h"
#import "MQProgress.h"

@interface MQWeather ()

@property (nonatomic , strong) MQButton *btn_icon;
@property (nonatomic , strong) UILabel *lb_wthr;
@property (nonatomic , strong) UILabel *lb_loc;
@property (nonatomic , strong) MQProgress *vw_pgs;

@property (nonatomic , strong) UILabel *lb_play_stop;

@property (nonatomic , copy) NSArray <UILabel *> *lb_infos;

@property (nonatomic , copy) NSDictionary *data;
@property (nonatomic , copy) NSArray <NSString *> *infos;

- (void) prepare ;
- (void) mq_lang_change : (NSNotification *) nt;
- (void) mq_fillin_infos : (BOOL) cn_flag ;
- (void) mq_timer_stop : (NSNotification *) nt;

@property (nonatomic , assign) BOOL anim_flag;

@end

@implementation MQWeather

static NSArray <NSString *> *RAINVILLE_WEATHER_INFOS_ZH_HANS ;
static NSArray <NSString *> *RAINVILLE_WEATHER_INFOS_EN ;

+ (void)initialize{
    RAINVILLE_WEATHER_INFOS_ZH_HANS = @[@"更新时间 : " , @"当前 : " ,
                                        @"今日 : " , @"湿度 : " ,
                                        @"风力 : " , @"PM2.5 : " ,
                                        @"能见度 : " , @"大气压 : "];
    RAINVILLE_WEATHER_INFOS_EN = @[@"Update time : " , @"Current : " ,
                                    @"Today : " , @"Humidity : " ,
                                    @"Wind speed : " , @"PM2.5 : " ,
                                    @"Visibility : " , @"Pressure : "];
}

+ (instancetype) mq_weather {
    MQWeather *t = [[self alloc] init];
    return t;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self prepare];
    }
    return self;
}

- (void)setCur_progress:(CGFloat)cur_progress {
    _cur_progress = cur_progress;
    [self.vw_pgs mq_draw_with:cur_progress];
}

- (void) mq_timer_operate : (BOOL) enable {
    [self mq_btn_shake_and_disappear];
}

- (void) mq_set_icon : (NSString *) key {
    if (key && key.length) {
        self.btn_icon.label.text = RAINVILLE_ICONS_KEYMAP[key];
    }
}

- (void) mq_set_data : (NSDictionary *) d {
    self.data = d;
    [self mq_set_icon:@"".s(d[@"wea_img"])];
    
    NSString *update_time = @"".s(d[@"update_time"]);
    NSString *current = @"".s(d[@"tem"]).s(@" ℃");
    NSString *today = @"".s(d[@"tem2"]).s(@" ℃").s(@" ~ ").s(d[@"tem1"]).s(@" ℃");
    NSString *humidity = @"".s(d[@"humidity"]);
    NSString *wind_speed = @"".s(d[@"win"]).s(@" , ")
                            .s(d[@"win_speed"]).s(@" , ")
                            .s(d[@"win_meter"]);
    NSString *pm25 = @"".s(d[@"air_pm25"]).s(@" ( ").s(d[@"air_level"]).s(@" )");
    NSString *visibility = @"".s(d[@"visibility"]);
    NSString *pressure = @"".s(d[@"pressure"]).s(@" hPa");
    
    self.infos = @[update_time , current , today ,
                   humidity , wind_speed , pm25 ,
                   visibility , pressure];
    
    NSString *lang = [[NSUserDefaults standardUserDefaults] valueForKey:rainville_user_lang_settings];
    [self mq_fillin_infos:(![lang containsString:@"en"])];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    __weak typeof(self) weak_self = self;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(UIView.mq_width);
    }];
    
    [self.vw_pgs mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.size.mas_equalTo(MQScaleW(68 * 2));
        make.top.centerX.equalTo(strong_self);
    }];
    
    [self.btn_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.size.mas_equalTo(MQScaleW(48 * 2));
        make.center.equalTo(strong_self.vw_pgs);
    }];
    
    [self.lb_play_stop mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.center.equalTo(strong_self.vw_pgs);
        make.width.equalTo(strong_self);
    }];
    
    [self.lb_wthr mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.centerX.equalTo(strong_self);
        make.top.mas_equalTo(strong_self.vw_pgs.mas_bottom).offset(MQScaleW(20));
    }];
    
    [self.lb_loc mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.centerX.equalTo(strong_self);
        make.top.mas_equalTo(strong_self.lb_wthr.mas_bottom).offset(MQScaleW(10));
    }];
    
    float f = 0;
    UILabel *old;
    for (UILabel *lb in self.lb_infos) {
        f = MQScaleW((old ? 10 : 20));
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            __strong typeof(weak_self) strong_self = weak_self;
            make.width.equalTo(strong_self).multipliedBy(.75);
            make.centerX.equalTo(strong_self);
            if (old) {
                make.top.mas_equalTo(old.mas_bottom).offset(f);
            } else make.top.mas_equalTo(strong_self.lb_loc.mas_bottom).offset(f);
        }];
        old = lb;
    }
    
    [old mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.bottom.equalTo(strong_self).offset(-10);
    }];
}

#pragma mark - --

- (void) prepare {
    self.anim_flag = false;
    
    self.vw_pgs = [[MQProgress alloc] init]; // 68 * 2 直径
    [self mq_add:self.vw_pgs];
    
    self.btn_icon = [[MQButton alloc] init];
    self.btn_icon.label.textColor = MQ_COLOR_HEX(css_color_text_white, 1.f);
    self.btn_icon.label.textAlignment = NSTextAlignmentCenter;
    self.btn_icon.label.font = mq_icon_with(MQScaleW(css_size_text_large * 2));
    [self mq_add:self.btn_icon];
    self.btn_icon.hidden = true;
    __weak typeof(self) weak_self = self;
    [self.btn_icon mq_actions:^(MQButton *sender) {
        __strong typeof(weak_self) strong_self = weak_self;
        if (strong_self.delegate
            && [strong_self.delegate respondsToSelector:@selector(mq_weather_click_playstop:)]) {
            [strong_self.delegate mq_weather_click_playstop:strong_self];
        }
    }];
    
    self.lb_wthr = [[UILabel alloc] init];
    self.lb_wthr.textColor = MQ_COLOR_HEX(css_color_text_white, 1.f);
    self.lb_wthr.textAlignment = NSTextAlignmentCenter;
    [self mq_add:self.lb_wthr];
    
    self.lb_loc = [[UILabel alloc] init];
    self.lb_loc.textColor = MQ_COLOR_HEX(css_color_text_white, 1.f);
    self.lb_loc.textAlignment = NSTextAlignmentCenter;
    [self mq_add:self.lb_loc];
    
    self.lb_play_stop = [[UILabel alloc] init];
    self.lb_play_stop.textColor = MQ_COLOR_HEX(css_color_text_white, 1.f);
    self.lb_play_stop.textAlignment = NSTextAlignmentCenter;
    [self mq_add:self.lb_play_stop];
    
    NSMutableArray *a = [NSMutableArray array];
    for (int i = 0; i < RAINVILLE_WEATHER_INFOS_EN.count; i++) {
        UILabel *l = [[UILabel alloc] init];
        l.textColor = MQ_COLOR_HEX(css_color_text_white, 1.f);
        [self mq_add:l];
        [a mq_add:l];
    }
    self.lb_infos = a;
    
    NSString *lang = [[NSUserDefaults standardUserDefaults] valueForKey:rainville_user_lang_settings];
    BOOL cn_flag = ![lang containsString:@"en"];
    NSNotification *nt = [[NSNotification alloc] initWithName:HEADER_LANG_SWITCHED_NOTIFICATION
                                                       object:nil
                                                     userInfo:@{@"cn_flag":@(cn_flag)}];
    [self mq_lang_change:nt];
    
    NSNotificationCenter *ntc = [NSNotificationCenter defaultCenter];
    [ntc addObserver:self
            selector:@selector(mq_lang_change:)
                name:HEADER_LANG_SWITCHED_NOTIFICATION
              object:nil];
    
    [ntc addObserver:self
            selector:@selector(mq_timer_stop:)
                name:TIMER_COUNTDOWN_ENDS_NOTIFICATION
              object:nil];
    [ntc addObserver:self
            selector:@selector(mq_timer_stop:)
                name:TIMER_STOPPED_NOTIFICATION
              object:nil];
}

- (void) mq_lang_change : (NSNotification *) nt {
    __block BOOL cn_flag = [nt.userInfo[@"cn_flag"] boolValue];
    NSDictionary *d = cn_flag ? RAINVILLE_DISPLAY_ZH_HANS : RAINVILLE_DISPLAY_EN;
    
    self.lb_play_stop.text = @"".s(d[@"action"][@"play"])
                                .s(@" / ")
                                .s(d[@"action"][@"stop"]);
    UIFont *(^fonts)(float) = ^(float f) {
        return (cn_flag ? mq_zh_hans_font_with : mq_en_font_with )(MQScaleW(f));
    };
    
    self.lb_play_stop.font = fonts(css_size_text_small);
    self.lb_loc.font = fonts(css_size_text_default);
    self.lb_wthr.font = fonts(css_size_text_default);
    
    for (UILabel *l in self.lb_infos) { l.font = fonts(css_size_text_default); }
    
    [self mq_fillin_infos:cn_flag];
}

- (void) mq_fillin_infos : (BOOL) cn_flag {
    
    BOOL b = self.lb_infos.count == self.infos.count;
    if (!b) {
        self.lb_wthr.hidden = true;
        self.lb_loc.hidden = true;
        
        [self.lb_infos makeObjectsPerformSelector:@selector(setHidden:)
                                       withObject:@(true)];
        return;
    }
    
    self.lb_wthr.hidden = false;
    self.lb_loc.hidden = false;
    
    NSDictionary *d = self.data;
    NSArray *a = cn_flag ? RAINVILLE_WEATHER_INFOS_ZH_HANS : RAINVILLE_WEATHER_INFOS_EN;
    
    self.lb_wthr.text = @"".s(d[cn_flag ? @"wea" : @"wea_img"]);
    if (cn_flag) {
        self.lb_loc.text = @"".s(d[@"country"]).s(@" , ").s(d[@"city"]);
    } else self.lb_loc.text = @"".s(d[@"cityEn"]).s(@" , ").s(d[@"countryEn"]);
    
    int i = 0;
    for (UILabel *lb in self.lb_infos) {
        lb.hidden = false;
        lb.text = @"".s(a[i]).s(self.infos[i]);
        i++;
    }
}

- (void) mq_timer_stop : (NSNotification *) nt {
    self.cur_progress = 0;
    self.lb_play_stop.hidden = true;
    self.anim_flag = false;
    self.btn_icon.hidden = false;
}

- (void) mq_btn_shake_and_disappear {
    if (self.anim_flag) return;
    
    self.anim_flag = true;
    self.lb_play_stop.hidden = false;
    self.btn_icon.hidden = true;
    
    // 本来想看看有没有简单写法的 shake 动画 ,
    // 然后看了 Canvas 的源码 .
    // 吐槽 ... 回调地狱啊 ... 简直了 ...
    // 不忍直视
    // 我还是自己写吧
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.values = @[@(M_PI * -.03f) , @(M_PI * .03f) , @(M_PI * -.03f)]; // 0.027 约为 5° ~ 6°
    anim.duration = .25f;
    anim.repeatCount = 4;
    anim.removedOnCompletion = YES;
    anim.fillMode = kCAFillModeForwards;
    [self.lb_play_stop.layer addAnimation:anim
                                   forKey:@"shake"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.lb_play_stop.hidden = true;
        self.anim_flag = false;
        self.btn_icon.hidden = false;
    });
}

@end
