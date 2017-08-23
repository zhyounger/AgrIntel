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
    
    self.navigationBar.tintColor = [UIColor blackColor];
}

#pragma 拦截所有push进来的控制器
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [super pushViewController:viewController animated:animated];
}

//-(void)back
//{
//    [self popViewControllerAnimated:YES];
//}

@end
