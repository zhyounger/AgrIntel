//
//  AGRTabBarController.m
//  AgrIntel
//
//  Created by 实验室 on 2017/6/1.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import "AGRTabBarController.h"
#import "AGRNavigationController.h"
#import "AGRTabBar.h"
#import "AGRDateViewController.h"
#import "AGRMessageViewController.h"
#import "AGRSettingViewController.h"

@interface AGRTabBarController ()

@end

@implementation AGRTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UINavigationBar appearance];
    
    //通过appearance统一设置所有UITabBarItem的文字属性
    //后面带有UI_APPEARANCE_SELECTOR的方法，都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    //添加子控制器
    [self setUpChildVc:[[AGRDateViewController alloc] init] title:@"首页" image:@"tabBar_home" selectedImage:@"tabBar_home_selected"];
    
    [self setUpChildVc:[[AGRMessageViewController alloc] init] title:@"消息" image:@"tabBar_message" selectedImage:@"tabBar_message_selected"];
    
    [self setUpChildVc:[[AGRSettingViewController alloc] init] title:@"设置" image:@"tabBar_setting" selectedImage:@"tabBar_setting_selected"];
    
    //更换tabBar
    //self.tabBar = [[AGRTabBar alloc] init];
    [self setValue:[[AGRTabBar alloc]init] forKeyPath:@"tabBar"];
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@""]];

}

#pragma 初始化子控制器
- (void)setUpChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    //设置文字和图片
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    //包装一个导航控制器，添加其为tabBarController的子控制器
    AGRNavigationController *nav = [[AGRNavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
