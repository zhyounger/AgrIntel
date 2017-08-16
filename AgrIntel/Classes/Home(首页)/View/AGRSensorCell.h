//
//  AGRSensorCell.h
//  AgrIntel
//
//  Created by 实验室 on 2017/7/7.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AGRSensor;

@interface AGRSensorCell : UITableViewCell
//加载xib
+(instancetype)AGRSensorCell;
//类别模型
@property (nonatomic, strong) AGRSensor *text;

@end
