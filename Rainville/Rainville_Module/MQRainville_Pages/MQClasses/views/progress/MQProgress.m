//
//  MQProgress.m
//  Rainville_Module
//
//  Created by 冯明庆 on 2020/6/17.
//

#import "MQProgress.h"

@interface MQProgress ()

@property(nonatomic, strong) CAShapeLayer *lr_cr;
- (void) prepare ;

@end

@implementation MQProgress

- (instancetype) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self prepare];
    }
    return self;
}

- (void) mq_draw_with : (float) f_pgs {
    CGPoint c = (CGPoint){self.mq_width / 2, self.mq_width / 2};
    CGFloat r = self.mq_width / 2;
    CGFloat s = - M_PI_2;
    CGFloat e = - M_PI_2 + M_PI * 2 * f_pgs;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:c
                                                        radius:r
                                                    startAngle:s
                                                      endAngle:e
                                                     clockwise:true];
    self.lr_cr.path = [path CGPath];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.lr_cr.frame = self.bounds;
}

#pragma mark - --

- (void) prepare {
    self.lr_cr = [CAShapeLayer layer];
    self.lr_cr.frame = self.bounds;
    self.lr_cr.fillColor = [[UIColor clearColor] CGColor];
    self.lr_cr.strokeColor = MQ_COLOR_HEX(css_color_text_white, 1.f).CGColor;
    self.lr_cr.opacity = 1;
    self.lr_cr.lineCap = kCALineCapRound;
    self.lr_cr.lineWidth = MQScaleW(6);
    [self.layer addSublayer:self.lr_cr];
}

@end

#pragma mark - -- MQProgress_FanChart

@interface MQProgress_Loading ()

@property (nonatomic , strong) UIView *loading;

- (void) prepare ;

@end

@implementation MQProgress_Loading

+ (instancetype) mq_loading {
    CGFloat fw = UIView.mq_width - MQScaleW(20) * 2;
    CGRect r = (CGRect){0,0,fw,MQScaleW(5)};
    return [[self alloc] initWithFrame:r];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        [self prepare];
    }
    return self;
}

- (void) mq_selfify_anim : (BOOL) begin {
    if (begin) {
        self.loading.backgroundColor = MQ_COLOR_HEX(css_color_main_white, 1.f);
        self.loading.hidden = NO;
        [self.loading.layer removeAllAnimations];

        CAAnimationGroup *gp = [[CAAnimationGroup alloc] init];
        gp.duration = 0.3;
        gp.beginTime = CACurrentMediaTime() + 0.5;
        gp.repeatCount = MAXFLOAT;
        gp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

        CABasicAnimation *scl = [CABasicAnimation animation];
        scl.keyPath = @"transform.scale.x";
        scl.fromValue = @(1.0f);
        scl.toValue = @(1.0f * self.mq_width);

        CABasicAnimation *alp = [CABasicAnimation animation];
        alp.keyPath = @"opacity";
        alp.fromValue = @(1.0f);
        alp.toValue = @(0.5f);
        [gp setAnimations:@[scl, alp]];
        
        [self.loading.layer addAnimation:gp forKey:@"group"];
    } else {
        [self.loading.layer removeAllAnimations];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    __weak typeof(self) weak_self = self;
    [self.loading mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weak_self) strong_self = weak_self;
        make.center.equalTo(strong_self);
        make.width.mas_equalTo(1.0f);
        make.height.mas_equalTo(.5f);
    }];
}

#pragma mark - --

- (void)prepare {
    self.loading = [[UIView alloc] init];
    [self mq_add:self.loading];
}

@end
