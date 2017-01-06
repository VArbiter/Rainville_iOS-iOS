//
//  CCCountDownView.h
//  Rainville
//
//  Created by 冯明庆 on 17/1/7.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCCountDownDelegate <NSObject>

// @return 00 : 00
- (void) ccCountDownWithTime : (NSString *) stringTimes ;

@end

@interface CCCountDownView : UIView

@property (nonatomic , assign) id <CCCountDownDelegate> delegate ;

- (instancetype) initFromNib ;

@end