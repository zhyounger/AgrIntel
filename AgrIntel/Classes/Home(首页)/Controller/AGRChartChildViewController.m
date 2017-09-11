//
//  AGRChartChildViewController.m
//  AgrIntel
//
//  Created by 实验室 on 2017/9/7.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import "AGRChartChildViewController.h"
#import "LYSChartAloneLine.h"
#import "AFNetworking.h"

@interface AGRChartChildViewController ()<UIScrollViewDelegate>

//数据
@property (nonatomic, strong) NSArray *timeArr;
@property (nonatomic, strong) NSArray *temArr;
@property (nonatomic, strong) NSArray *humArr;
@property (nonatomic, strong) NSArray *lightArr;

//温度统计图
@property (nonatomic,strong)LYSChartAloneLine *temLine;
//湿度统计图
@property (nonatomic,strong)LYSChartAloneLine *humLine;
//光照强度统计图
@property (nonatomic,strong)LYSChartAloneLine *lightLine;

@end

@implementation AGRChartChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加Label
    [self addLabels];
    
    //获取数据
    [self getData];
    
    //温度统计图
    [self setupTemLine];
    
    //湿度统计图
    [self setupHumLine];
    
    //光照强度统计图
    [self setupLightLine];
}

#pragma 添加Label
- (void)addLabels
{
    //创建label
    UILabel *temLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 200, 20)];
    UILabel *humLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 400, 200, 20)];
    UILabel *lightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 700, 200, 20)];
    //label内容
    temLabel.text = @"温度:";
    humLabel.text = @"湿度:";
    lightLabel.text = @"光照强度:";
    //label字体颜色
    temLabel.textColor = [UIColor darkGrayColor];
    humLabel.textColor = [UIColor darkGrayColor];
    lightLabel.textColor = [UIColor darkGrayColor];
    //添加label
    [self.view addSubview:temLabel];
    [self.view addSubview:humLabel];
    [self.view addSubview:lightLabel];
}

#pragma 获取数据
-(void)getData
{
    //参数
    NSMutableDictionary *ID = [NSMutableDictionary dictionary];
    ID[@"get_day"] = @"1";
    ID[@"day"] = self.day;
    ID[@"sensor"] = self.sensor;
    
    [[AFHTTPSessionManager manager]GET:@"http://115.159.120.50/AgrIntel/api/test.php" parameters:ID progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        //返回字典
        NSArray *data = responseObject[@"data"];
        //创建数组
        NSMutableArray *arr1 = [[NSMutableArray alloc]initWithCapacity:10];
        NSMutableArray *arr2 = [[NSMutableArray alloc]initWithCapacity:10];
        NSMutableArray *arr3 = [[NSMutableArray alloc]initWithCapacity:10];
        NSMutableArray *arr4 = [[NSMutableArray alloc]initWithCapacity:10];
        
        for (int i = 0; i < 10; i++) {
            
            NSString *str1 = [data[i][@"time"] substringWithRange:NSMakeRange(11, 5)];
            [arr1 addObject:str1];
            [arr2 addObject:data[i][@"tem"]];
            [arr3 addObject:data[i][@"hum"]];
            [arr4 addObject:data[i][@"light"]];
        }
        
        _timeArr = [[arr1 reverseObjectEnumerator] allObjects];
        _temArr = [[arr2 reverseObjectEnumerator] allObjects];
        _humArr = [[arr3 reverseObjectEnumerator] allObjects];
        _lightArr = [[arr4 reverseObjectEnumerator] allObjects];
        
        NSLog(@"%@-------%@", _timeArr, arr1);
        NSLog(@"%@-------%@", _temArr, arr2);
        NSLog(@"%@-------%@", _humArr, arr3);
        NSLog(@"%@-------%@", _lightArr, arr4);
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        
    }];
}

#pragma 温度统计图
-(void)setupTemLine
{
    //创建折线图
    _temLine = [[LYSChartAloneLine alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 250)];
    _temLine.row = 6;
    _temLine.column = 10;
    //是否曲线
    _temLine.isCurve = YES;
    //是否显示阈值线
    _temLine.isShowBenchmarkLine = NO;
    //是否是百分比
    _temLine.isPercent = NO;
    [_temLine reloadData];
    [self.view addSubview:_temLine];
}

#pragma 湿度统计图
-(void)setupHumLine
{
    //创建折线图
    _humLine = [[LYSChartAloneLine alloc] initWithFrame:CGRectMake(0, 420, self.view.frame.size.width, 250)];
    _humLine.row = 5;
    _humLine.column = 10;
    //是否曲线
    _humLine.isCurve = YES;
    //是否显示阈值线
    _humLine.isShowBenchmarkLine = NO;
    //是否是百分比
    _humLine.isPercent = NO;
//    //阈值线样式
//    _humLine.benchmarkLineStyle.benchmarkValue = @0.5;
    [_humLine reloadData];
    [self.view addSubview:_humLine];
}

#pragma 光照强度统计图
-(void)setupLightLine
{
    //创建折线图
    _lightLine = [[LYSChartAloneLine alloc] initWithFrame:CGRectMake(0, 720, self.view.frame.size.width, 250)];
    _lightLine.row = 6;
    _lightLine.column = 10;
    //是否曲线
    _lightLine.isCurve = YES;
    //是否显示阈值线
    _lightLine.isShowBenchmarkLine = NO;
    //是否是百分比
    _lightLine.isPercent = NO;
//    //阈值线样式
//    _lightLine.benchmarkLineStyle.benchmarkValue = @0.5;
    [_lightLine reloadData];
    [self.view addSubview:_lightLine];
}

#pragma 点击显示数据
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _temLine.valueData = _temArr;
    _temLine.columnData = _timeArr;
    _temLine.rowData = @[@"0", @"10", @"20", @"30", @"40", @"50"];
    
    _humLine.valueData = _humArr;
    _humLine.columnData = _timeArr;
    _humLine.rowData = @[@"0", @"25", @"50", @"75", @"100"];
    
    _lightLine.valueData = _lightArr;
    _lightLine.columnData = _timeArr;
    _lightLine.rowData = @[@"0", @"200", @"400", @"600", @"800", @"1000"];
    
    [_temLine reloadData];
    [_humLine reloadData];
    [_lightLine reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
