//
//  NSDate+AGRExtension.h
//  AgrIntel
//
//  Created by 实验室 on 2017/7/21.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (AGRExtension)

//比较from和self的时间差值
-(NSDateComponents *)deltaFrom:(NSDate *)from;

//是否为今年
-(BOOL)isThisYear;

//是否为今天
-(BOOL)isToday;

//是否为昨天
-(BOOL)isYesterday;



@end
