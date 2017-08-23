//
//  AGRDateCell.m
//  AgrIntel
//
//  Created by 实验室 on 2017/8/18.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import "AGRDateCell.h"
#import "AGRDate.h"

@interface AGRDateCell()
//日期
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation AGRDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype)AGRDateCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"AGRDateCell" owner:nil options:nil] lastObject];
}

-(void)setText:(AGRDate *)text
{
    _text = text;
    
    //日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    //设置日期格式
    fmt.dateFormat = @"yyyy-MM-dd";
    //传感器创建数据的时间
    NSDate *date = [fmt dateFromString:text.day];
    fmt.dateFormat = @"yyyy年MM月dd日";
    self.dateLabel.text = [fmt stringFromDate:date];
//    self.dateLabel.text = [NSString stringWithFormat:@"%@",text.day];
    
}
#pragma cell的间距
-(void)setFrame:(CGRect)frame
{
    static CGFloat margin = 10;
    frame.origin.x = 2 *margin;
    frame.size.width -= 4 *margin;
    frame.size.height -= margin;
    frame.origin.y += margin;
    
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
