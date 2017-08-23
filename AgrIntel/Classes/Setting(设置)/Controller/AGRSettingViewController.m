//
//  AGRSettingViewController.m
//  AgrIntel
//
//  Created by 实验室 on 2017/6/1.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import "AGRSettingViewController.h"
#import "AGRLimit.h"
#import "AFNetworking.h"
#import "MJExtension.h"

@interface AGRSettingViewController ()

//数据
@property (nonatomic, strong) NSDictionary *data;

//@property (nonatomic, strong) NSArray *limit;
//@property (nonatomic, strong) NSString *maxtem;

@property (weak, nonatomic) IBOutlet UITextField *maxtemText;
@property (weak, nonatomic) IBOutlet UITextField *mintemText;
@property (weak, nonatomic) IBOutlet UITextField *maxhumText;
@property (weak, nonatomic) IBOutlet UITextField *minhumText;
@property (weak, nonatomic) IBOutlet UITextField *maxlightText;
@property (weak, nonatomic) IBOutlet UITextField *minlightText;
- (IBAction)submitBtn:(UIButton *)sender;

@end

@implementation AGRSettingViewController

+(instancetype)AGRSettingViewController
{
    return [[[NSBundle mainBundle] loadNibNamed:@"AGRSettingViewController" owner:nil options:nil] lastObject];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景色
    self.view.backgroundColor = AGRGlobalBg;
    
    //设置导航栏左侧logo
    [self setupLeftLogo];
    
    NSMutableDictionary *Limit = [NSMutableDictionary dictionary];
    Limit[@"limit"] = @"1";
    
    [[AFHTTPSessionManager manager]GET:@"http://www.orient-zy.cn/api/test.php" parameters:Limit progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        NSLog(@"原始数据：%@",responseObject);

        self.data = responseObject[@"data"][0];
//        NSLog(@"数据:%@",self.data[@"maxtem"]);
        [self setTextFieldTitle:self.data];
        //字典->模型
//        self.data = [AGRLimit mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        
    }];
    
}

-(void)setTextFieldTitle:(NSDictionary*)data
{
    self.maxtemText.placeholder = [NSString stringWithFormat:@"%@", data[@"maxtem"]];
    self.mintemText.placeholder = [NSString stringWithFormat:@"%@", data[@"mintem"]];
    self.maxhumText.placeholder = [NSString stringWithFormat:@"%@", data[@"maxhum"]];
    self.minhumText.placeholder = [NSString stringWithFormat:@"%@", data[@"minhum"]];
    self.maxlightText.placeholder = [NSString stringWithFormat:@"%@", data[@"maxlight"]];
    self.minlightText.placeholder = [NSString stringWithFormat:@"%@", data[@"minlight"]];
}

//- (IBAction)submitBtn:(UIButton *)sender
//{
//    NSString *a = self.maxtemText.text;
//    NSLog(@"%@",a);
//}


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
- (IBAction)submitBtn:(UIButton *)sender
{
    NSString *a = self.maxtemText.text;
    NSLog(@"%@",a);
    
}
@end
