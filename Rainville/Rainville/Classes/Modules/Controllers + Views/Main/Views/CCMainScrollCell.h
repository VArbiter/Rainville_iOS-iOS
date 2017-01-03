//
//  CCMainScrollCell.h
//  Rainville
//
//  Created by 冯明庆 on 17/1/3.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCMainScrollCell : UITableViewCell

- (void) ccConfigureCellWithHandler : (void(^)(NSInteger integerSelectedIndex)) block;

@end
