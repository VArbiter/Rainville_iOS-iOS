//
//  CCMainLighterTableView.m
//  Rainville
//
//  Created by 冯明庆 on 17/1/3.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "CCMainLighterTableView.h"

#import "CCLocalizedHelper.h"

#import "UILabel+CCExtension.h"

@interface CCMainLighterDataSource ()

@property (nonatomic , strong) NSArray *arrayData ;

- (void) ccDefaultSettings ;

@end

@implementation CCMainLighterDataSource

- (instancetype) initWithReloadblock : (void(^)()) block {
    if (self = [super init]) {
        [self ccDefaultSettings];
        _CC_Safe_Async_Block(block, ^{
            block();
        });
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"_CC_CELL_ID_"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"_CC_CELL_ID_"];
        cell.textLabel.textColor = _CC_HexColor(0xFEFEFE);
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = _CC_HexColor(0x22A1A2);
        cell.textLabel.highlightedTextColor = _CC_HexColor(0x333333);
    }
    
    [cell.textLabel ccMusketWithFontSize:15.0f
                              withString:_arrayData[indexPath.row]];
    
    return cell;
}

#pragma mark - Private Settings 

- (void) ccDefaultSettings {
    _arrayData = _CC_ARRAY_ITEM_();
}

_CC_DETECT_DEALLOC_

@end

#pragma mark ===============================

@interface CCMainLighterDelegate ()

@property (nonatomic , copy) CCSelectedBlock block ;

@property (nonatomic , assign) NSInteger integerSelectedIndex ;

- (void) ccDefaultSettings ;

@end

@implementation CCMainLighterDelegate

- (id <UITableViewDelegate>) initWithSelectedBlock : (CCSelectedBlock) block {
    if (self = [super init]) {
        [self ccDefaultSettings];
        if (block) {
            _block = [block copy];
        }
    }
    return self;
}

#pragma mark - Private

- (void) ccDefaultSettings {
    _integerSelectedIndex = -1;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_integerSelectedIndex == indexPath.row) return ;
    _integerSelectedIndex = indexPath.row ;
    ccWeakSelf;
    _CC_Safe_Async_Block(_block, ^{
        pSelf.block(indexPath.row);

    });
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _CC_ScreenHeight() * 0.3f / 6.0f ;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

_CC_DETECT_DEALLOC_

@end
