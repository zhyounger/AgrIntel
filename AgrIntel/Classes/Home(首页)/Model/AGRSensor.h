//
//  AGRSensor.h
//  AgrIntel
//
//  Created by 实验室 on 2017/7/10.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGRSensor : NSObject
//id
@property (nonatomic, copy) NSString *id;
//图片
@property (nonatomic, copy) NSString *img_url;
//时间
@property (nonatomic, copy) NSString *time;
//温度
@property (nonatomic, copy) NSString *tem;
//湿度
@property (nonatomic, copy) NSString *hum;
//光照强度
@property (nonatomic, copy) NSString *light;

@end
