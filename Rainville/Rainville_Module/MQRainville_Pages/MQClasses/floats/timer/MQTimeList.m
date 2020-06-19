//
//  MQTimeList.m
//  Rainville_Module
//
//  Created by 冯明庆 on 2020/6/17.
//

#import "MQTimeList.h"

@interface MQTimeList () <UIPickerViewDelegate , UIPickerViewDataSource , UIGestureRecognizerDelegate>

@property (nonatomic , strong) UIView *vw_whe_con;
@property (nonatomic , strong) UILabel *lb_bfe;
@property (nonatomic , strong) UILabel *lb_atr;
@property (nonatomic , strong) UIPickerView *pkvw;

- (void) prepare;
- (void) mq_config_text ;
- (void) mq_lang_change : (NSNotification *) nt;
- (void) mq_tap_action : (UITapGestureRecognizer *) tp;

@end

@implementation MQTimeList

+ (instancetype) mq_timelist {
    return [[MQTimeList alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self prepare];
    }
    return self;
}

- (void) mq_anim_inout : (BOOL) bout
                    on : (void(^ _Nullable)(void)) completion {
    __weak typeof(self) weak_self = self;
    if (bout) {
        [UIView animateKeyframesWithDuration:.5f delay:0 options:0 animations:^{
            __strong typeof(weak_self) strong_self = weak_self;
            strong_self.vw_whe_con.alpha = 0;
            strong_self.vw_whe_con.transform = CGAffineTransformMakeTranslation(0, -300);
        } completion:^(BOOL finished) {
            if (completion) completion();
        }];
    } else {
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
        // make bottom
//        CGFloat fb = strong_self.mq_bottom - mq_fit_safe_area_bottom_height();
//        make.bottom.mas_equalTo(fb).offset(-MQScaleW(20));
        // make top
        make.top.equalTo(strong_self);
        make.right.mas_equalTo(strong_self.mas_right).offset(-MQScaleW(20));
        make.left.mas_equalTo(strong_self.mas_left).offset(MQScaleW(20));
    }];
    
    [self.lb_bfe mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak typeof(weak_self) strong_self = weak_self;
        make.right.mas_equalTo(strong_self.pkvw.mas_left).offset(-10);
        make.centerY.equalTo(strong_self.pkvw);
    }];
    
    [self.pkvw mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak typeof(weak_self) strong_self = weak_self;
        make.left.equalTo(strong_self.vw_whe_con.mas_centerX);
        make.centerY.equalTo(strong_self.vw_whe_con.mas_centerY);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(80);
    }];
    
    [self.lb_atr mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak typeof(weak_self) strong_self = weak_self;
        make.left.mas_equalTo(strong_self.pkvw.mas_right).offset(10);
        make.centerY.equalTo(strong_self.lb_bfe);
    }];
    
    [self.pkvw mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak typeof(weak_self) strong_self = weak_self;
        make.bottom.equalTo(strong_self.vw_whe_con);
    }];
    [self.lb_atr mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak typeof(weak_self) strong_self = weak_self;
        make.right.equalTo(strong_self.vw_whe_con).offset(10);
    }];
}

#pragma mark - --
- (void)prepare {
    self.layer.masksToBounds = YES;
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mq_tap_action:)];
    tp.numberOfTapsRequired = 1;
    tp.delegate = self; // 因为 触摸 和 事件有冲突
    [self addGestureRecognizer:tp];
    
    self.vw_whe_con = [[UIView alloc] init];
    self.vw_whe_con.backgroundColor = MQ_COLOR_HEX(css_color_main_white, 1.f);
    [self.vw_whe_con mq_radius:5 masks:false];
    [self mq_add:self.vw_whe_con];
    
    self.lb_bfe = [[UILabel alloc] init];
    self.lb_bfe.textAlignment = NSTextAlignmentRight;
    self.lb_bfe.textColor = MQ_COLOR_HEX(css_color_text_black, 1.f);
    [self.vw_whe_con mq_add:self.lb_bfe];
    
    self.pkvw = [[UIPickerView alloc] init];
    self.pkvw.delegate = self;
    self.pkvw.dataSource = self;
    [self.vw_whe_con mq_add:self.pkvw];
    
    self.lb_atr = [[UILabel alloc] init];
    self.lb_atr.textAlignment = NSTextAlignmentLeft;
    self.lb_atr.textColor = MQ_COLOR_HEX(css_color_text_black, 1.f);
    [self.vw_whe_con mq_add:self.lb_atr];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mq_lang_change:)
                                                 name:HEADER_LANG_SWITCHED_NOTIFICATION
                                               object:nil];
    [self mq_config_text];
}

- (void) mq_config_text {
    NSString *lang = [[NSUserDefaults standardUserDefaults] valueForKey:rainville_user_lang_settings];
    BOOL cn_flag = ![lang containsString:@"en"];
    NSNotification *nt = [[NSNotification alloc] initWithName:HEADER_LANG_SWITCHED_NOTIFICATION
                                                       object:nil
                                                     userInfo:@{@"cn_flag":@(cn_flag)}];
    [self mq_lang_change:nt];
}

- (void) mq_lang_change : (NSNotification *) nt {
    __block BOOL cn_flag = [nt.userInfo[@"cn_flag"] boolValue];
    
    NSDictionary *d = (cn_flag ? RAINVILLE_DISPLAY_ZH_HANS : RAINVILLE_DISPLAY_EN);
    
    UIFont *(^fonts)(float) = ^(float f) {
        return (cn_flag ? mq_zh_hans_font_with : mq_en_font_with)(MQScaleW(f));
    };
    self.lb_bfe.font = fonts(css_size_text_default);
    self.lb_bfe.text = d[@"action"][@"timer-before"];
    self.lb_atr.font = fonts(css_size_text_default);
    self.lb_atr.text = d[@"action"][@"timer-after"];
}

- (void) mq_tap_action : (UITapGestureRecognizer *) tp {
    [self mq_anim_out];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.pkvw.delegate = nil;
    self.pkvw.dataSource = nil;
    self.delegate = nil;
}

#pragma mark - --
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.vw_whe_con) {
        return false;
    }
    if ([touch.view isKindOfClass:[MQTimeList class]]) {
        return true;
    }
    return false;
}

#pragma mark - --
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return MQScaleW(80);
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return MQScaleW(css_size_text_medium);
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return RAINVILLE_TIMERS.count;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    for(UIView *le in pickerView.subviews){
        if (le.mq_height < 1) {
            le.backgroundColor = [UIColor clearColor];
            UIView *t = [[UIView alloc] init];
            t.backgroundColor = MQ_COLOR_HEX(css_color_main, 1.f);
            [le mq_add:t];
            [t mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(le);
                make.height.equalTo(le).multipliedBy(2.5f);
                make.center.equalTo(le);
            }];
        }
    }
    
    UILabel *lb = [UILabel new];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.font = mq_zh_hans_font_with(MQScaleW(css_size_text_default));
    lb.textColor = MQ_COLOR_HEX(css_color_text_black, 1.f);
    lb.text = @"".s(RAINVILLE_TIMERS[row]);
    
    return lb;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(mq_timelist:on_time:)]) {
        [self.delegate mq_timelist:self on_time:RAINVILLE_TIMERS[row]];
    }
}

@end
