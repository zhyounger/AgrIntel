//
//  UIBarButtonItem+AGRExtension.m
//  AgrIntel
//
//  Created by 实验室 on 2017/6/1.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import "UIBarButtonItem+AGRExtension.h"

@implementation UIBarButtonItem (AGRExtension)

+(instancetype) itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc]initWithCustomView:button];
    
}

@end
