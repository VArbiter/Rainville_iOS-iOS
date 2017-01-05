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
#import "CCAudioHandler.h"
#import "CCAudioPreset.h"

#import "CCMainScrollCell.h"
#import "CCMainHeaderView.h"

#import "UILabel+CCExtension.h"

@interface CCMainViewController () <UITableViewDataSource , UITableViewDelegate , CCPlayActionDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelPoem;

@property (nonatomic , strong) UITableView *tableView ;
@property (nonatomic , strong) CCMainScrollCell *cell;
@property (nonatomic , strong) CCMainHeaderView *headerView ;
@property (nonatomic , strong) CCAudioHandler *handler ;
@property (nonatomic , strong) NSDictionary *dictionaryTheme;

- (void) ccDefaultSettings ;

- (void) ccInitViewSettings ;

- (void) ccClickedAction : (NSInteger) integerIndex
                 withKey : (NSString *) stringKey;

@end

@implementation CCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ccDefaultSettings];
    [self ccInitViewSettings];
}

- (void) ccDefaultSettings {
    self.stringControllerName = NSStringFromClass([self class]) ;
    
    _dictionaryTheme = [CCAudioPreset ccDefaultAudioSet];
    _handler = [CCAudioHandler sharedAudioHandler];
}

- (void) ccInitViewSettings {
    [_labelPoem ccMusketWithFontSize:12.0f
                          withString:_CC_RAIN_POEM_()];
    _tableView = [CCMainHandler ccCreateContentTableView];
    [self.view addSubview:_tableView];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _headerView = [[CCMainHeaderView alloc] initFromNib];
    _headerView.delegate = self;
    _tableView.tableHeaderView = _headerView;
    
    _cell = [[CCMainScrollCell alloc] initWithFrame:CGRectNull];
    ccWeakSelf;
    [_cell ccConfigureCellWithHandler:^(NSString *stringKey, NSInteger integerSelectedIndex) {
        [pSelf ccClickedAction:integerSelectedIndex
                       withKey:stringKey];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _CC_ScreenHeight() * 0.3f;
}

#pragma mark - CCPlayActionDelegate 
- (void) ccHeaderButtonActionWithPlayOrPause:(BOOL)isPlay {
    CCLog(@"_CC_PLAY_BUTTON_SELECTED_%@_",isPlay ? @"YES" : @"NO");
    [_handler ccPausePlayingWithCompleteHandler:^{
        CCLog(@"_CC_PAUSE/PLAY_SUCCEED_");
    } withOption:(isPlay ? CCPlayOptionPause : CCPlayOptionPlay)];
}

#pragma mark - System
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != _tableView) return;
    [_headerView ccSetUpDownLabel:(scrollView.contentOffset.y < (_CC_ScreenHeight() * 0.3f - 3.0f))];
}

- (void) ccClickedAction : (NSInteger) integerIndex
                 withKey : (NSString *) stringKey {
    CCLog(@"_CC_CLICKED_%ld_KEY_%@_",integerIndex,stringKey);
    [_handler ccSetAudioPlayerWithVolumeArray:_dictionaryTheme[stringKey] withCompleteHandler:^{
        CCLog(@"_CC_PLAY_SUCCEED_");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

_CC_DETECT_DEALLOC_

@end
