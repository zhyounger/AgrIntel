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
#import "SDImageCache.h"

@interface AGRSettingViewController ()<UITextFieldDelegate>

//数据
@property (nonatomic, strong) NSDictionary *data;

//输入最大温度
@property (weak, nonatomic) IBOutlet UITextField *maxtemText;
//输入最小温度
@property (weak, nonatomic) IBOutlet UITextField *mintemText;
//输入最大湿度
@property (weak, nonatomic) IBOutlet UITextField *maxhumText;
//输入最小湿度
@property (weak, nonatomic) IBOutlet UITextField *minhumText;
//输入最大光照强度
@property (weak, nonatomic) IBOutlet UITextField *maxlightText;
//输入最小光照强度
@property (weak, nonatomic) IBOutlet UITextField *minlightText;
//提交按钮
- (IBAction)submitBtn:(UIButton *)sender;
//清除缓存按钮
- (IBAction)clearBufferBtn:(UIButton *)sender;

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
    
    //获取json数据
    [self getJson];
    
    //设置textField的属性
    [self setTextField];
}

#pragma 设置textField的属性
- (void)setTextField
{
    //textField内的清除按钮
    self.maxtemText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.mintemText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.maxhumText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.minhumText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.maxlightText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.minlightText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //textField默认显示数字键盘
    self.maxtemText.keyboardType = UIKeyboardTypeDecimalPad;
    self.mintemText.keyboardType = UIKeyboardTypeDecimalPad;
    self.maxhumText.keyboardType = UIKeyboardTypeDecimalPad;
    self.minhumText.keyboardType = UIKeyboardTypeDecimalPad;
    self.maxlightText.keyboardType = UIKeyboardTypeDecimalPad;
    self.minlightText.keyboardType = UIKeyboardTypeDecimalPad;
}

#pragma 获取json数据
- (void)getJson
{
    self.maxtemText.text = [NSString stringWithFormat:@""];
    self.mintemText.text = [NSString stringWithFormat:@""];
    self.maxhumText.text = [NSString stringWithFormat:@""];
    self.minhumText.text = [NSString stringWithFormat:@""];
    self.maxlightText.text = [NSString stringWithFormat:@""];
    self.minlightText.text = [NSString stringWithFormat:@""];
    
    NSMutableDictionary *Limit = [NSMutableDictionary dictionary];
    Limit[@"limit"] = @"1";
    
    [[AFHTTPSessionManager manager]GET:AGRGETURL parameters:Limit progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
//        NSLog(@"原始数据：%@",responseObject);
        
        self.data = responseObject[@"data"][0];
//        NSLog(@"数据:%@",self.data[@"maxtem"]);
        
        [self setTextFieldTitle:self.data];
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        
    }];
}

#pragma 设置文字输入框的默认文字
-(void)setTextFieldTitle:(NSDictionary*)data
{
    self.maxtemText.placeholder = [NSString stringWithFormat:@"%@", data[@"maxtem"]];
    self.mintemText.placeholder = [NSString stringWithFormat:@"%@", data[@"mintem"]];
    self.maxhumText.placeholder = [NSString stringWithFormat:@"%@", data[@"maxhum"]];
    self.minhumText.placeholder = [NSString stringWithFormat:@"%@", data[@"minhum"]];
    self.maxlightText.placeholder = [NSString stringWithFormat:@"%@", data[@"maxlight"]];
    self.minlightText.placeholder = [NSString stringWithFormat:@"%@", data[@"minlight"]];
}

#pragma 提交按钮的点击
- (IBAction)submitBtn:(UIButton *)sender
{
//    NSString *maxtem = self.maxtemText.text;
//    NSString *mintem = self.mintemText.text;
//    NSString *maxhum = self.maxhumText.text;
//    NSString *minhum = self.minhumText.text;
//    NSString *maxlight = self.maxlightText.text;
//    NSString *minlight = self.minlightText.text;
//    
    NSMutableDictionary *set = [NSMutableDictionary dictionary];
//    set[@"maxtem"] = maxtem;
//    set[@"mintem"] = mintem;
//    set[@"maxhum"] = maxhum;
//    set[@"minhum"] = minhum;
//    set[@"maxlight"] = maxlight;
//    set[@"minlight"] = minlight;
//    NSLog(@"%@",set);
    

    if (_maxtemText.text.length == 0) {
        set[@"maxtem"] = self.maxtemText.placeholder;
    } else {
        set[@"maxtem"] =self.maxtemText.text;
    }
    
    if (_mintemText.text.length == 0) {
        set[@"mintem"] = self.mintemText.placeholder;
    } else {
        set[@"mintem"] =self.mintemText.text;
    }
    
    
    if (_maxhumText.text.length == 0) {
        set[@"maxhum"] = self.maxhumText.placeholder;
    } else {
        set[@"maxhum"] =self.maxhumText.text;
    }
    
    
    if (_minhumText.text.length == 0) {
        set[@"minhum"] = self.minhumText.placeholder;
    } else {
        set[@"minhum"] =self.minhumText.text;
    }
    
    
    if (_maxlightText.text.length == 0) {
        set[@"maxlight"] = self.maxlightText.placeholder;
    } else {
        set[@"maxlight"] =self.maxlightText.text;
    }
    
    
    if (_minlightText.text.length == 0) {
        set[@"minlight"] = self.minlightText.placeholder;
    } else {
        set[@"minlight"] =self.minlightText.text;
    }
    
//    //打印用户set的值
//    NSLog(@"set的值:%@", set);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/json"];
    
    //接口地址
    NSString *url=AGRSETURL;
    
    //发送请求
    [manager POST:url parameters:set progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"数据提交成功!" iconImage:[UIImage imageNamed:@""]];
        toast.toastType = FFToastTypeSuccess;
        toast.toastPosition = FFToastPositionCentre;
        toast.duration = 1.5;
        [toast show];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"数据提交失败!" iconImage:[UIImage imageNamed:@""]];
        toast.toastType = FFToastTypeError;
        toast.toastPosition = FFToastPositionCentre;
        toast.duration = 1.5;
        [toast show];
    }];
    
    //页面延时上传
    [NSThread sleepForTimeInterval:0.5f];
    
    [self getJson];
}

#pragma 清除缓存按钮的点击
- (IBAction)clearBufferBtn:(UIButton *)sender
{
    [[SDImageCache sharedImageCache] clearMemory];
    
    FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"成功清除缓存!" iconImage:nil];
    toast.toastType = FFToastTypeDefault;
    toast.toastPosition = FFToastPositionBottomWithFillet;
    [toast show];
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

#pragma 点击收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
