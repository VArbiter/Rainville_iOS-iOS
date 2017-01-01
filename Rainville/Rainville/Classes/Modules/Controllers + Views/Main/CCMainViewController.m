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

@interface CCMainViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelTest;

@property (weak, nonatomic) IBOutlet UILabel *labelPoem;

@property (nonatomic , strong) UIScrollView *scrollViewBottom ;

- (void) ccDefaultSettings ;

- (void) ccInitViewSettings ;

@end

@implementation CCMainViewController

//Weather Icons
//ElegantIcons
//Musket
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ccDefaultSettings];
    [self ccInitViewSettings];
}

- (void) ccDefaultSettings {
    self.stringControllerName = NSStringFromClass([self class]) ;
}

- (void) ccInitViewSettings {
    _labelPoem.text = _CC_RAIN_POEM_();
    
    _scrollViewBottom = [CCMainHandler ccCreateMainBottomScrollViewWithView];
    [self.view addSubview:_scrollViewBottom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
