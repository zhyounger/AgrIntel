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
#import "FFToast.h"


@interface AGRChartChildViewController ()<UIScrollViewDelegate>
//数据
@property (nonatomic, strong) NSArray *timeArr;
@property (nonatomic, strong) NSArray *temArr;
@property (nonatomic, strong) NSArray *humArr;
@property (nonatomic, strong) NSArray *lightArr;

@property (nonatomic, assign) NSInteger dataCount;

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
}

#pragma 添加Label
- (void)addLabels
{
    //创建label
    UILabel *temLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 200, 20)];
    UILabel *humLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 400, 200, 20)];
    UILabel *lightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 700, 200, 20)];
    //label内容
    temLabel.text = @"温度(℃):";
    humLabel.text = @"湿度(%RH):";
    lightLabel.text = @"光照强度(Lx):";
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
    _dataCount = 10;
    
    //参数
    NSMutableDictionary *ID = [NSMutableDictionary dictionary];
    ID[@"get_day"] = @"1";
    ID[@"day"] = self.day;
    ID[@"sensor"] = self.sensor;

    [[AFHTTPSessionManager manager]GET:AGRGETURL parameters:ID progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        //返回字典
        NSArray *data = responseObject[@"data"];

        //创建数组
        NSMutableArray *arr1 = [[NSMutableArray alloc]initWithCapacity:10];
        NSMutableArray *arr2 = [[NSMutableArray alloc]initWithCapacity:10];
        NSMutableArray *arr3 = [[NSMutableArray alloc]initWithCapacity:10];
        NSMutableArray *arr4 = [[NSMutableArray alloc]initWithCapacity:10];
        
        if (data.count < 10) {
            
//            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"数据太少了!" iconImage:[UIImage imageNamed:@""]];
//            toast.toastType = FFToastTypeError;
//            toast.toastPosition = FFToastPositionCentre;
//            toast.duration = 1.5;
//            [toast show];
            
            for (int i = 0; i < data.count; i++) {
//                _dataCount = data.count;
  
                NSString *originStr = [data[i][@"time"] substringWithRange:NSMakeRange(11, 5)];//日期格式化类
                //创建日期格式
                NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
                //设置日期格式
                fmt.dateFormat = @"HH-mm";
                //传感器创建数据的时间
                NSDate *create = [fmt dateFromString:originStr];
                //日期赋值
                fmt.dateFormat = @"HH:mm";
                NSString *timeStr = [fmt stringFromDate:create];
                
                [arr1 addObject:timeStr];
                [arr2 addObject:data[i][@"tem"]];
                [arr3 addObject:data[i][@"hum"]];
                [arr4 addObject:data[i][@"light"]];
            }
            
//            for (int i = 0; i < 10 - _dataCount; i++) {
//                [arr1 addObject:@"--:--"];
//                [arr2 addObject:@"0"];
//                [arr3 addObject:@"0"];
//                [arr4 addObject:@"0"];
//            }
            NSLog(@"%@", arr1);
        }else{
            for (int i = 0; i < 10; i++) {
                
                NSString *originStr = [data[i][@"time"] substringWithRange:NSMakeRange(11, 5)];//日期格式化类
                //创建日期格式
                NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
                //设置日期格式
                fmt.dateFormat = @"HH-mm";
                //传感器创建数据的时间
                NSDate *create = [fmt dateFromString:originStr];
                //日期赋值
                fmt.dateFormat = @"HH:mm";
                NSString *timeStr = [fmt stringFromDate:create];
                
                [arr1 addObject:timeStr];
                [arr2 addObject:data[i][@"tem"]];
                [arr3 addObject:data[i][@"hum"]];
                [arr4 addObject:data[i][@"light"]];
            }
        }
        
        //倒序排列
        _timeArr = [[arr1 reverseObjectEnumerator] allObjects];
        _temArr = [[arr2 reverseObjectEnumerator] allObjects];
        _humArr = [[arr3 reverseObjectEnumerator] allObjects];
        _lightArr = [[arr4 reverseObjectEnumerator] allObjects];
        
        //温度统计图
        [self setupTemLine:(_dataCount)];
        //湿度统计图
        [self setupHumLine:(_dataCount)];
        //光照强度统计图
        [self setupLightLine:(_dataCount)];
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        
    }];
}

#pragma 温度统计图
-(void)setupTemLine:(NSInteger )temCount
{
    //创建折线图
    _temLine = [[LYSChartAloneLine alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 250)];
    _temLine.row = 6;
    _temLine.column = temCount;
    //是否曲线
    _temLine.isCurve = NO;
    //是否显示阈值线
    _temLine.isShowBenchmarkLine = NO;
    //是否是百分比
    _temLine.isPercent = NO;
    [_temLine reloadData];
    [self.view addSubview:_temLine];
}

#pragma 湿度统计图
-(void)setupHumLine:(NSInteger )humCount
{
    //创建折线图
    _humLine = [[LYSChartAloneLine alloc] initWithFrame:CGRectMake(0, 420, self.view.frame.size.width, 250)];
    _humLine.row = 6;
    _humLine.column = humCount;
    //是否曲线
    _humLine.isCurve = NO;
    //是否显示阈值线
    _humLine.isShowBenchmarkLine = NO;
    //是否是百分比
    _humLine.isPercent = NO;
    [_humLine reloadData];
    [self.view addSubview:_humLine];
}

#pragma 光照强度统计图
-(void)setupLightLine:(NSInteger )lightCount
{
    //创建折线图
    _lightLine = [[LYSChartAloneLine alloc] initWithFrame:CGRectMake(0, 720, self.view.frame.size.width, 250)];
    _lightLine.row = 6;
    _lightLine.column = lightCount;
    //是否曲线
    _lightLine.isCurve = NO;
    //是否显示阈值线
    _lightLine.isShowBenchmarkLine = NO;
    //是否是百分比
    _lightLine.isPercent = NO;
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
    _humLine.rowData = @[@"0", @"20", @"40", @"60", @"80", @"100"];
    
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
