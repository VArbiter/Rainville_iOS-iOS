//
//  CCAudioHandler.h
//  Rainville
//
//  Created by 冯明庆 on 17/1/3.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVAudioSession;

@interface CCAudioHandler : NSObject

@property (nonatomic , strong) AVAudioSession *audioSession ;

+ (instancetype) sharedAudioHandler ;

@end
