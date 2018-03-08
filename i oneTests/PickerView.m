//
//  PickerView.m
//  ione
//
//  Created by lkl on 2017/5/9.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "PickerView.h"
@interface PickerView()

@property (nonatomic, strong) NSString *selectDate;
@end
@implementation PickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (PickerView *)instancePickerView{

    return [[[NSBundle mainBundle] loadNibNamed:@"View" owner:nil options:nil] lastObject];
}
- (void)awakeFromNib
{
  
    
    /**确定*/
    self.qdButton.layer.cornerRadius = 3;
    self.qdButton.layer.borderWidth = 1;
    self.qdButton.layer.borderColor = [[UIColor redColor] CGColor];
    self.qdButton.layer.masksToBounds = YES;
    
    /**取消按钮*/
    self.cancellButton.layer.cornerRadius = 3;
    self.cancellButton.layer.borderWidth = 1;
    self.cancellButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.cancellButton.layer.masksToBounds = YES;
}

/**
 *  设置时间格式，可更改HH、hh改变日期的显示格式，有12小时和24小时制
 *
 *  @return 时间格式
 */
- (NSString *)timeFormat
{
    NSDate *selected = [self.datePickerView date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:selected];
    return currentOlderOneDateStr;
}

- (void)animationbegin:(UIView *)view
{
    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画选项设定
    animation.duration = 0.1; // 动画持续时间
    animation.repeatCount = -1; // 重复次数
    animation.autoreverses = YES; // 动画结束时执行逆动画
    
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:0.9]; // 结束时的倍率
    
    // 添加动画
    [view.layer addAnimation:animation forKey:@"scale-layer"];
}


- (IBAction)cancellTapped:(id)sender {
    // 开始动画
    [self animationbegin:sender];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
     [self.delegate removedatepicker];
}
- (IBAction)qdButtonTapped:(id)sender {
    // 开始动画
    [self animationbegin:sender];
    self.selectDate = [self timeFormat];
    [self.delegate getSelectDate:self.selectDate type:self.type];
  [self.delegate removedatepicker];
}

@end
