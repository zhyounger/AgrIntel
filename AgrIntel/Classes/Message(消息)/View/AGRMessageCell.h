//
//  AGRMessageCell.h
//  AgrIntel
//
//  Created by 实验室 on 2017/8/26.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AGRMessage;

@interface AGRMessageCell : UITableViewCell
//加载xib
+(instancetype)AGRMessageCell;
//类别模型
@property (nonatomic, strong) AGRMessage *text;

@end
