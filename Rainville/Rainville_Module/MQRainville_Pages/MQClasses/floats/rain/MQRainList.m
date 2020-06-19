//
//  MQRainList.m
//  Rainville_Module
//
//  Created by 冯明庆 on 2020/6/17.
//

#import "MQRainList.h"

@interface MQRainList () < UITableViewDelegate , UITableViewDataSource , UIGestureRecognizerDelegate >

@property (nonatomic , strong) UITableView *tbv;
@property (nonatomic , assign) BOOL cn_flag;
@property (nonatomic , copy) UIFont *(^fonts)(float);

- (void) prepare ;
- (void) mq_lang_change : (NSNotification *) nt;
- (void) mq_tap_action : (UITapGestureRecognizer *) gr;

@end

@implementation MQRainList

+ (instancetype) mq_rainlist {
    return [[MQRainList alloc] init];
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
            strong_self.tbv.alpha = 0;
            strong_self.tbv.transform = CGAffineTransformMakeTranslation(300, 0);
        } completion:^(BOOL finished) {
            if (completion) completion();
        }];
    } else {
        self.tbv.transform = CGAffineTransformMakeTranslation(300, 0);
        self.tbv.alpha = 0;
        [UIView animateKeyframesWithDuration:.5f delay:0 options:0 animations:^{
            __strong typeof(weak_self) strong_self = weak_self;
            strong_self.tbv.alpha = 1;
            strong_self.tbv.transform = CGAffineTransformMakeTranslation(0, 0);
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
    
    [self.tbv mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.top.equalTo(strong_self);
        make.right.equalTo(strong_self).offset(-MQScaleW(20));
        make.width.mas_equalTo(MQScaleW(300));
        
        // 一共 23 个数据
        // (MQScaleW(10) + 1) 边界溢出容错值.
        CGFloat f = (MQScaleW(css_size_text_default) + (MQScaleW(10) + 1) * 2 + .5) * RAINVILLE_DATA_VOLUMES.count ,
        f_max = UIView.mq_height - mq_fit_navigation_bottom() - mq_fit_safe_area_bottom_height() - MQScaleW(20);
        f = f > f_max ? f_max : f;
        make.height.mas_equalTo(f);
    }];
}

#pragma mark - --

- (void)prepare {
    self.tbv = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tbv.backgroundColor = MQ_COLOR_HEX(css_color_main_white, 1.f);
    self.tbv.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbv.rowHeight = UITableViewAutomaticDimension;
    self.tbv.clipsToBounds = YES;
    self.tbv.layer.masksToBounds = YES;
    self.tbv.delegate = self;
    self.tbv.dataSource = self;
    [self.tbv mq_radius:5 masks:false];
    
    [self.tbv registerClass:[MQRainCell class]
     forCellReuseIdentifier:@"MQRainCell"];
    [self mq_add:self.tbv];
    
    NSString *lang = [[NSUserDefaults standardUserDefaults] valueForKey:rainville_user_lang_settings];
    BOOL cn_flag = ![lang containsString:@"en"];
    NSNotification *nt = [[NSNotification alloc] initWithName:HEADER_LANG_SWITCHED_NOTIFICATION
                                                     object:nil
                                                   userInfo:@{@"cn_flag":@(cn_flag)}];
    [self mq_lang_change:nt];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mq_lang_change:)
                                                 name:HEADER_LANG_SWITCHED_NOTIFICATION
                                               object:nil];
    
    self.layer.masksToBounds = YES;
    self.userInteractionEnabled = YES;
   
    UITapGestureRecognizer *tp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mq_tap_action:)];
    tp.numberOfTapsRequired = 1;
    tp.delegate = self;
    [self addGestureRecognizer:tp];
}

- (void) mq_lang_change : (NSNotification *) nt {
    self.cn_flag = [nt.userInfo[@"cn_flag"] boolValue];
    
    __weak typeof(self) weak_self = self;
    self.fonts = ^(float ft) {
        __strong typeof(weak_self) strong_self = weak_self;
        return (strong_self.cn_flag ? mq_zh_hans_font_with : mq_en_font_with)(MQScaleW(ft));
    };
    
    [self.tbv reloadData];
}

- (void) mq_tap_action : (UITapGestureRecognizer *) gr {
    [self mq_anim_out];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.tbv.delegate = nil;
    self.tbv.dataSource = nil;
    self.delegate = nil;
}

#pragma mark - --
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.tbv) {
        return false;
    }
    if ([touch.view isKindOfClass:[MQRainList class]]) {
        return true;
    }
    return false;
}

#pragma mark - --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return RAINVILLE_DATA_VOLUMES.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MQRainCell *c = [tableView dequeueReusableCellWithIdentifier:@"MQRainCell"
                                                    forIndexPath:indexPath];
    c.lb.font = self.fonts(css_size_text_default);
    NSDictionary *d = RAINVILLE_DATA_VOLUMES[indexPath.row];
    c.lb.text = d[self.cn_flag ? rainville_zh_hans : rainville_en];
    
    return c;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(mq_rainlist:posted_data:)]) {
        [self.delegate mq_rainlist:self
                       posted_data:RAINVILLE_DATA_VOLUMES[indexPath.row]];
    }
}

@end

#pragma mark - ------

@interface MQRainCell ()

@property (nonatomic , strong , readwrite) UILabel *lb;
@property (nonatomic , strong) UIView *sld;

- (void) prepare ;

@end

@implementation MQRainCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self prepare];
    }
    return self;
}

- (void)awakeFromNib { [super awakeFromNib]; }
- (void)prepareForReuse {
    [super prepareForReuse];
    self.lb.text = @"";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:false animated:false];
}

#pragma mark - --
+ (BOOL)requiresConstraintBasedLayout { return YES; }
- (void)updateConstraints {
    [super updateConstraints];
    
    __weak typeof(self) weak_self = self;
    [self.lb mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.top.equalTo(strong_self.contentView).offset(MQScaleW(10));
        make.left.equalTo(strong_self.contentView).offset(MQScaleW(20));
        make.right.equalTo(strong_self.contentView).offset(-MQScaleW(20));
        make.centerY.equalTo(strong_self.contentView);
    }];
        
    [self.sld mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.height.mas_equalTo(.5);
        make.width.centerX.mas_equalTo(strong_self.contentView);
    }];
    
    [self.sld mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.bottom.equalTo(strong_self.contentView);
    }];
}

#pragma mark - --

- (void) prepare {
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    self.lb = [[UILabel alloc] init];
    self.lb.textColor = MQ_COLOR_HEX(css_color_text_black, 1.f);
    [self.contentView mq_add:self.lb];
    
    self.sld = [[UIView alloc] init];
    self.sld.backgroundColor = MQ_COLOR_HEX(css_color_main, 1.f);
    [self.contentView mq_add:self.sld];
}

@end
