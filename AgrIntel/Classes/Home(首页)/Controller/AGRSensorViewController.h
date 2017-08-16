//
//  AGRSensorViewController.h
//  AgrIntel
//
//  Created by 实验室 on 2017/7/20.
//  Copyright © 2017年 实验室. All rights reserved.
//  最基本的传感器控制器

#import <UIKit/UIKit.h>

typedef enum {
    AGRSensorId1 = 13,
    AGRSensorId2 = 14,
    AGRSensorId3 = 13,
    AGRSensorId4 = 13,
    AGRSensorId5 = 13
}AGRSensorId;

@interface AGRSensorViewController : UITableViewController

//传感器选择(交给子类去实现)
@property (nonatomic, assign) AGRSensorId id;

@end
