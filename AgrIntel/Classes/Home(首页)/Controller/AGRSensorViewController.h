//
//  AGRSensorViewController.h
//  AgrIntel
//
//  Created by 实验室 on 2017/7/20.
//  Copyright © 2017年 实验室. All rights reserved.
//  最基本的传感器控制器

#import <UIKit/UIKit.h>

@interface AGRSensorViewController : UITableViewController

//传感器
@property (nonatomic, copy) NSString *sensor;
//日期
@property (nonatomic, copy) NSString *day;

@end
