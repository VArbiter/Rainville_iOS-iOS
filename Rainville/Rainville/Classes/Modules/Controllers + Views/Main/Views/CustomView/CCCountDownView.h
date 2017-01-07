//
//  CCCountDownView.h
//  Rainville
//
//  Created by 冯明庆 on 17/1/7.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCCountDownDelegate <NSObject>

// @return min * 60 = secs
- (void) ccCountDownWithTime : (NSInteger) integerSeconds ;

@end

@interface CCCountDownView : UIView

@property (nonatomic , assign) id <CCCountDownDelegate> delegate ;

- (instancetype) initFromNib ;

- (void) ccEnableCountingDown : (BOOL) isEnable ;

- (void) ccCancelAndResetCountingDown ;

@end
