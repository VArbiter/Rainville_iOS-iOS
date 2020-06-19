//
//  MQPoem.m
//  Rainville_Module
//
//  Created by 冯明庆 on 2020/6/15.
//

#import "MQPoem.h"

@interface MQPoem ()

@property (nonatomic , copy) NSArray <UILabel *> *arr_lbs;
@property (nonatomic , assign) BOOL cn_flag;

- (void) prepare ;
- (void) mq_prepare_lbs : (BOOL) cn_flag;
- (void) mq_noti_lang_change : (NSNotification *) nt ;

@property (nonatomic , copy) NSDictionary * dict_display;

@end

@implementation MQPoem

+ (instancetype) mq_poem {
    MQPoem *p = [[MQPoem alloc] initWithFrame:(CGRect){0,0,UIView.mq_width,0}];
    return p;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self prepare];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    __weak typeof(self) weak_self = self;
    
    UILabel *l_old = nil;
    int i = 0;
    for (UILabel *l in self.arr_lbs) {
        [l mas_makeConstraints:^(MASConstraintMaker *make) {
            __strong typeof(weak_self) strong_self = weak_self;
            make.width.centerX.equalTo(strong_self);
            if (i == 0) make.top.mas_equalTo(20);
            else make.top.mas_equalTo(l_old.mas_bottom).offset(5);
        }];
        l_old = l;
        i++;
    }
    
    // 用于 masonry 自动撑开父容器高度
    [l_old mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.bottom.equalTo(strong_self).offset(-10);
    }];
}

#pragma mark - --

- (void) prepare {
    NSString *lang = [[NSUserDefaults standardUserDefaults] valueForKey:rainville_user_lang_settings];
    self.cn_flag = ![lang containsString:@"en"];
    
    self.dict_display = (self.cn_flag ? RAINVILLE_DISPLAY_ZH_HANS : RAINVILLE_DISPLAY_EN)[@"app"];
    
    [self mq_prepare_lbs:self.cn_flag];
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mq_noti_lang_change:)
                                                 name:HEADER_LANG_SWITCHED_NOTIFICATION
                                               object:nil];
}

- (void) mq_prepare_lbs : (BOOL) cn_flag {
    [self.arr_lbs makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.arr_lbs = nil;
    
    NSArray *a ;
    if (cn_flag) {
        a = [RAINVILLE_DISPLAY_ZH_HANS[@"app"][@"app-poem"] componentsSeparatedByString:@"\n"];
    } else a = [RAINVILLE_DISPLAY_EN[@"app"][@"app-poem"] componentsSeparatedByString:@"\n"];
    
    NSMutableArray *t = [NSMutableArray array];
    int i = 0;
    for (NSString *s in a) {
        UILabel *l = [[UILabel alloc] init];
        l.text = s;
        l.textColor =  MQ_COLOR_HEX(css_color_text_white, 1.f);
        l.textAlignment = NSTextAlignmentCenter;
        l.font = (cn_flag ? mq_zh_hans_font_with : mq_en_font_with)(MQScaleW(css_size_text_default));
        
        if (cn_flag) {
            if (i == 0) l.font = mq_zh_hans_font_with(MQScaleW(css_size_text_large));
            if (i == 1) l.font = mq_zh_hans_font_with(MQScaleW(css_size_text_small));
        }
        
        [self mq_add:l];
        [t addObject:l];
        
        i++;
    }
    self.arr_lbs = t;
}

- (void) mq_noti_lang_change : (NSNotification *) nt {
    BOOL cn_flag = [nt.userInfo[@"cn_flag"] boolValue];
    self.cn_flag = cn_flag;
    
    [self mq_prepare_lbs:cn_flag];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
