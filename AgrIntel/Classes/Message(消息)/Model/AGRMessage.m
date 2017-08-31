//
//  AGRMessage.m
//  AgrIntel
//
//  Created by 实验室 on 2017/8/26.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import "AGRMessage.h"

@implementation AGRMessage

//初始化
-(id)initWithTime:(NSString *)time andSensor:(NSString *)sensor {
    if (self=[super init]) {
        _time=time;
        _sensor=sensor;
        
    }
    return self;
}

@end
