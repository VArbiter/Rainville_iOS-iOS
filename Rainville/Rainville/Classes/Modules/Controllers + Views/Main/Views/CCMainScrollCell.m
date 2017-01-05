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

@interface CCMainScrollCell ()

@property (nonatomic , strong) UIScrollView *scrollViewBottom ;
@property (nonatomic , strong) UITableView *tableView ;
@property (nonatomic , strong) NSArray *arrayItem ;

@property (nonatomic , strong) CCMainLighterDataSource *lighterDataSource ;
@property (nonatomic , strong) CCMainLighterDelegate *lighterDelegate ;

- (void) ccDefaultSettings ;

@end

@implementation CCMainScrollCell

- (void) ccConfigureCellWithHandler : (void(^)(NSString * stringKey , NSInteger integerSelectedIndex)) block {
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    _scrollViewBottom = [CCMainHandler ccCreateMainBottomScrollViewWithView];
    [self.contentView addSubview:_scrollViewBottom];
    
    _tableView = [CCMainHandler ccCreateMainTableViewWithScrollView:_scrollViewBottom];
    [_scrollViewBottom addSubview:_tableView];
    
    _lighterDataSource = [[CCMainLighterDataSource alloc] initWithReloadblock:nil];
    __unsafe_unretained CCMainLighterDataSource *tDataSource = _lighterDataSource;
    _tableView.dataSource = tDataSource;
    
    ccWeakSelf;
    _lighterDelegate = [[CCMainLighterDelegate alloc] initWithSelectedBlock:^(NSInteger integerSelectedIndex) {
        if (block) {
            _CC_Safe_Async_Block(^{
                block(pSelf.arrayItem[integerSelectedIndex] , integerSelectedIndex);
            });
        }
    }];
    __unsafe_unretained CCMainLighterDelegate *tDelegate = _lighterDelegate;
    _tableView.delegate = tDelegate;
}

#pragma mark - Private 

- (void) ccDefaultSettings {
    _arrayItem = _CC_ARRAY_ITEM_();
}

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0,
                                           0,
                                           _CC_ScreenWidth(),
                                           _CC_ScreenHeight() *0.3f)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self ccDefaultSettings];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
