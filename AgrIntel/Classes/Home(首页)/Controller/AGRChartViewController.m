//
//  AGRChartViewController.m
//  AgrIntel
//
//  Created by 实验室 on 2017/9/5.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import "AGRChartViewController.h"
#import "AGRChartChildViewController.h"
#import "LYSChartAloneLine.h"

@interface AGRChartViewController ()<UIScrollViewDelegate>

//标签栏的底部红色指示器
@property (nonatomic,weak)UIView *indicatorView;
//当前选中的按钮
@property (nonatomic,weak)UIButton *selectedButton;
//顶部的所有标签
@property (nonatomic,weak)UIView *titlesView;
//底部的所有内容
@property (nonatomic,weak)UIScrollView *contentView;
//温度统计图
@property (nonatomic,strong)LYSChartAloneLine *temLine;

@end

@implementation AGRChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setupNav];
    
    //初始化子控制器
    [self setupChildVces];
    
    //设置顶部标签栏
    [self setupTitlesView];
    
    //底部的scrollView
    [self setupContentView];
    
}

#pragma 初始化子控制器
-(void)setupChildVces
{
    AGRChartChildViewController *child1 = [[AGRChartChildViewController alloc]init];
    child1.sensor = @"1";
    child1.day = self.day;
    [self addChildViewController:child1];
    
    AGRChartChildViewController *child2 = [[AGRChartChildViewController alloc]init];
    child2.sensor = @"2";
    child2.day = self.day;
    [self addChildViewController:child2];
}

#pragma 设置导航栏
-(void)setupNav
{
    //设置背景色
    self.view.backgroundColor = AGRGlobalBg;
    
    //设置导航栏标题
    self.navigationItem.title = @"近十次数据统计图";
}

#pragma 设置顶部标签栏
-(void)setupTitlesView
{
    //标签栏整体
    UIView *titlesView = [[UIView alloc]init];
    titlesView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    titlesView.width = self.view.width;
    titlesView.height = AGRTitlesViewH;
    titlesView.y = AGRTitlesViewY;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    //底部的红色指示器
    UIView *indicatorView = [[UIView alloc]init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.height = 2;
    indicatorView.tag = -1;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    
    //内部的子标签
    NSArray *titles = @[@"传感器1",@"传感器2"];
    CGFloat width = titlesView.width / titles.count;
    CGFloat height = titlesView.height;
    for (NSInteger i = 0; i<titles.count; i++) {
        UIButton *button = [[UIButton alloc]init];
        button.tag = i;
        button.height = height;
        button.width = width;
        button.x = i * width;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        
        //默认点击了第一个按钮
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;
            
            //让按钮内部的label根据文字的内容来计算尺寸
            [button.titleLabel sizeToFit];
            self.indicatorView.width = button.titleLabel.width;
            self.indicatorView.centerX = button.centerX;
        }
    }
    [titlesView addSubview:indicatorView];
}

#pragma 点击标签栏
-(void)titleClick:(UIButton *)button
{
    //修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    //动画
    [UIView animateWithDuration:0.3 animations:^{
        self.indicatorView.width = button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
    }];
    
    //滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
    
}

#pragma 设置底部的scrollView
-(void)setupContentView
{
    //不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc]init];
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    self.contentView = contentView;
    
    //添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}

#pragma - <UIScrollViewDelegate>
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    //取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0; //设置控制器view的y值为0(默认为20)
    vc.view.height = scrollView.height; //设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少20)
    
    [scrollView addSubview:vc.view];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    //点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titlesView.subviews[index]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
