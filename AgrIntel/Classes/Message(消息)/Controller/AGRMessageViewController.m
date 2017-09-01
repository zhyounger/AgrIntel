//
//  AGRMessageViewController.m
//  AgrIntel
//
//  Created by 实验室 on 2017/8/26.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import "AGRMessageViewController.h"
#import "AGRDetailViewController.h"
#import "AGRMessage.h"
#import "AGRMessageCell.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "CDPSearchController.h"

@interface AGRMessageViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate>
{
    CDPSearchController *_searchController;
}
//数据
@property (nonatomic, strong) NSArray *data;

@end

@implementation AGRMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景色
    self.view.backgroundColor = AGRGlobalBg;
    
    //设置导航栏标题
    self.navigationItem.title = @"异常数据报告";
    
    //设置导航栏左侧logo
    [self setupLeftLogo];
    
    //设置导航栏右侧搜索按钮
    [self setupRightBtn];
    
    //初始化表格
    [self setupTableView];
    
    //添加刷新控件
    [self setupRefresh];
}

#pragma 初始化表格
- (void)setupTableView
{
    //设置内边距
    CGFloat bottom = self.tabBarController.tabBar.height;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, bottom, 0);
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
    NSMutableDictionary *msg = [NSMutableDictionary dictionary];
    msg[@"compare"] = @"1";
    [[AFHTTPSessionManager manager]GET:@"http://115.159.120.50/AgrIntel/api/test.php" parameters:msg progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        ////得到plist文件
        //[responseObject writeToFile:@"/Users/shiyanshi/Desktop/test1.plist" atomically:YES];
//        NSLog(@"%@",responseObject);
        
        //字典->模型
        self.data = [AGRMessage mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
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

#pragma 导航栏右侧搜索按钮
- (void)setupRightBtn
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchClick)];
}

#pragma 搜索按钮点击
-(void)searchClick{
    //设置需要搜索的参数名数组,本demo根据CDPSearchModel中的nameStr和phoneStr这两个参数搜索,即姓名和电话
    //parameterArr里的参数名必须和model里的参数名一样，否则出错
    NSArray *parameterArr=@[@"time",@"sensor"];
    
    //初始化并设置CDPSearchController
    _searchController = [[CDPSearchController alloc] initWithController:self dataArr:_data prompt:@"搜索" placeholder:@"搜索时间或传感器" parameterArr:parameterArr];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return _data.count;
    return (tableView == self.tableView ? _data.count : _searchController.searchResultArr.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //定义重用标识
    static NSString *messageId = @"messageID";
    
    //先用cell的标识去缓存池中查找可循环利用的cell
    AGRMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:messageId];
    
    //如果cell为nil（缓存池中找不到对应的cell）则创建一个带标识的cell
    if (cell == nil) {
        cell = [AGRMessageCell AGRMessageCell];
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
    
//    //判断是否搜索tableView
//    AGRMessage *model = (tableView == self.tableView?[_data objectAtIndex:indexPath.row]:[_searchController.searchResultArr objectAtIndex:indexPath.row]);
//    cell.textLabel.text = [NSString stringWithFormat:@"时间:%@",model.time];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"传感器:%@",model.sensor];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //得到点击的cell
    AGRMessage *d = self.data[indexPath.row];
    //创建点击后弹出的视图控制器
    AGRDetailViewController *detail = [[AGRDetailViewController alloc]init];
    detail.navigationItem.title = @"异常数据细节";
    //传值
    detail.time = d.time;
    detail.imgurl = d.imgurl;
    detail.sensor = d.sensor;
    detail.tem = d.tem;
    detail.hum = d.hum;
    detail.light = d.light;
    detail.maxtem = d.maxtem;
    detail.mintem = d.mintem;
    detail.maxhum = d.maxhum;
    detail.minhum = d.minhum;
    detail.maxlight = d.maxlight;
    detail.minlight = d.minlight;
    
    [self.navigationController pushViewController:detail animated:YES];
}

@end
