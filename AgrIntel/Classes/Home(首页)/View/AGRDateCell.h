//
//  AGRDateCell.h
//  AgrIntel
//
//  Created by 实验室 on 2017/8/18.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AGRDate;

@interface AGRDateCell : UITableViewCell
//加载xib
+(instancetype)AGRDateCell;
//类别模型
@property (nonatomic, strong) AGRDate *text;

@end
