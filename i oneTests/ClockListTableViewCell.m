//
//  ClockListTableViewCell.m
//  ione
//
//  Created by lkl on 2017/5/12.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "ClockListTableViewCell.h"

@implementation ClockListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.zeView=[[Lkllabelview alloc]initWithFrame:CGRectMake(10, ScreenHeight * 0.1 +10, ScreenWidth-20, ScreenHeight * 0.1 -15) segmentedCount:7 segmentedTitles:@[@"日",@"一",@"二",@"三",@"四",@"五",@"六"]];
    
    [self.contentView addSubview:self.zeView];
    
    
    self.beginLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, ScreenWidth * 0.3, ScreenHeight * 0.1 -25)];
    
    self.beginLabel.textAlignment=NSTextAlignmentCenter;
    self.beginLabel.layer.borderWidth=0.50;
    self.beginLabel.layer.borderColor=[UIColor blackColor].CGColor;
    self.beginLabel.layer.cornerRadius=5.0;
    self.beginLabel.layer.masksToBounds=YES;
    [self.contentView addSubview:_beginLabel];
    
  
    self.textView=[[UILabel alloc]initWithFrame:CGRectMake(10,ScreenHeight * 0.1 +10 +  ScreenHeight * 0.1 -15 +15, ScreenWidth-20, 35)];
    self.textView.layer.cornerRadius=5.0;
    self.textView.layer.borderColor=[[UIColor blackColor] CGColor];
    self.textView.layer.borderWidth=0.5;
    self.textView.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:self.textView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setRepeats:(NSString *)repeats{


}
@end
