//
//  CCMainHeaderView.h
//  Rainville
//
//  Created by 冯明庆 on 17/1/3.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCPlayActionDelegate <NSObject>

@required
- (void) ccHeaderButtonActionWithPlayOrPause : (BOOL) isPlay ;

@end

@interface CCMainHeaderView : UIView

@property (nonatomic , assign) id <CCPlayActionDelegate> delegate ;

- (instancetype) initFromNib ;

- (void) ccSetUpDownLabel : (BOOL) isUp ;

@end
