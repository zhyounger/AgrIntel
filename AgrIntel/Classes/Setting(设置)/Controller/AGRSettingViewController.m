//
//  AGRSettingViewController.m
//  AgrIntel
//
//  Created by 实验室 on 2017/6/1.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import "AGRSettingViewController.h"

@interface AGRSettingViewController ()

@end

@implementation AGRSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景色
    self.view.backgroundColor = AGRGlobalBg;
    
    //设置导航栏左侧logo
    [self setupLeftLogo];
}

#pragma 导航栏左侧logo
-(void)setupLeftLogo
{
    //创建logo
    UIView *leftLogo = [[UIView alloc] init];
    leftLogo.frame = CGRectMake(0.0, 0.0, 42.0, 40.0);
    
    //设置logo图片
    UIImageView *logoImg = [[UIImageView alloc] init];
    logoImg.image = [UIImage imageNamed:@"nav_leftLogo"];
    logoImg.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    logoImg.frame = leftLogo.frame;
    [leftLogo addSubview:logoImg];
    
    //实现logo拖拽
    logoImg.userInteractionEnabled = YES;
    [logoImg makeDraggable];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftLogo];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
