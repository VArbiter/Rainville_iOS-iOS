//
//  MQHomeController.m
//  Rainville_Module
//
//  Created by 冯明庆 on 2020/6/15.
//

#import "MQHomeController.h"
#import "MQHeader.h"
#import "MQPoem.h"
#import "MQWeather.h"

#import "MQLaunch.h"
#import "MQAboutTag.h"
#import "MQTimeList.h"
#import "MQRainList.h"

#import "Rainville_Module/MQAudioHandler.h"
#import "Rainville_Module/MQAudioTimer.h"
#import "Rainville_Module/MQRequester.h"

#import <SafariServices/SafariServices.h>
#import <MessageUI/MessageUI.h>

@interface MQHomeController () <MQHeaderDelegate , MQTimeListDelegate , MQAudioTimerDelegate ,
                                MQWeatherDelegate , MQRainListDelegate , MQRequesterDelegate ,
                                MQAboutTagDelegate>

@property (nonatomic , strong) UIView *v;
@property (nonatomic , strong) MQHeader *h;
@property (nonatomic , strong) MQPoem *p;
@property (nonatomic , strong) MQWeather *w;

- (void) rd_settings ;
- (void) mq_lang_change : (NSNotification *) nt ;

@property (nonatomic , strong) NSMutableDictionary <NSString *, UIView *> *dt_vs;
- (BOOL) mq_reject_exists_subs : (NSString *) key ;

@end

@implementation MQHomeController

- (void)loadView {
    self.v = [[UIView alloc] initWithFrame:CGRectFull()];
    self.v.backgroundColor = MQ_COLOR_HEX(css_color_main, 1.f);
    self.view = self.v;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dt_vs = @{}.mutableCopy;
    MQ_TIMER.delegate = self;
    MQ_REQUESTER.delegate = self;
    [MQ_REQUESTER mq_enable_30min_timer];
    
    [self rd_settings];
    
    self.h = [MQHeader mq_header];
    self.h.delegate = self;
    [self.v mq_add:self.h];
    
    self.p = [MQPoem mq_poem];
    [self.v mq_add:self.p];
    
    __weak typeof(self) weak_self = self;
    [self.p mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.top.mas_equalTo(strong_self.h.mas_bottom).offset(MQScaleW(30));
        make.width.equalTo(strong_self.v);
    }];
    
    self.w = [MQWeather mq_weather];
    self.w.delegate = self;
    [self.v mq_add:self.w];
    [self.w mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.top.equalTo(strong_self.p.mas_bottom).offset(MQScaleW(30));
        make.centerX.equalTo(strong_self.v);
    }];
    [self.w mq_set_icon:@"yu"]; // 设置默认为 雨
    
    MQLaunch *lch = [MQLaunch mq_launch];
    [self.v mq_add:lch];
    [lch mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.center.equalTo(strong_self.v);
    }];
    [lch mq_remove_self_after:2];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mq_lang_change:)
                                                 name:HEADER_LANG_SWITCHED_NOTIFICATION
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [MQ_REQUESTER mq_begin_request];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MQ_REQUESTER mq_begin_request];
        [self.w mq_btn_shake_and_disappear];
    });
}

#pragma mark - -- Private
- (void) rd_settings {
    NSUserDefaults *usrd = [NSUserDefaults standardUserDefaults];
    NSString *s = [usrd valueForKey:rainville_user_lang_settings];
    if (!s) {
        NSString *lang = [NSLocale preferredLanguages][0];
        [usrd setObject:[lang lowercaseString]
                 forKey:rainville_user_lang_settings];
        [usrd synchronize];
    }
}

- (void) mq_lang_change : (NSNotification *) nt {
    BOOL cn_flag = [nt.userInfo[@"cn_flag"] boolValue];
    NSUserDefaults *usrd = [NSUserDefaults standardUserDefaults];
    [usrd setObject:(cn_flag ? @"zh-hans" : @"en")
             forKey:rainville_user_lang_settings];
    [usrd synchronize];
}

- (BOOL) mq_reject_exists_subs : (NSString *) key {
    BOOL b = [self.dt_vs.allKeys containsObject:key];
    if (self.dt_vs.allValues.count) {
        [self.dt_vs.allValues makeObjectsPerformSelector:@selector(mq_anim_out)];
        [self.dt_vs removeAllObjects];
        self.dt_vs = @{}.mutableCopy;
    }
    return b;
}

#pragma mark - -- MQHeaderDelegate
- (void) mq_header : (MQHeader *) h
  toggle_time_list : (BOOL) b {
    if ([self mq_reject_exists_subs:@"MQTimeList"]) return;
    
    MQTimeList *t = [MQTimeList mq_timelist];
    t.delegate = self;
    [self.v mq_add:t];
    __weak typeof(self) weak_self = self;
    [t mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.bottom.equalTo(strong_self.v);
    }];
    [t mq_anim_inout:false on:nil];
    
    [self.dt_vs setValue:t forKey:@"MQTimeList"];
}

- (void) mq_header : (MQHeader *) h
  toggle_play_list : (BOOL) b {
    if ([self mq_reject_exists_subs:@"MQRainList"]) return;
    
    MQRainList *t = [[MQRainList alloc] init];
    t.delegate = self;
    [self.v mq_add:t];
    __weak typeof(self) weak_self = self;
    [t mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.top.mas_equalTo(strong_self.h.mas_bottom);
    }];
    [t mq_anim_inout:false on:nil];
    
    [self.dt_vs setValue:t forKey:@"MQRainList"];
}

- (void) mq_header : (MQHeader *) h
 toggle_about_page : (BOOL) b {
    if ([self mq_reject_exists_subs:@"MQAboutTag"]) return;
    
    MQAboutTag *t = [MQAboutTag mq_about];
    t.delegate = self;
    [self.v mq_add:t];
    __weak typeof(self) weak_self = self;
    [t mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.top.mas_equalTo(strong_self.h.mas_bottom);
    }];
    [t mq_anim_inout:false on:nil];
    
    [self.dt_vs setValue:t forKey:@"MQAboutTag"];
}

- (void) mq_header : (MQHeader *) h
   stop_time_click : (BOOL) b {
    [MQ_TIMER mq_stop_timer];
}

#pragma mark - -- MQTimeListDelegate
- (void) mq_timelist : (MQTimeList *) tl
             on_time : (NSNumber *) time {
    [MQ_TIMER mq_countdown_for:time];
    [self.w mq_timer_operate:YES];
    [MQ_AUDIO mq_play:@[] random:false];
}

#pragma mark - -- MQAudioTimerDelegate
- (void) mq_audio_timer_posted_countdown_time : (NSString *) str_time {
    [self.h mq_set_time:str_time];
}
- (void) mq_audio_timer_posted_percent : (float) fper {
    self.w.cur_progress = fper;
}
- (void) mq_audio_timer_countdown_ends {
    if (MQ_AUDIO.playing) {
        [MQ_AUDIO mq_pause];
    }
}

#pragma mark - -- MQWeatherDelegate
- (void) mq_weather_click_playstop : (MQWeather *) wh {
    if (MQ_AUDIO.playing) {
        [MQ_AUDIO mq_pause];
        
        if (MQ_TIMER.timing) {
            [MQ_TIMER mq_stop_timer];
        }
    }
    else [MQ_AUDIO mq_play:@[] random:false];
    
}

#pragma mark - -- MQRainListDelegate
- (void) mq_rainlist : (MQRainList *) rl
         posted_data : (NSDictionary *) item {
    NSArray *volumes = item[@"volume"];
    [MQ_AUDIO mq_play:item[@"volume"]
               random:(!volumes || !volumes.count)];
    [self.w mq_btn_shake_and_disappear];
}

#pragma mark - --
- (void) mq_requester_receive : (NSDictionary *) data
                         with : (NSError *) e {
    [self.w mq_set_data:(e ? nil : data)];
    [self.h mq_its_a_rainy_day:(e ? @"" : data[@"wea_img"])];
}

#pragma mark - --
- (void) mq_opening_github {
    [self mq_reject_exists_subs:@""];
    NSURL *u = [NSURL URLWithString:@"https://github.com/VArbiter"];
    SFSafariViewController *sf = [[SFSafariViewController alloc] initWithURL:u];
    if (@available(iOS 13.0, *)) {
        sf.modalPresentationStyle = UIModalPresentationAutomatic;
    }
    else sf.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:sf
                       animated:YES
                     completion:nil];
}
- (void) mq_sending_email {
    [self mq_reject_exists_subs:@""];
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *m = [[MFMailComposeViewController alloc] init];
        [m setToRecipients:@[@"elwinfrederick@163.com"]];
        if (@available(iOS 13.0, *)) {
            m.modalPresentationStyle = UIModalPresentationAutomatic;
        }
        else m.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:m
                           animated:YES
                         completion:nil];
    } else {
        NSString *lang = [[NSUserDefaults standardUserDefaults] valueForKey:rainville_user_lang_settings];
        BOOL cn_flag = ![lang containsString:@"en"];
        NSString *s = (cn_flag ? RAINVILLE_DISPLAY_ZH_HANS : RAINVILLE_DISPLAY_EN)[@"app"][@"app-name"];
        NSString *sm = cn_flag ? @"您尚未设置邮件账户 ." : @"You've not set a mail account yet .";
        UIAlertController *c = [UIAlertController alertControllerWithTitle:s message:sm preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:c
                           animated:YES
                         completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [c dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    }
}

@end
