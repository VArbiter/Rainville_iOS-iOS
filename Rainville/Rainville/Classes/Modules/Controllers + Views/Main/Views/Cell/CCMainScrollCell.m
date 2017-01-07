//
//  CCMainScrollCell.m
//  Rainville
//
//  Created by 冯明庆 on 17/1/3.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "CCMainScrollCell.h"
#import "CCMainLighterTableView.h"

#import "CCMainHandler.h"

#import "CCLocalizedHelper.h"
#import "CCAuthorInfoView.h"
#import "CCCountDownView.h"

@interface CCMainScrollCell () <CCCountDownDelegate>

@property (nonatomic , strong) UIScrollView *scrollViewBottom ;
@property (nonatomic , strong) UITableView *tableView ;
@property (nonatomic , strong) NSArray *arrayItem ;

@property (nonatomic , strong) CCMainLighterDataSource *lighterDataSource ;
@property (nonatomic , strong) CCMainLighterDelegate *lighterDelegate ;
@property (nonatomic , strong) CCAuthorInfoView *viewInfo ;
@property (nonatomic , strong) CCCountDownView *viewCountDown ;

@property (nonatomic , copy) CCSelectBlock block;
@property (nonatomic , assign) NSInteger integerSelectedIndex ;

- (void) ccDefaultSettings ;

@end

@implementation CCMainScrollCell

- (void) ccConfigureCellWithHandler : (CCSelectBlock) block {
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    _scrollViewBottom = [CCMainHandler ccCreateMainBottomScrollViewWithView];
    [self.contentView addSubview:_scrollViewBottom];
    
    _viewInfo = [[CCAuthorInfoView alloc] initFromNib];
    [_scrollViewBottom addSubview:_viewInfo];
    
    _viewCountDown = [[CCCountDownView alloc] initFromNib];
    _viewCountDown.delegate = self;
    [_scrollViewBottom addSubview:_viewCountDown];
    
    _tableView = [CCMainHandler ccCreateMainTableViewWithScrollView:_scrollViewBottom];
    [_scrollViewBottom addSubview:_tableView];
    
    _lighterDataSource = [[CCMainLighterDataSource alloc] initWithReloadblock:nil];
    __unsafe_unretained CCMainLighterDataSource *tDataSource = _lighterDataSource;
    _tableView.dataSource = tDataSource;
    
    ccWeakSelf;
    _block = [block copy];
    _lighterDelegate = [[CCMainLighterDelegate alloc] initWithSelectedBlock:^(NSInteger integerSelectedIndex) {
        pSelf.integerSelectedIndex = integerSelectedIndex;
        if (block) {
            _CC_Safe_Async_Block(^{
                block(pSelf.arrayItem[integerSelectedIndex] , integerSelectedIndex);
            });
        }
    }];
    __unsafe_unretained CCMainLighterDelegate *tDelegate = _lighterDelegate;
    _tableView.delegate = tDelegate;
}

- (void) ccSetPlayingAudio : (CCAudioControl) control {
    switch (control) {
        case CCAudioControlNext:{
            if (++_integerSelectedIndex > _arrayItem.count - 1) {
                --_integerSelectedIndex;
            }
        }break;
        case CCAudioControlPrevious:{
            if (--_integerSelectedIndex < 0) {
                ++_integerSelectedIndex;
            }
        }break;
        default:
            break;
    }
    
    ccWeakSelf;
    if (_block) {
        _CC_Safe_Async_Block(^{
            pSelf.block(pSelf.arrayItem[pSelf.integerSelectedIndex] , pSelf.integerSelectedIndex);
        });
    }
}

- (void) ccSetTimer : (BOOL) isEnabled {
    if (isEnabled) {
        [_viewCountDown ccEnableCountingDown:isEnabled];
    } else {
        [_viewCountDown ccEnableCountingDown:NO];
        [_viewCountDown ccCancelAndResetCountingDown];
    }
}

#pragma mark - Private 

- (void) ccDefaultSettings {
    _arrayItem = _CC_ARRAY_ITEM_();
    _integerSelectedIndex = 0;
}

#pragma mark - CCCountDownDelegate 
- (void) ccCountDownWithTime:(NSInteger)integerSeconds {
    CCLog(@"_CC_COUNT_DOWN_SECONDS_%ld",(long)integerSeconds);
    if ([_delegate respondsToSelector:@selector(ccCellTimerWithSeconds:)]) {
        [_delegate ccCellTimerWithSeconds:integerSeconds];
    }
}

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0,
                                           0,
                                           _CC_ScreenWidth(),
                                           _CC_ScreenHeight() * 0.3f)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self ccDefaultSettings];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

_CC_DETECT_DEALLOC_

@end
