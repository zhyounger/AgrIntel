//
//  AGRSensorViewController.m
//  AgrIntel
//
//  Created by 实验室 on 2017/7/11.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import "AGRSensorViewController.h"
#import "AGRSensor.h"
#import "AGRSensorCell.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "MJRefresh.h"

@interface AGRSensorViewController ()<UITableViewDataSource, UITableViewDelegate>

//数据
@property (nonatomic, strong) NSArray *data;

@end

@implementation AGRSensorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化表格
    [self setupTableView];
    
    //添加刷新控件
    [self setupRefresh];
}

#pragma 初始化表格
-(void)setupTableView
{
    //设置内边距
    CGFloat bottom = self.tabBarController.tabBar.height;
    CGFloat top = AGRTitlesViewY + AGRTitlesViewH;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    //设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.backgroundColor = [UIColor clearColor];
    //隐藏表格分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma 刷新控件
-(void)setupRefresh
{
    //上拉设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    //自定义文字
    [header setTitle:@"继续下拉刷新！" forState:MJRefreshStateIdle];
    [header setTitle:@"数据要来啦！" forState:MJRefreshStatePulling];
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    //根据拖拽比例自动切换透明度
    header.automaticallyChangeAlpha = YES;
    //开始刷新
    [header beginRefreshing];
    //设置上拉刷新控件
    self.tableView.mj_header = header;
    
    //下拉设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //自定义文字
    [footer setTitle:@"点击或上拉加载更多！" forState:MJRefreshStateIdle];
    [footer setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据啦！" forState:MJRefreshStateNoMoreData];
    //设置下拉刷新控件
    self.tableView.mj_footer = footer;
}

#pragma 加载新数据
-(void)loadNewData
{
    //结束上拉
    [self.tableView.mj_footer endRefreshing];
    
    //参数
    NSMutableDictionary *ID = [NSMutableDictionary dictionary];
    ID[@"get_day"] = @"1";
    ID[@"day"] = self.day;
    ID[@"sensor"] = self.sensor;
    [[AFHTTPSessionManager manager]GET:AGRGETURL parameters:ID progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        ////得到plist文件
        //[responseObject writeToFile:@"/Users/shiyanshi/Desktop/test1.plist" atomically:YES];
        //NSLog(@"%@",responseObject);
        
        //字典->模型
        self.data = [AGRSensor mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        
    }];
}

#pragma 加载更多数据
-(void)loadMoreData
{
    //结束下拉
    [self.tableView.mj_header endRefreshing];
    
    //结束刷新并显示没有更多数据
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //定义重用标识
    static NSString *textId = @"textID";
    
    //先用cell的标识去缓存池中查找可循环利用的cell
    AGRSensorCell *cell = [tableView dequeueReusableCellWithIdentifier:textId];
    
    //如果cell为nil（缓存池中找不到对应的cell）则创建一个带标识的cell
    if (cell == nil) {
        cell = [AGRSensorCell AGRSensorCell];
    }
    
    //覆盖数据
    cell.text = self.data[indexPath.row];
    
    //cell阴影
    cell.layer.shadowOffset =CGSizeMake(0, 0);
    cell.layer.shadowColor = [UIColor grayColor].CGColor;
    cell.layer.shadowOpacity = .5f;
    cell.layer.shadowRadius = 5;
    //cell圆角
    cell.layer.cornerRadius = 15;
    cell.layer.masksToBounds = NO;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 155;
}

@end
