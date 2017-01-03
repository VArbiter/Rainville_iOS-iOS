//
//  CCMainLighterTableView.h
//  Rainville
//
//  Created by 冯明庆 on 17/1/3.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface CCMainLighterDataSource : NSObject <UITableViewDataSource>

- (id <UITableViewDataSource>) initWithReloadblock : (void(^)()) block ;

@end

typedef void(^CCSelectedBlock)(NSInteger integerSelectedIndex);

@interface CCMainLighterDelegate : NSObject <UITableViewDelegate>

- (id <UITableViewDelegate>) initWithSelectedBlock : (CCSelectedBlock) block ;

@end
