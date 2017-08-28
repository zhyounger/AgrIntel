//
//  AGRMessageCell.m
//  AgrIntel
//
//  Created by 实验室 on 2017/8/26.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import "AGRMessageCell.h"
#import "AGRMessage.h"
#import "UIImageView+WebCache.h"
#import "LCPhotoBrowser.h"


@interface AGRMessageCell()
//图片
@property (weak, nonatomic) IBOutlet UIImageView *imaImageView;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//传感器
@property (weak, nonatomic) IBOutlet UILabel *sensorLabel;
//摘要
@property (weak, nonatomic) IBOutlet UILabel *abstractsLabel;

@end

@implementation AGRMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.backgroundColor = AGRGlobalBg;
}

+(instancetype)AGRMessageCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"AGRMessageCell" owner:nil options:nil] lastObject];
}

-(void)setText:(AGRMessage *)text
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
            fmt.dateFormat = @"yyyy年MM月dd日 HH:mm";
            self.timeLabel.text = [fmt stringFromDate:create];
        }else if (cmps.minute >= 1) {//1小时 > 时间差距 >= 1分钟
            self.timeLabel.text = [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
        }else {//1分钟 > 时间差距
            self.timeLabel.text = @"刚刚";
        }
    }else {//不是今天
        fmt.dateFormat = @"yyyy年MM月dd日 HH:mm";
        self.timeLabel.text = [fmt stringFromDate:create];
    }
   
    //添加图片
    [self.imaImageView setImage:[UIImage imageNamed:@"nav_leftLogo"]];
    
    //传感器label
    self.sensorLabel.text = [NSString stringWithFormat:@"传感器%@", text.sensor];
    
    CGFloat nowTem = [text.tem intValue];
    CGFloat maxTem = [text.maxtem intValue];
    CGFloat minTem = [text.mintem intValue];
    CGFloat lessTem = minTem - nowTem;
    CGFloat moreTem = nowTem - maxTem;
    
    CGFloat nowHum = [text.hum intValue];
    CGFloat maxHum = [text.maxhum intValue];
    CGFloat minHum = [text.minhum intValue];
    CGFloat lessHum = minHum - nowHum;
    CGFloat moreHum = nowHum - maxHum;
    
    CGFloat nowLight = [text.light intValue];
    CGFloat maxLight = [text.maxlight intValue];
    CGFloat minLight = [text.minlight intValue];
    CGFloat lessLight = minLight - nowLight;
    CGFloat moreLight = nowLight - maxLight;
    
    //摘要label
    if (nowTem < minTem) {
        if (nowHum < minHum) {
            if (nowLight < minLight) {//温度过低，湿度过低，光照强度过低
                self.abstractsLabel.text = [NSString stringWithFormat:@"温度低于正常范围%.1f℃, 湿度低于正常范围%.1f%%RH, 光照强度低于正常范围%.1fLx!", lessTem, lessHum, lessLight];
            }else if (nowLight > maxLight) {//温度过低，湿度过低，光照强度过高
                self.abstractsLabel.text = [NSString stringWithFormat:@"温度低于正常范围%.1f℃, 湿度低于正常范围%.1f%%RH, 光照强度高于正常范围%.1fLx!", lessTem, lessHum, moreLight];
            }else {//温度过低，湿度过低，光照强度正常
                self.abstractsLabel.text = [NSString stringWithFormat:@"温度低于正常范围%.1f℃, 湿度低于正常范围%.1f%%RH!", lessTem, lessHum];
            }
        }else if (nowHum > maxHum) {
            if (nowLight < minLight) {//温度过低，湿度过高，光照强度过低
                self.abstractsLabel.text = [NSString stringWithFormat:@"温度低于正常范围%.1f℃, 湿度高于正常范围%.1f%%RH, 光照强度低于正常范围%.1fLx!", lessTem, moreHum, lessLight];
            }else if (nowLight > maxLight) {//温度过低，湿度过高，光照强度过高
                self.abstractsLabel.text = [NSString stringWithFormat:@"温度低于正常范围%.1f℃, 湿度高于正常范围%.1f%%RH, 光照强度高于正常范围%.1fLx!", lessTem, moreHum, moreLight];
            }else {//温度过低，湿度过高，光照强度正常
                self.abstractsLabel.text = [NSString stringWithFormat:@"温度低于正常范围%.1f℃, 湿度高于正常范围%.1f%%RH!", lessTem, moreHum];
            }
        }else {
            if (nowLight < minLight) {//温度过低，湿度正常，光照强度过低
                self.abstractsLabel.text = [NSString stringWithFormat:@"温度低于正常范围%.1f℃, 光照强度低于正常范围%.1fLx!", lessTem, lessLight];
            }else if (nowLight > maxLight) {//温度过低，湿度正常，光照强度过高
                self.abstractsLabel.text = [NSString stringWithFormat:@"温度低于正常范围%.1f℃, 光照强度高于正常范围%.1fLx!", lessTem, moreLight];
            }else {//温度过低，湿度正常，光照强度正常
                self.abstractsLabel.text = [NSString stringWithFormat:@"温度低于正常范围%.1f℃!", lessTem];
            }
        }
    }else if (nowTem > maxTem) {
        if (nowHum < minHum) {
            if (nowLight < minLight) {//温度过高，湿度过低，光照强度过低
                self.abstractsLabel.text = [NSString stringWithFormat:@"温度高于正常范围%.1f℃, 湿度低于正常范围%.1f%%RH, 光照强度低于正常范围%.1fLx!", moreTem, lessHum, lessLight];
            }else if (nowLight > maxLight) {//温度过高，湿度过低，光照强度过高
                self.abstractsLabel.text = [NSString stringWithFormat:@"温度高于正常范围%.1f℃, 湿度低于正常范围%.1f%%RH, 光照强度高于正常范围%.1fLx!", moreTem, lessHum, moreLight];
            }else {//温度过高，湿度过低，光照强度正常
                self.abstractsLabel.text = [NSString stringWithFormat:@"温度高于正常范围%.1f℃, 湿度低于正常范围%.1f%%RH!", moreTem, lessHum];
            }
        }else if (nowHum > maxHum) {
            if (nowLight < minLight) {//温度过高，湿度过高，光照强度过低
                self.abstractsLabel.text = [NSString stringWithFormat:@"温度高于正常范围%.1f℃, 湿度高于正常范围%.1f%%RH, 光照强度低于正常范围%.1fLx!", moreTem, moreHum, lessLight];
            }else if (nowLight > maxLight) {//温度过高，湿度过高，光照强度过高
                self.abstractsLabel.text = [NSString stringWithFormat:@"温度高于正常范围%.1f℃, 湿度高于正常范围%.1f%%RH, 光照强度高于正常范围%.1fLx!", moreTem, moreHum, moreLight];
            }else {//温度过高，湿度过高，光照强度正常
                self.abstractsLabel.text = [NSString stringWithFormat:@"温度高于正常范围%.1f℃, 湿度高于正常范围%.1f%%RH!", moreTem, moreHum];
            }
        }else {
            if (nowLight < minLight) {//温度过高，湿度正常，光照强度过低
                self.abstractsLabel.text = [NSString stringWithFormat:@"温度高于正常范围%.1f℃, 光照强度低于正常范围%.1fLx!", moreTem, lessLight];
            }else if (nowLight > maxLight) {//温度过高，湿度正常，光照强度过高
                self.abstractsLabel.text = [NSString stringWithFormat:@"温度高于正常范围%.1f℃, 光照强度高于正常范围%.1fLx!", moreTem, moreLight];
            }else {//温度过高，湿度正常，光照强度正常
                self.abstractsLabel.text = [NSString stringWithFormat:@"温度高于正常范围%.1f℃!", moreTem];
            }
        }
    }else {
        if (nowHum < minHum) {
            if (nowLight < minLight) {//温度正常，湿度过低，光照强度过低
                self.abstractsLabel.text = [NSString stringWithFormat:@"湿度低于正常范围%.1f%%RH, 光照强度低于正常范围%.1fLx!", lessHum, lessLight];
            }else if (nowLight > maxLight) {//温度正常，湿度过低，光照强度过高
                self.abstractsLabel.text = [NSString stringWithFormat:@"湿度低于正常范围%.1f%%RH, 光照强度高于正常范围%.1fLx!", lessHum, moreLight];
            }else {//温度正常，湿度过低，光照强度正常
                self.abstractsLabel.text = [NSString stringWithFormat:@"湿度低于正常范围%.1f%%RH!", lessHum];
            }
        }else if (nowHum > maxHum) {
            if (nowLight < minLight) {//温度正常，湿度过高，光照强度过低
                self.abstractsLabel.text = [NSString stringWithFormat:@"湿度高于正常范围%.1f%%RH, 光照强度低于正常范围%.1fLx!", moreHum, lessLight];
            }else if (nowLight > maxLight) {//温度正常，湿度过高，光照强度过高
                self.abstractsLabel.text = [NSString stringWithFormat:@"湿度高于正常范围%.1f%%RH, 光照强度高于正常范围%.1fLx!", moreHum, moreLight];
            }else {//温度正常，湿度过高，光找强度正常
                self.abstractsLabel.text = [NSString stringWithFormat:@"湿度高于正常范围%.1f %%RH", moreHum];
            }
        }else {
            if (nowLight < minLight) {//温度正常，湿度正常，光照强度过低
                self.abstractsLabel.text = [NSString stringWithFormat:@"光照强度低于正常范围%.1fLx!", lessLight];
            }else if (nowLight > maxLight) {//温度正常，湿度正常，光照强度过高
                self.abstractsLabel.text = [NSString stringWithFormat:@"光照强度高于正常范围%.1fLx!", moreLight];
            }else {//温度正常，湿度正常，光照强度正常
                
            }
        }
    }
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
