//
//  UIBarButtonItem+AGRExtension.h
//  AgrIntel
//
//  Created by 实验室 on 2017/6/1.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (AGRExtension)

+(instancetype) itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end
