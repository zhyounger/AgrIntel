//
//  AGRDetailViewController.m
//  AgrIntel
//
//  Created by 实验室 on 2017/8/26.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import "AGRDetailViewController.h"
#import "AGRMessage.h"
#import "UIImageView+WebCache.h"

@interface AGRDetailViewController ()
//图片
@property (weak, nonatomic) IBOutlet UIImageView *imaImageView;
//卡片背景
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//传感器
@property (weak, nonatomic) IBOutlet UILabel *sensorLabel;
//温度
@property (weak, nonatomic) IBOutlet UILabel *temLabel;
//湿度
@property (weak, nonatomic) IBOutlet UILabel *humLabel;
//光照强度
@property (weak, nonatomic) IBOutlet UILabel *lightLabel;
//正常范围
@property (weak, nonatomic) IBOutlet UILabel *rangeLabel;
//建议
@property (weak, nonatomic) IBOutlet UILabel *suggestionLabel;

@end

@implementation AGRDetailViewController

+(instancetype)AGRDetailViewController
{
    return [[[NSBundle mainBundle] loadNibNamed:@"AGRDetailViewController" owner:nil options:nil] lastObject];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //卡片背景色
    self.backgroundView.backgroundColor = AGRGlobalBg;
    //卡片阴影
    self.backgroundView.layer.shadowOffset =CGSizeMake(0, 0);
    self.backgroundView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.backgroundView.layer.shadowOpacity = .5f;
    self.backgroundView.layer.shadowRadius = 5;
    //卡片圆角
    self.backgroundView.layer.cornerRadius = 20;
    self.backgroundView.layer.masksToBounds = NO;
    
    //设置图片
    [self.imaImageView sd_setImageWithURL:[NSURL URLWithString:self.imgurl] placeholderImage:[UIImage imageNamed:@"cell_loading"]];
    //图片圆角
    _imaImageView.layer.cornerRadius = 20;
    _imaImageView.layer.masksToBounds = YES;
    
    //日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    //设置日期格式
    fmt.dateFormat = @"yyyy-MM-dd-HH-mm";
    //传感器创建数据的时间
    NSDate *create = [fmt dateFromString:self.time];
    if (create.isThisYear) { //今年
        if (create.isToday) { //今天
            NSDateComponents *cmps = [[NSDate date]deltaFrom:create];
    
            if (cmps.hour >= 1) { //时间差距 >= 1小时
                self.timeLabel.text = [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            }else if (cmps.minute >= 1){ //1小时 > 时间差距 >= 1分钟
                self.timeLabel.text = [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            }else{ //1分钟 > 时间差距
                self.timeLabel.text = @"刚刚";
            }
        }else if (create.isYesterday){ //昨天
            fmt.dateFormat = @"昨天 HH:mm";
            self.timeLabel.text = [fmt stringFromDate:create];
        }else{ //其他
            fmt.dateFormat = @"MM月dd日 HH:mm";
            self.timeLabel.text = [fmt stringFromDate:create];
        }
    }else{ //非今年
        //显示正常格式的时间
        fmt.dateFormat = @"yyyy年MM月dd日 HH:mm";
        self.timeLabel.text = [fmt stringFromDate:create];
    }
    
    //传感器label
    self.sensorLabel.text = [NSString stringWithFormat:@"传感器%@", self.sensor];
    
    //温度、湿度、光照强度数据
    self.temLabel.text = [NSString stringWithFormat:@"%@ ℃", self.tem];
    self.humLabel.text = [NSString stringWithFormat:@"%@ %%RH", self.hum];
    self.lightLabel.text = [NSString stringWithFormat:@"%@ Lx", self.light];
    
    //设置当前温湿度和光照强度
    CGFloat nowTem = [self.tem integerValue];
    CGFloat nowHum = [self.hum integerValue];
    CGFloat nowLight = [self.light integerValue];
    
    //设置三类数据的最高值和最低值
    CGFloat maxTem = [self.maxtem intValue];
    CGFloat minTem = [self.mintem intValue];
    CGFloat maxHum = [self.maxhum intValue];
    CGFloat minHum = [self.minhum intValue];
    CGFloat maxLight = [self.maxlight intValue];
    CGFloat minLight = [self.minlight intValue];
    
    //设置数据差异
    CGFloat lessTem = minTem - nowTem;
    CGFloat moreTem = nowTem - maxTem;
    CGFloat lessHum = minHum - nowHum;
    CGFloat moreHum = nowHum - maxHum;
    CGFloat lessLight = minLight - nowLight;
    CGFloat moreLight = nowLight - maxLight;
    
    //判断温湿度和光照强度是否正常
    BOOL temIsNormal = (nowTem <= maxTem) && (nowTem >= minTem);
    BOOL humIsNormal = (nowHum <= maxHum) && (nowHum >= minHum);
    BOOL lightIsNormal = (nowLight <= maxLight) && (nowLight >= minLight);
    
    if (temIsNormal) {//如果温度正常
        self.temLabel.textColor = [UIColor darkGrayColor];
    }else {//如果温度异常
        self.temLabel.textColor = [UIColor redColor];
    }
    if (humIsNormal) {//如果湿度正常
        self.humLabel.textColor = [UIColor darkGrayColor];
    }else {//如果湿度异常
        self.humLabel.textColor = [UIColor redColor];
    }
    if (lightIsNormal) {//如果光照强度正常
        self.lightLabel.textColor = [UIColor darkGrayColor];
    }else {//如果光照强度异常
        self.lightLabel.textColor = [UIColor redColor];
    }
    
    //范围label
    self.rangeLabel.text = [NSString stringWithFormat:@"温度正常范围:%@℃ ~ %@℃\n湿度正常范围:%@%%RH ~ %@%%RH\n光照强度范围:%@Lx ~ %@Lx", self.mintem, self.maxtem, self.minhum, self.maxhum, self.minlight, self.maxlight];
    
    //建议label
    if (nowTem < minTem) {
        if (nowHum < minHum) {
            if (nowLight < minLight) {//温度过低，湿度过低，光照强度过低
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境温度低于正常范围%.1f℃,环境湿度低于正常范围%.1f%%RH,光照强度低于正常范围%.1fLx。\n经判断作物处于干冷、阴暗的环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过增加大棚覆盖物、覆盖双层膜、挖防寒沟、增加棚内热源等方法提高环境温度;\n通过增加灌水量、增加灌水次数、采用细雾加湿等方法提高环境湿度;\n通过清洁棚膜、覆盖地膜、在弱光处设置反光膜、在棚内安装白炽灯等方法提高光照强度。", lessTem, lessHum, lessLight];
            }else if (nowLight > maxLight) {//温度过低，湿度过低，光照强度过高
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境温度低于正常范围%.1f℃,环境湿度低于正常范围%.1f%%RH,光照强度高于正常范围%.1fLx。\n经判断作物处于干冷、光照过强的环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过增加大棚覆盖物、覆盖双层膜、挖防寒沟、增加棚内热源等方法提高环境温度;\n通过增加灌水量、增加灌水次数、采用细雾加湿等方法提高环境湿度;\n通过在棚顶覆盖遮阳网、覆盖遮阴布、降低室内人工光照等方法降低光照强度。", lessTem, lessHum, moreLight];
            }else {//温度过低，湿度过低，光照强度正常
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境温度低于正常范围%.1f℃,环境湿度低于正常范围%.1f%%RH。\n经判断作物处于干冷的环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过增加大棚覆盖物、覆盖双层膜、挖防寒沟、增加棚内热源等方法提高环境温度;\n通过增加灌水量、增加灌水次数、采用细雾加湿等方法提高环境湿度。", lessTem, lessHum];
            }
        }else if (nowHum > maxHum) {
            if (nowLight < minLight) {//温度过低，湿度过高，光照强度过低
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境温度低于正常范围%.1f℃,环境湿度高于正常范围%.1f%%RH,光照强度低于正常范围%.1fLx。\n经判断作物处于湿冷、阴暗的环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过增加大棚覆盖物、覆盖双层膜、挖防寒沟、增加棚内热源等方法提高环境温度;\n通过通风、覆盖地膜、采用滴灌或渗灌、使用吸湿材料、适当提升环境温度等方法降低环境湿度;\n通过清洁棚膜、覆盖地膜、在弱光处设置反光膜、在棚内安装白炽灯等方法提高光照强度。", lessTem, moreHum, lessLight];
            }else if (nowLight > maxLight) {//温度过低，湿度过高，光照强度过高
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境温度低于正常范围%.1f℃,环境湿度高于正常范围%.1f%%RH,光照强度高于正常范围%.1fLx。\n经判断作物处于湿冷、光照过强的环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过增加大棚覆盖物、覆盖双层膜、挖防寒沟、增加棚内热源等方法提高环境温度;\n通过通风、覆盖地膜、采用滴灌或渗灌、使用吸湿材料、适当提升环境温度等方法降低环境湿度;\n通过在棚顶覆盖遮阳网、覆盖遮阴布、降低室内人工光照等方法降低光照强度。", lessTem, moreHum, moreLight];
            }else {//温度过低，湿度过高，光照强度正常
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境温度低于正常范围%.1f℃,环境湿度高于正常范围%.1f%%RH。\n经判断作物处于湿冷的环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过增加大棚覆盖物、覆盖双层膜、挖防寒沟、增加棚内热源等方法提高环境温度;\n通过通风、覆盖地膜、采用滴灌或渗灌、使用吸湿材料、适当提升环境温度等方法降低环境湿度。", lessTem, moreHum];
            }
        }else {
            if (nowLight < minLight) {//温度过低，湿度正常，光照强度过低
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境温度低于正常范围%.1f℃,光照强度低于正常范围%.1fLx。\n经判断作物处于温度过低、光照不足的环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过增加大棚覆盖物、覆盖双层膜、挖防寒沟、增加棚内热源等方法提高环境温度;\n通过清洁棚膜、覆盖地膜、在弱光处设置反光膜、在棚内安装白炽灯等方法提高光照强度。", lessTem, lessLight];
            }else if (nowLight > maxLight) {//温度过低，湿度正常，光照强度过高
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境温度低于正常范围%.1f℃,光照强度高于正常范围%.1fLx。\n经判断作物处于温度过低、光照过强的环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过增加大棚覆盖物、覆盖双层膜、挖防寒沟、增加棚内热源等方法提高环境温度;\n通过在棚顶覆盖遮阳网、覆盖遮阴布、降低室内人工光照等方法降低光照强度。", lessTem, moreLight];
            }else {//温度过低，湿度正常，光照强度正常
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境温度低于正常范围%.1f℃。\n经判断作物处于温度过低的生长环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过增加大棚覆盖物、覆盖双层膜、挖防寒沟、增加棚内热源等方法提高环境温度。\n比如夜间在大棚四周加围草苫或农作物秸秆,可提高棚温1～2度。此外;棚顶可加盖两层草苫子,然后再覆盖一层薄膜,增温可达3～5度。", lessTem];
            }
        }
    }else if (nowTem > maxTem) {
        if (nowHum < minHum) {
            if (nowLight < minLight) {//温度过高，湿度过低，光照强度过低
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境温度高于正常范围%.1f℃,环境湿度低于正常范围%.1f%%RH,光照强度低于正常范围%.1fLx。\n经判断作物处于温度过高、湿度过低、光照不足的环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过增加通风时间、减少大棚的受光量和受光时间、采用喷雾降温设备等方法降低环境温度;\n通过增加灌水量、增加灌水次数、采用细雾加湿等方法提高环境湿度;\n通过清洁棚膜、覆盖地膜、在弱光处设置反光膜、在棚内安装白炽灯等方法提高光照强度。", moreTem, lessHum, lessLight];
            }else if (nowLight > maxLight) {//温度过高，湿度过低，光照强度过高
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境温度高于正常范围%.1f℃,环境湿度低于正常范围%.1f%%RH,光照强度高于正常范围%.1fLx。\n经判断作物处于温度过高、湿度过低、光照过强的环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过增加通风时间、减少大棚的受光量和受光时间、采用喷雾降温设备等方法降低环境温度;\n通过增加灌水量、增加灌水次数、采用细雾加湿等方法提高环境湿度;\n通过在棚顶覆盖遮阳网、覆盖遮阴布、降低室内人工光照等方法降低光照强度。", moreTem, lessHum, moreLight];
            }else {//温度过高，湿度过低，光照强度正常
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境温度高于正常范围%.1f℃,环境湿度低于正常范围%.1f%%RH。\n经判断作物处于温度过高、湿度过低的生长环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过增加通风时间、减少大棚的受光量和受光时间、采用喷雾降温设备等方法降低环境温度;\n通过增加灌水量、增加灌水次数、采用细雾加湿等方法提高环境湿度。", moreTem, lessHum];
            }
        }else if (nowHum > maxHum) {
            if (nowLight < minLight) {//温度过高，湿度过高，光照强度过低
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境温度高于正常范围%.1f℃,环境湿度高于正常范围%.1f%%RH,光照强度低于正常范围%.1fLx。\n经判断作物处于湿热、光照强度不足的生长环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过增加通风时间、减少大棚的受光量和受光时间、采用喷雾降温设备等方法降低环境温度;\n通过通风、覆盖地膜、采用滴灌或渗灌、使用吸湿材料、适当提升环境温度等方法降低环境湿度;\n通过清洁棚膜、覆盖地膜、在弱光处设置反光膜、在棚内安装白炽灯等方法提高光照强度。", moreTem, moreHum, lessLight];
            }else if (nowLight > maxLight) {//温度过高，湿度过高，光照强度过高
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境温度高于正常范围%.1f℃,环境湿度高于正常范围%.1f%%RH,光照强度高于正常范围%.1fLx。\n经判断作物处于湿热、光照强度过高的生长环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过增加通风时间、减少大棚的受光量和受光时间、采用喷雾降温设备等方法降低环境温度;\n通过通风、覆盖地膜、采用滴灌或渗灌、使用吸湿材料、适当提升环境温度等方法降低环境湿度;\n通过在棚顶覆盖遮阳网、覆盖遮阴布、降低室内人工光照等方法降低光照强度。", moreTem, moreHum, moreLight];
            }else {//温度过高，湿度过高，光照强度正常
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境温度高于正常范围%.1f℃,环境湿度高于正常范围%.1f%%RH。\n经判断作物处于湿热的生长环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过增加通风时间、减少大棚的受光量和受光时间、采用喷雾降温设备等方法降低环境温度;\n通过通风、覆盖地膜、采用滴灌或渗灌、使用吸湿材料、适当提升环境温度等方法降低环境湿度。", moreTem, moreHum];
            }
        }else {
            if (nowLight < minLight) {//温度过高，湿度正常，光照强度过低
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境温度高于正常范围%.1f℃,光照强度低于正常范围%.1fLx。\n经判断作物处于温度过高、光照强度不足的生长环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过增加通风时间、减少大棚的受光量和受光时间、采用喷雾降温设备等方法降低环境温度;\n通过清洁棚膜、覆盖地膜、在弱光处设置反光膜、在棚内安装白炽灯等方法提高光照强度。", moreTem, lessLight];
            }else if (nowLight > maxLight) {//温度过高，湿度正常，光照强度过高
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境温度高于正常范围%.1f℃,光照强度高于正常范围%.1fLx。\n经判断作物处于温度过高、光照强度过高的生长环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过增加通风时间、减少大棚的受光量和受光时间、采用喷雾降温设备等方法降低环境温度;\n通过在棚顶覆盖遮阳网、覆盖遮阴布、降低室内人工光照等方法降低光照强度。", moreTem, moreLight];
            }else {//温度过高，湿度正常，光照强度正常
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境温度高于正常范围%.1f℃。\n经判断作物处于温度过高的生长环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过增加通风时间、减少大棚的受光量和受光时间、采用喷雾降温设备等方法降低环境温度。\n比如将两侧的通风口在加设防虫网的同时适当拉大,可有效降低环境温度。也可覆盖遮阳网或向棚膜上泼泥浆,下过雨后再泼,虽然比较麻烦,但经济适用。", moreTem];
            }
        }
    }else {
        if (nowHum < minHum) {
            if (nowLight < minLight) {//温度正常，湿度过低，光照强度过低
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境湿度低于正常范围%.1f%%RH,光照强度低于正常范围%.1fLx。\n经判断作物处于湿度过低、光照强度不足的环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过增加灌水量、增加灌水次数、采用细雾加湿等方法提高环境湿度;\n通过清洁棚膜、覆盖地膜、在弱光处设置反光膜、在棚内安装白炽灯等方法提高光照强度。", lessHum, lessLight];
            }else if (nowLight > maxLight) {//温度正常，湿度过低，光照强度过高
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境湿度低于正常范围%.1f%%RH,光照强度高于正常范围%.1fLx。\n经判断作物处于湿度过低、光照强度过高的环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过增加灌水量、增加灌水次数、采用细雾加湿等方法提高环境湿度;\n通过在棚顶覆盖遮阳网、覆盖遮阴布、降低室内人工光照等方法降低光照强度。", lessHum, moreLight];
            }else {//温度正常，湿度过低，光照强度正常
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境湿度低于正常范围%.1f%%RH。\n经判断作物处于湿度过低的生长环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过增加灌水量、增加灌水次数、采用细雾加湿等方法提高环境湿度。\n比如细雾加湿,其基本原理是在高压作用下水雾化为直径极小的雾粒飘在空气中并迅速蒸发,从而有效提高空气湿度。", lessHum];
            }
        }else if (nowHum > maxHum) {
            if (nowLight < minLight) {//温度正常，湿度过高，光照强度过低
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境湿度高于正常范围%.1f%%RH,光照强度低于正常范围%.1fLx。\n经判断作物处于湿度过高、光照强度不足的生长环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过通风、覆盖地膜、采用滴灌或渗灌、使用吸湿材料、适当提升环境温度等方法降低环境湿度;\n通过清洁棚膜、覆盖地膜、在弱光处设置反光膜、在棚内安装白炽灯等方法提高光照强度。", moreHum, lessLight];
            }else if (nowLight > maxLight) {//温度正常，湿度过高，光照强度过高
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境湿度高于正常范围%.1f%%RH,光照强度高于正常范围%.1fLx。\n经判断作物处于湿度过高、光照强度过高的生长环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过通风、覆盖地膜、采用滴灌或渗灌、使用吸湿材料、适当提升环境温度等方法降低环境湿度;\n通过在棚顶覆盖遮阳网、覆盖遮阴布、降低室内人工光照等方法降低光照强度。", moreHum, moreLight];
            }else {//温度正常，湿度过高，光找强度正常
                self.suggestionLabel.text = [NSString stringWithFormat:@"环境湿度高于正常范围%.1f %%RH\n经判断作物处于湿度过高的生长环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过通风、覆盖地膜、采用滴灌或渗灌、使用吸湿材料、适当提升环境温度等方法降低环境湿度。\n通风换气是调节温室大棚内湿度环境的最简单有效的方法,温室大棚内湿度一般高于室外,通过通风换气引进湿度相对较低的空气对室内空气能起到稀释作用。", moreHum];
            }
        }else {
            if (nowLight < minLight) {//温度正常，湿度正常，光照强度过低
                self.suggestionLabel.text = [NSString stringWithFormat:@"光照强度低于正常范围%.1fLx。\n经判断作物处于光照强度不足的生长环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过清洁棚膜、覆盖地膜、在弱光处设置反光膜、在棚内安装白炽灯等方法提高光照强度。\n比如采用覆盖地膜、刷白架材、棚内挂反光幕、在建材和土墙上涂白等措施,可增加光照25%%左右。", lessLight];
            }else if (nowLight > maxLight) {//温度正常，湿度正常，光照强度过高
                self.suggestionLabel.text = [NSString stringWithFormat:@"光照强度高于正常范围%.1fLx。\n经判断作物处于光照强度过高的生长环境,这样的环境在很大程度上约束了作物的生长!\n建议您通过在棚顶覆盖遮阳网、覆盖遮阴布、降低室内人工光照等方法降低光照强度。\n比如遮阴不但可以减弱大棚内的光照强度,还可以降低大棚内的温度,这在光照过强时相当有用。", moreLight];
            }else {//温度正常，湿度正常，光照强度正常
                
            }
        }
    }
    self.suggestionLabel.textColor = [UIColor darkGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
