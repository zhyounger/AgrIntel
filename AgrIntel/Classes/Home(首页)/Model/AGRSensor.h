//
//  AGRSensor.h
//  AgrIntel
//
//  Created by 实验室 on 2017/7/10.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGRSensor : NSObject
//传感器
@property (nonatomic, copy) NSString *sensor;
//图片
@property (nonatomic, copy) NSString *imgurl;
//日期
@property (nonatomic, copy) NSString *day;
//时间
@property (nonatomic, copy) NSString *time;
//温度
@property (nonatomic, copy) NSString *tem;
//最高温度
@property (nonatomic, copy) NSString *maxtem;
//最低温度
@property (nonatomic, copy) NSString *mintem;
//湿度
@property (nonatomic, copy) NSString *hum;
//最高湿度
@property (nonatomic, copy) NSString *maxhum;
//最低湿度
@property (nonatomic, copy) NSString *minhum;
//光照强度
@property (nonatomic, copy) NSString *light;
//最大光照强度
@property (nonatomic, copy) NSString *maxlight;
//最小光照强度
@property (nonatomic, copy) NSString *minlight;

@end
