//
//  AGRSensorCell.m
//  AgrIntel
//
//  Created by 实验室 on 2017/7/7.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import "AGRSensorCell.h"
#import "AGRSensor.h"
#import "UIImageView+WebCache.h"
#import "LCPhotoBrowser.h"

@interface AGRSensorCell()
//图片
@property (weak, nonatomic) IBOutlet UIImageView *imaImageView;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//温度
@property (weak, nonatomic) IBOutlet UILabel *temLabel;
//湿度
@property (weak, nonatomic) IBOutlet UILabel *humLabel;
//光强
@property (weak, nonatomic) IBOutlet UILabel *lightLabel;
//温度细节
@property (weak, nonatomic) IBOutlet UILabel *temDetailLabel;
//湿度细节
@property (weak, nonatomic) IBOutlet UILabel *humDetailLabel;
//光照强度细节
@property (weak, nonatomic) IBOutlet UILabel *lightDetailLabel;

@end

@implementation AGRSensorCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype)AGRSensorCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"AGRSensorCell" owner:nil options:nil] lastObject];
}

-(void)setText:(AGRSensor *)text
{
    _text = text;
    
    //日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    //设置日期格式
    fmt.dateFormat = @"yyyy-MM-dd-HH-mm";
    //传感器创建数据的时间
    NSDate *create = [fmt dateFromString:text.time];
    
    //时间label
    if (create.isToday) {//今天
        NSDateComponents *cmps = [[NSDate date]deltaFrom:create];
        if (cmps.hour >= 1) {//时间差距 >= 1小时
            fmt.dateFormat = @"HH:mm";
            self.timeLabel.text = [fmt stringFromDate:create];
        }else if (cmps.minute >= 1) {//1小时 > 时间差距 >= 1分钟
            self.timeLabel.text = [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
        }else {//1分钟 > 时间差距
            self.timeLabel.text = @"刚刚";
        }
    }else {//不是今天
        fmt.dateFormat = @"HH:mm";
        self.timeLabel.text = [fmt stringFromDate:create];
    }
//    if (create.isThisYear) { //今年
//        if (create.isToday) { //今天
//            NSDateComponents *cmps = [[NSDate date]deltaFrom:create];
//            
//            if (cmps.hour >= 1) { //时间差距 >= 1小时
//                self.timeLabel.text = [NSString stringWithFormat:@"%zd小时前", cmps.hour];
//            }else if (cmps.minute >= 1){ //1小时 > 时间差距 >= 1分钟
//                self.timeLabel.text = [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
//            }else{ //1分钟 > 时间差距
//                self.timeLabel.text = @"刚刚";
//            }
//        }else if (create.isYesterday){ //昨天
//            fmt.dateFormat = @"昨天 HH:mm";
//            self.timeLabel.text = [fmt stringFromDate:create];
//        }else{ //其他
//            fmt.dateFormat = @"MM-dd HH:mm";
//            self.timeLabel.text = [fmt stringFromDate:create];
//        }
//    }else{ //非今年
//        //显示正常格式的时间
//        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
//        self.timeLabel.text = [fmt stringFromDate:create];
//    }
    
//    fmt.dateFormat = @"HH:mm";
//    self.timeLabel.text = [fmt stringFromDate:create];
    
    //添加图片、温湿度和光照强度数据
    [self.imaImageView sd_setImageWithURL:[NSURL URLWithString:text.imgurl] placeholderImage:[UIImage imageNamed:@"cell_loading"]];    
    self.temLabel.text = [NSString stringWithFormat:@"%@ ℃",text.tem];
    self.humLabel.text = [NSString stringWithFormat:@"%@ %%RH",text.hum];
    self.lightLabel.text = [NSString stringWithFormat:@"%@ Lx",text.light];
    
     //图片圆角
    _imaImageView.layer.cornerRadius = 15;
    _imaImageView.layer.masksToBounds = YES;
    
    //给图片添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImage)];
    [_imaImageView addGestureRecognizer:tap];
    _imaImageView.userInteractionEnabled = YES;

    
    //设置当前温湿度和光照强度
    NSInteger nowTem = [text.tem integerValue];
    NSInteger nowHum = [text.hum integerValue];
    NSInteger nowLight = [text.light integerValue];
    
    //设置三类数据的最高值和最低值
    NSInteger maxTem = [text.maxtem intValue];
    NSInteger minTem = [text.mintem intValue];
    NSInteger maxHum = [text.maxhum intValue];
    NSInteger minHum = [text.minhum intValue];
    NSInteger maxLight = [text.maxlight intValue];
    NSInteger minLight = [text.minlight intValue];
    
    //判断温湿度和光照强度是否正常
    BOOL temIsNormal = (nowTem <= maxTem) && (nowTem >= minTem);
    BOOL humIsNormal = (nowHum <= maxHum) && (nowHum >= minHum);
    BOOL lightIsNormal = (nowLight <= maxLight) && (nowLight >= minLight);
    
    //若正常,label为黑色；若异常,label为红色
    if (temIsNormal) {
        if (humIsNormal) {
            if (lightIsNormal) {//全都正常
                self.temLabel.textColor = [UIColor blackColor];
                self.humLabel.textColor = [UIColor blackColor];
                self.lightLabel.textColor = [UIColor blackColor];
            }else{//温度正常，湿度正常，光照强度异常
                self.temLabel.textColor = [UIColor blackColor];
                self.humLabel.textColor = [UIColor blackColor];
                self.lightLabel.textColor = [UIColor redColor];
            }
        }else if (lightIsNormal){//温度正常，湿度异常，光照强度正常
            self.temLabel.textColor = [UIColor blackColor];
            self.humLabel.textColor = [UIColor redColor];
            self.lightLabel.textColor = [UIColor blackColor];
        }else{//温度正常，湿度异常，光照强度异常
            self.temLabel.textColor = [UIColor blackColor];
            self.humLabel.textColor = [UIColor redColor];
            self.lightLabel.textColor = [UIColor redColor];
        }
    }else if (humIsNormal){
        if (lightIsNormal) {//温度异常，湿度正常，光照强度正常
            self.temLabel.textColor = [UIColor redColor];
            self.humLabel.textColor = [UIColor blackColor];
            self.lightLabel.textColor = [UIColor blackColor];
        }else{//温度异常，湿度正常，光照强度异常
            self.temLabel.textColor = [UIColor redColor];
            self.humLabel.textColor = [UIColor blackColor];
            self.lightLabel.textColor = [UIColor redColor];
        }
    }else if (lightIsNormal){//温度异常，湿度异常，光照强度正常
        self.temLabel.textColor = [UIColor redColor];
        self.humLabel.textColor = [UIColor redColor];
        self.lightLabel.textColor = [UIColor blackColor];
    }else{//全都异常
        self.temLabel.textColor = [UIColor redColor];
        self.humLabel.textColor = [UIColor redColor];
        self.lightLabel.textColor = [UIColor redColor];
    }
    
    //温度细节文字
    if (nowTem < minTem) {//温度低
        self.temDetailLabel.text = @"温度低于正常范围,请提升环境温度以维持作物的健康!";
    }else if (nowTem > maxTem) {//温度高
        self.temDetailLabel.text = @"温度高于正常范围,请降低环境温度以维持作物的健康!";
    }else {//温度正常
        self.temDetailLabel.text = @"环境温度适宜。";
    }
    
    //湿度细节文字
    if (nowHum < minHum) {//湿度低
        self.humDetailLabel.text = @"湿度低于正常范围,请提升环境湿度以维持作物的健康!";
    }else if (nowHum > maxHum) {//湿度高
        self.humDetailLabel.text = @"湿度高于正常范围,请降低环境湿度以维持作物的健康!";
    }else {//湿度正常
        self.humDetailLabel.text = @"环境湿度适宜。";
    }
    
    //光照强度细节文字
    if (nowLight < minLight) {//光照强度低
        self.lightDetailLabel.text = @"光照强度低于正常范围,请提升光照以维持作物的健康!";
    }else if (nowLight > maxLight) {//光照强度高
        self.lightDetailLabel.text = @"光照强度高于正常范围,请降低光照以维持作物的健康!";
    }else {//光照强度正常
        self.lightDetailLabel.text = @"光照强度适宜。";
    }
}

#pragma 点击图片弹出大图
-(void)clickImage
{
    NSMutableArray * photoItems = [NSMutableArray array];
        
    LCPhotoItem * item = [[LCPhotoItem alloc] init];
    item.referenceView = self.imaImageView;
    [photoItems addObject:item];
    
    LCPhotoBrowser *browser = [[LCPhotoBrowser alloc]init];
    browser.items = photoItems;
    browser.loadingStyle = LCPhotoBrowserLoadingStyleActivityIndicator;
    browser.backgroundStyle = LCPhotoBrowserBackgroundStyleBlur;
    browser.backgroundBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    [browser show];
}

#pragma cell的间距
-(void)setFrame:(CGRect)frame
{
    static CGFloat margin = 10;
    frame.origin.x = margin;
    frame.size.width -= 2 *margin;
    frame.size.height -= margin;
    frame.origin.y += margin;
    
    [super setFrame:frame];
}

@end
