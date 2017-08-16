//
//  AGRNavigationController.m
//  AgrIntel
//
//  Created by 实验室 on 2017/6/1.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import "AGRNavigationController.h"

@interface AGRNavigationController ()

@end

@implementation AGRNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_backgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}

#pragma 拦截所有push进来的控制器
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {//如果push进来的不是第一个控制器
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        
        [button setImage:[UIImage imageNamed:@"nav_returnButton"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"nav_returnButtonClick"] forState:UIControlStateHighlighted];
        
        button.size = CGSizeMake(70, 30);
        //让按钮内部的所有内容左对齐
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //按钮内容向左偏移
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        
        //返回按钮的点击事件
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        //添加按钮
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        //隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    //这句super的push要放在后面，让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
    
}

-(void)back
{
    [self popViewControllerAnimated:YES];
}

@end
