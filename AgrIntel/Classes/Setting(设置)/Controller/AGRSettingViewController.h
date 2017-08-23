//
//  AGRSettingViewController.h
//  AgrIntel
//
//  Created by 实验室 on 2017/6/1.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AGRLimit;

@interface AGRSettingViewController : UIViewController
//加载xib
+(instancetype)AGRSettingViewController;
//类别模型
@property (nonatomic, strong) AGRLimit *limits;

@end
