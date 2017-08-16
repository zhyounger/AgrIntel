//
//  NSDate+AGRExtension.m
//  AgrIntel
//
//  Created by 实验室 on 2017/7/21.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import "NSDate+AGRExtension.h"

@implementation NSDate (AGRExtension)

-(NSDateComponents *)deltaFrom:(NSDate *)from
{
    
    //日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //比较时间
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    
    return [calendar components:unit fromDate:from toDate:self options:0];
    
}

-(BOOL)isThisYear
{
    
    //日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    
    return nowYear == selfYear;
}

-(BOOL)isToday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:self];
    
    return [nowString isEqualToString:selfString];
}

-(BOOL)isYesterday
{
    //日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    //转两次去掉时间的时和分，仅剩年月日的比较
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    //日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == 1;
}

@end
