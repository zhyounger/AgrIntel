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
#import "FFToast.h"
#import "NSString+FFToast.h"
#import "UIImage+FFToast.h"

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
//正常数据按钮点击
- (IBAction)norButton:(UIButton *)sender;
//异常数据按钮点击
- (IBAction)abnorButton:(UIButton *)sender;
//按钮点击弹出框
@property (nonatomic, strong) FFToast *detailToast;
//异常数据弹出框的文字
@property (nonatomic, strong) NSString *message;

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
            fmt.dateFormat = @"MM-dd HH:mm";
            self.timeLabel.text = [fmt stringFromDate:create];
        }
    }else{ //非今年
        //显示正常格式的时间
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        self.timeLabel.text = [fmt stringFromDate:create];
    }

    //添加图片、温湿度和光照强度数据
    [self.imaImageView sd_setImageWithURL:[NSURL URLWithString:text.img_url]];
    self.temLabel.text = [NSString stringWithFormat:@"%@ ℃",text.tem];
    self.humLabel.text = [NSString stringWithFormat:@"%@ %%",text.hum];
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
    
    //判断温湿度和光照强度是否正常
    BOOL temIsNormal = (nowTem <= maxTem) && (nowTem >= minTem);
    BOOL humIsNormal = (nowHum <= maxHum) && (nowHum >= minHum);
    BOOL lightIsNormal = (nowLight <= maxLight) && (nowLight >= minLight);
    
    //若正常,label为黑色,显示ok图片；若异常,label为橙色,显示notice图片
    if (temIsNormal) {
        if (humIsNormal) {
            if (lightIsNormal) {//全都正常
                self.temLabel.textColor = [UIColor blackColor];
                self.humLabel.textColor = [UIColor blackColor];
                self.lightLabel.textColor = [UIColor blackColor];
            }else{//温度正常，湿度正常，光照强度异常
                self.temLabel.textColor = [UIColor blackColor];
                self.humLabel.textColor = [UIColor blackColor];
                self.lightLabel.textColor = [UIColor orangeColor];
            }
        }else if (lightIsNormal){//温度正常，湿度异常，光照强度正常
            self.temLabel.textColor = [UIColor blackColor];
            self.humLabel.textColor = [UIColor orangeColor];
            self.lightLabel.textColor = [UIColor blackColor];
        }else{//温度正常，湿度异常，光照强度异常
            self.temLabel.textColor = [UIColor blackColor];
            self.humLabel.textColor = [UIColor orangeColor];
            self.lightLabel.textColor = [UIColor orangeColor];
        }
    }else if (humIsNormal){
        if (lightIsNormal) {//温度异常，湿度正常，光照强度正常
            self.temLabel.textColor = [UIColor orangeColor];
            self.humLabel.textColor = [UIColor blackColor];
            self.lightLabel.textColor = [UIColor blackColor];
        }else{//温度异常，湿度正常，光照强度异常
            self.temLabel.textColor = [UIColor orangeColor];
            self.humLabel.textColor = [UIColor blackColor];
            self.lightLabel.textColor = [UIColor orangeColor];
        }
    }else if (lightIsNormal){//温度异常，湿度异常，光照强度正常
        self.temLabel.textColor = [UIColor orangeColor];
        self.humLabel.textColor = [UIColor orangeColor];
        self.lightLabel.textColor = [UIColor blackColor];
    }else{//全都异常
        self.temLabel.textColor = [UIColor orangeColor];
        self.humLabel.textColor = [UIColor orangeColor];
        self.lightLabel.textColor = [UIColor orangeColor];
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

#pragma 正常数据按钮点击
- (IBAction)norButton:(UIButton *)sender {
    
    CGFloat horizontalSpaceToScreen = 90;
    CGFloat topSpaceViewToView = 20;
    CGFloat horizontalSpaceToContentView = 10;
    CGFloat bottomSpaceToContentView = 10;
    CGSize topImgSize = CGSizeMake(50, 50);
    
    //顶部图片
    CGFloat topImgViewX = (SCREEN_WIDTH - 2*horizontalSpaceToScreen)/2 - topImgSize.width/2;
    CGFloat topImgViewY = 0;
    UIImageView *topImgView = [[UIImageView alloc]initWithFrame:CGRectMake(topImgViewX, topImgViewY, topImgSize.width, topImgSize.height)];
    topImgView.image = [UIImage imageWithName:@"cell_ok"];
    
    //文字内容
    NSString *title = @"您的作物很健康!";
    NSString *message = @"温湿度适宜,光照充足,作物在您的悉心照料下健康地生长!";
    NSString *msg = [NSString stringWithFormat:@"温度正常范围:%.1f℃ ~ %.1f℃\n湿度正常范围:%.1f%% ~ %.1f%%\n光照强度正常范围:%.1fLx ~ %.1fLx",minTem,maxTem,minHum,maxHum,minLight,maxLight];
    
    //设置字体
    UIFont *titleFont = [UIFont systemFontOfSize:15.f weight:UIFontWeightMedium];
    UIFont *messageFont = [UIFont systemFontOfSize:15.f];
    UIFont *msgFont = [UIFont systemFontOfSize:12.f];
    
    //设置尺寸
    CGFloat maxTextWidth = SCREEN_WIDTH - 2*(horizontalSpaceToScreen) - 2 * horizontalSpaceToContentView;
    CGSize titleSize = [NSString sizeForString:title font:titleFont maxWidth:maxTextWidth];
    CGSize messageSize = [NSString sizeForString:message font:messageFont maxWidth:maxTextWidth];
    CGSize msgSize = [NSString sizeForString:msg font:msgFont maxWidth:maxTextWidth];
    
    //标题框
    CGFloat titleLabelX = (SCREEN_WIDTH - 2*horizontalSpaceToScreen - titleSize.width)/2;
    CGFloat titleLabelY = topImgSize.height/2 + topSpaceViewToView;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleSize.width, titleSize.height)];
    titleLabel.text = title;
    titleLabel.font = titleFont;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    
    //内容框
    CGFloat messageLabelX = (SCREEN_WIDTH - 2*horizontalSpaceToScreen - messageSize.width)/2;
    CGFloat messageLabelY = titleLabelY + titleSize.height + topSpaceViewToView;
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(messageLabelX, messageLabelY, messageSize.width, messageSize.height)];
    messageLabel.text = message;
    messageLabel.font = messageFont;
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    
    //提示框
    CGFloat msgLabelX = (SCREEN_WIDTH - 2*horizontalSpaceToScreen - msgSize.width)/2;
    CGFloat msgLabelY = messageLabelY + messageSize.height + topSpaceViewToView;
    UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(msgLabelX, msgLabelY, msgSize.width, msgSize.height)];
    msgLabel.text = msg;
    msgLabel.font = msgFont;
    msgLabel.textColor = [UIColor darkGrayColor];
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.numberOfLines = 0;
    
    //OK按钮
    CGFloat okBtnX = 5;
    CGFloat okBtnY = msgLabelY + msgSize.height + topSpaceViewToView;
    CGFloat okBtnW = SCREEN_WIDTH - 2*horizontalSpaceToScreen - 10;
    CGFloat okBtnH = 35;
    UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake(okBtnX, okBtnY, okBtnW, okBtnH)];
    okBtn.backgroundColor = [UIColor colorWithRed:0.17 green:0.69 blue:0.55 alpha:1.00];
    [okBtn setTitle:@"ok" forState:UIControlStateNormal];
    okBtn.layer.cornerRadius = 2.f;
    okBtn.layer.masksToBounds = YES;
    [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat detailToastViewX = 0;
    CGFloat detailToastViewY = topImgSize.height/2;
    CGFloat detailToastViewW = SCREEN_WIDTH - 2 * horizontalSpaceToScreen;
    CGFloat detailToastViewH = okBtnY + okBtnH + bottomSpaceToContentView;
    UIView *detailToastView = [[UIView alloc]initWithFrame:CGRectMake(detailToastViewX, detailToastViewY, detailToastViewW, detailToastViewH)];
    detailToastView.backgroundColor = [UIColor whiteColor];
    
    
    [detailToastView addSubview: titleLabel];
    [detailToastView addSubview: messageLabel];
    [detailToastView addSubview: msgLabel];
    [detailToastView addSubview: okBtn];
    
    
    CGFloat detailToastParentViewW = SCREEN_WIDTH - 2*horizontalSpaceToScreen;
    CGFloat detailToastParentViewH = topImgSize.height/2 + detailToastViewH;
    CGFloat detailToastParentViewX = (SCREEN_WIDTH - detailToastParentViewW)/2;
    CGFloat detailToastParentViewY = (SCREEN_HEIGHT - detailToastParentViewH)/2;
    UIView *detailToastParentView = [[UIView alloc]initWithFrame:CGRectMake(detailToastParentViewX, detailToastParentViewY, detailToastParentViewW, detailToastParentViewH)];
    
    [detailToastParentView addSubview:detailToastView];
    [detailToastParentView addSubview: topImgView];
    detailToastView.layer.cornerRadius = 5.f;
    detailToastView.layer.masksToBounds = YES;
    
    
    _detailToast = [[FFToast alloc]initCentreToastWithView:detailToastParentView autoDismiss:NO duration:0 enableDismissBtn:NO dismissBtnImage:nil];
    
    [_detailToast show];
    
}

#pragma 异常数据按钮点击
- (IBAction)abnorButton:(UIButton *)sender {
    
    CGFloat horizontalSpaceToScreen = 90;
    CGFloat topSpaceViewToView = 20;
    CGFloat horizontalSpaceToContentView = 10;
    CGFloat bottomSpaceToContentView = 10;
    CGSize topImgSize = CGSizeMake(50, 50);
    
    //顶部图片
    CGFloat topImgViewX = (SCREEN_WIDTH - 2*horizontalSpaceToScreen)/2 - topImgSize.width/2;
    CGFloat topImgViewY = 0;
    UIImageView *topImgView = [[UIImageView alloc]initWithFrame:CGRectMake(topImgViewX, topImgViewY, topImgSize.width, topImgSize.height)];
    topImgView.image = [UIImage imageWithName:@"cell_notice"];
    
    //文字内容
    NSInteger nowTem = [_text.tem integerValue];
    NSInteger nowHum = [_text.hum integerValue];
    NSInteger nowLight = [_text.light integerValue];
    NSString *title = @"警告:作物有危险!";
    NSString *msg = [NSString stringWithFormat:@"温度正常范围:%.1f℃ ~ %.1f℃\n湿度正常范围:%.1f%% ~ %.1f%%\n光照强度正常范围:%.1fLx ~ %.1fLx",minTem,maxTem,minHum,maxHum,minLight,maxLight];
    if (nowTem < minTem) {
        if (nowHum < minHum) {
            if (nowLight < minLight) {//温度过低，湿度过低，光照强度过低
                _message = @"温度、湿度和光照强度均低于正常范围!!若不尽快解决这些问题,作物的生长发育将会受阻甚至死亡。";
            }else if (nowLight > maxLight) {//温度过低，湿度过低，光照强度过高
                _message = @"温湿度低于正常范围!光照强度";
            }else {//温度过低，湿度过低，光照强度正常
                _message = @"温度过低，湿度过低，光照强度正常";
            }
        }else if (nowHum > maxHum) {
            if (nowLight < minLight) {//温度过低，湿度过高，光照强度过低
                _message = @"温度过低，湿度过高，光照强度过低";
            }else if (nowLight > maxLight) {//温度过低，湿度过高，光照强度过高
                _message = @"温度过低，湿度过高，光照强度过高";
            }else {//温度过低，湿度过高，光照强度正常
                _message = @"温度过低，湿度过高，光照强度正常";
            }
        }else {
            if (nowLight < minLight) {//温度过低，湿度正常，光照强度过低
                _message = @"温度过低，湿度正常，光照强度过低";
            }else if (nowLight > maxLight) {//温度过低，湿度正常，光照强度过高
                _message = @"温度过低，湿度正常，光照强度过高";
            }else {//温度过低，湿度正常，光照强度正常
                _message = @"温度过低，湿度正常，光照强度正常";
            }
        }
    }else if (nowTem > maxTem) {
        if (nowHum < minHum) {
            if (nowLight < minLight) {//温度过高，湿度过低，光照强度过低
                _message = @"温度过高，湿度过低，光照强度过低";
            }else if (nowLight > maxLight) {//温度过高，湿度过低，光照强度过高
                _message = @"温度过高，湿度过低，光照强度过高";
            }else {//温度过高，湿度过低，光照强度正常
                _message = @"温度过高，湿度过低，光照强度正常";
            }
        }else if (nowHum > maxHum) {
            if (nowLight < minLight) {//温度过高，湿度过高，光照强度过低
                _message = @"温度过高，湿度过高，光照强度过低";
            }else if (nowLight > maxLight) {//温度过高，湿度过高，光照强度过高
                _message = @"温度过高，湿度过高，光照强度过高";
            }else {//温度过高，湿度过高，光照强度正常
                _message = @"温度过高，湿度过高，光照强度正常";
            }
        }else {
            if (nowLight < minLight) {//温度过高，湿度正常，光照强度过低
                _message = @"温度过高，湿度正常，光照强度过低";
            }else if (nowLight > maxLight) {//温度过高，湿度正常，光照强度过高
                _message = @"温度过高，湿度正常，光照强度过高";
            }else {//温度过高，湿度正常，光照强度正常
                _message = @"温度过高，湿度正常，光照强度正常";
            }
        }
    }else {
        if (nowHum < minHum) {
            if (nowLight < minLight) {//温度正常，湿度过低，光照强度过低
                _message = @"温度正常，湿度过低，光照强度过低";
            }else if (nowLight > maxLight) {//温度正常，湿度过低，光照强度过高
                _message = @"温度正常，湿度过低，光照强度过高";
            }else {//温度正常，湿度过低，光照强度正常
                _message = @"温度正常，湿度过低，光照强度正常";
            }
        }else if (nowHum > maxHum) {
            if (nowLight < minLight) {//温度正常，湿度过高，光照强度过低
                _message = @"温度正常，湿度过高，光照强度过低";
            }else if (nowLight > maxLight) {//温度正常，湿度过高，光照强度过高
                _message = @"温度正常，湿度过高，光照强度过高";
            }else {//温度正常，湿度过高，光找强度正常
                _message = @"温度正常，湿度过高，光找强度正常";
            }
        }else {
            if (nowLight < minLight) {//温度正常，湿度正常，光照强度过低
                _message = @"温度正常，湿度正常，光照强度过低";
            }else if (nowLight > maxLight) {//温度正常，湿度正常，光照强度过高
                _message = @"温度正常，湿度正常，光照强度过高";
            }else {//温度正常，湿度正常，光照强度正常
                _message = @"温度正常，湿度正常，光照强度正常";
            }
        }
    }
    
    //设置字体
    UIFont *titleFont = [UIFont systemFontOfSize:15.f weight:UIFontWeightMedium];
    UIFont *messageFont = [UIFont systemFontOfSize:15.f];
    UIFont *msgFont = [UIFont systemFontOfSize:12.f];

    //设置尺寸
    CGFloat maxTextWidth = SCREEN_WIDTH - 2*(horizontalSpaceToScreen) - 2 * horizontalSpaceToContentView;
    CGSize titleSize = [NSString sizeForString:title font:titleFont maxWidth:maxTextWidth];
    CGSize messageSize = [NSString sizeForString:_message font:messageFont maxWidth:maxTextWidth];
    CGSize msgSize = [NSString sizeForString:msg font:msgFont maxWidth:maxTextWidth];
    
    //标题框
    CGFloat titleLabelX = (SCREEN_WIDTH - 2*horizontalSpaceToScreen - titleSize.width)/2;
    CGFloat titleLabelY = topImgSize.height/2 + topSpaceViewToView;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleSize.width, titleSize.height)];
    titleLabel.text = title;
    titleLabel.font = titleFont;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    
    //内容框
    CGFloat messageLabelX = (SCREEN_WIDTH - 2*horizontalSpaceToScreen - messageSize.width)/2;
    CGFloat messageLabelY = titleLabelY + titleSize.height + topSpaceViewToView;
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(messageLabelX, messageLabelY, messageSize.width, messageSize.height)];
    messageLabel.text = _message;
    messageLabel.font = messageFont;
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    
    //提示框
    CGFloat msgLabelX = (SCREEN_WIDTH - 2*horizontalSpaceToScreen - msgSize.width)/2;
    CGFloat msgLabelY = messageLabelY + messageSize.height + topSpaceViewToView;
    UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(msgLabelX, msgLabelY, msgSize.width, msgSize.height)];
    msgLabel.text = msg;
    msgLabel.font = msgFont;
    msgLabel.textColor = [UIColor darkGrayColor];
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.numberOfLines = 0;
    
    //OK按钮
    CGFloat okBtnX = 5;
    CGFloat okBtnY = msgLabelY + msgSize.height + topSpaceViewToView;
    CGFloat okBtnW = SCREEN_WIDTH - 2*horizontalSpaceToScreen - 10;
    CGFloat okBtnH = 35;
    UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake(okBtnX, okBtnY, okBtnW, okBtnH)];
    okBtn.backgroundColor = [UIColor orangeColor];
    [okBtn setTitle:@"ok" forState:UIControlStateNormal];
    okBtn.layer.cornerRadius = 2.f;
    okBtn.layer.masksToBounds = YES;
    [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat detailToastViewX = 0;
    CGFloat detailToastViewY = topImgSize.height/2;
    CGFloat detailToastViewW = SCREEN_WIDTH - 2 * horizontalSpaceToScreen;
    CGFloat detailToastViewH = okBtnY + okBtnH + bottomSpaceToContentView;
    UIView *detailToastView = [[UIView alloc]initWithFrame:CGRectMake(detailToastViewX, detailToastViewY, detailToastViewW, detailToastViewH)];
    detailToastView.backgroundColor = [UIColor whiteColor];
    
    
    [detailToastView addSubview: titleLabel];
    [detailToastView addSubview: messageLabel];
    [detailToastView addSubview: msgLabel];
    [detailToastView addSubview: okBtn];
    
    
    CGFloat detailToastParentViewW = SCREEN_WIDTH - 2*horizontalSpaceToScreen;
    CGFloat detailToastParentViewH = topImgSize.height/2 + detailToastViewH;
    CGFloat detailToastParentViewX = (SCREEN_WIDTH - detailToastParentViewW)/2;
    CGFloat detailToastParentViewY = (SCREEN_HEIGHT - detailToastParentViewH)/2;
    UIView *detailToastParentView = [[UIView alloc]initWithFrame:CGRectMake(detailToastParentViewX, detailToastParentViewY, detailToastParentViewW, detailToastParentViewH)];
    
    [detailToastParentView addSubview:detailToastView];
    [detailToastParentView addSubview: topImgView];
    detailToastView.layer.cornerRadius = 5.f;
    detailToastView.layer.masksToBounds = YES;
    
    
    _detailToast = [[FFToast alloc]initCentreToastWithView:detailToastParentView autoDismiss:NO duration:0 enableDismissBtn:NO dismissBtnImage:nil];
    
    [_detailToast show];
    
}

-(void)okBtnClick{
    [_detailToast dismissCentreToast];
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
