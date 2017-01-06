//
//  CCMainScrollCell.h
//  Rainville
//
//  Created by 冯明庆 on 17/1/3.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCCellTimerDelegate <NSObject>

- (void) ccCellTimerWithSeconds : (NSInteger) integerSeconds ;

@end

@interface CCMainScrollCell : UITableViewCell

@property (nonatomic , assign) id <CCCellTimerDelegate> delegate ;

- (void) ccConfigureCellWithHandler : (void(^)(NSString * stringKey , NSInteger integerSelectedIndex)) block;

@end
