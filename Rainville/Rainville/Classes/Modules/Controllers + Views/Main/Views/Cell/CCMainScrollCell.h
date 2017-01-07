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

typedef void(^CCSelectBlock)(NSString * stringKey , NSInteger integerSelectedIndex);

typedef NS_ENUM(NSInteger , CCAudioControl) {
    CCAudioControlNext = 0 ,
    CCAudioControlPrevious
};

@interface CCMainScrollCell : UITableViewCell

@property (nonatomic , assign) id <CCCellTimerDelegate> delegate ;

- (void) ccConfigureCellWithHandler : (CCSelectBlock) block;

- (void) ccSetPlayingAudio : (CCAudioControl) control ;

- (void) ccSetTimer : (BOOL) isEnabled ;

@end
