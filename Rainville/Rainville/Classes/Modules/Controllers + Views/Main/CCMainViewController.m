//
//  CCMainViewController.m
//  Rainville
//
//  Created by 冯明庆 on 16/12/12.
//  Copyright © 2016年 冯明庆. All rights reserved.
//

#import "CCMainViewController.h"

#import "CCMainHandler.h"
#import "CCLocalizedHelper.h"
#import "CCMainLighterTableView.h"

#import "UILabel+CCExtension.h"

@interface CCMainViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelPoem;
@property (weak, nonatomic) IBOutlet UIView *viewContent;

@property (nonatomic , strong) UIScrollView *scrollViewBottom ;
@property (nonatomic , strong) UITableView *tableView ;

@property (nonatomic , strong) CCMainLighterDataSource *lighterDataSource ;
@property (nonatomic , strong) CCMainLighterDelegate *lighterDelegate ;

- (void) ccDefaultSettings ;

- (void) ccInitViewSettings ;

- (void) ccClickedAction : (NSInteger) integerIndex ;

@end

@implementation CCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ccDefaultSettings];
    [self ccInitViewSettings];
}

- (void) ccDefaultSettings {
    self.stringControllerName = NSStringFromClass([self class]) ;
    self.view.userInteractionEnabled = YES;
}

- (void) ccInitViewSettings {
    [_labelPoem ccMusketWithFontSize:12.0f
                          withString:_CC_RAIN_POEM_()];
    
    _scrollViewBottom = [CCMainHandler ccCreateMainBottomScrollViewWithView];
    [self.view addSubview:_scrollViewBottom];
    
    _tableView = [CCMainHandler ccCreateMainTableViewWithScrollView:_scrollViewBottom];
    [_scrollViewBottom addSubview:_tableView];
    
    _lighterDataSource = [[CCMainLighterDataSource alloc] initWithReloadblock:nil];
    __unsafe_unretained CCMainLighterDataSource *tDataSource = _lighterDataSource;
    _tableView.dataSource = tDataSource;
    
    ccWeakSelf;
    _lighterDelegate = [[CCMainLighterDelegate alloc] initWithSelectedBlock:^(NSInteger integerSelectedIndex) {
        [pSelf ccClickedAction:integerSelectedIndex];
    }];
    __unsafe_unretained CCMainLighterDelegate *tDelegate = _lighterDelegate;
    _tableView.delegate = tDelegate;
}

- (void) ccClickedAction : (NSInteger) integerIndex {
    CCLog(@"_CC_CLICKED_%ld_",integerIndex);
}

#pragma mark - Touches

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

_CC_DETECT_DEALLOC_

@end
