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

@interface CCMainViewController () <UITableViewDataSource , UITableViewDelegate , CCPlayActionDelegate >
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

- (void) ccNotificationRemoteControl : (NSNotification *) sender ;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ccNotificationRemoteControl:)
                                                 name:_CC_APP_DID_RECEIVE_REMOTE_NOTIFICATION_
                                               object:nil];
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

#pragma mark - Notification
- (void) ccNotificationRemoteControl : (NSNotification *) sender {
    NSInteger integerOrder = [sender.userInfo[@"key"] integerValue];
    if (integerOrder < 0) return;
    switch (integerOrder) {
        case UIEventSubtypeRemoteControlPause:{
            [_handler ccPausePlayingWithCompleteHandler:^{
                CCLog(@"_CC_PAUSE_SUCCEED_");
            } withOption:CCPlayOptionPause];
        }break;
        case UIEventSubtypeRemoteControlPlay:{
            [_handler ccPausePlayingWithCompleteHandler:^{
                CCLog(@"_CC_PLAY_SUCCEED_");
            } withOption:CCPlayOptionPlay];
        }break;
        case UIEventSubtypeRemoteControlNextTrack:{
            
        }break;
        case UIEventSubtypeRemoteControlPreviousTrack:{
            
        }break;
        case UIEventSubtypeRemoteControlTogglePlayPause:{
            
        }break;
            
        default:
            return ;
            break;
    }
}

#pragma mark - System
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != _tableView) return;
    [_headerView ccSetUpDownLabel:(scrollView.contentOffset.y < (_CC_ScreenHeight() * 0.3f - 3.0f))];
}

- (void) ccClickedAction : (NSInteger) integerIndex
                 withKey : (NSString *) stringKey {
    CCLog(@"_CC_CLICKED_%ld_KEY_%@_",integerIndex,stringKey);
    ccWeakSelf;
    [_handler ccSetAudioPlayerWithVolumeArray:_dictionaryTheme[stringKey] withCompleteHandler:^{
        CCLog(@"_CC_PLAY_SUCCEED_");
        [pSelf.handler ccSetInstantPlayingInfo:stringKey];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

_CC_DETECT_DEALLOC_

@end
