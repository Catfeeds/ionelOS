//
//  LklDistubTableViewCell.m
//  ione
//
//  Created by lkl on 2017/3/29.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "LklDistubTableViewCell.h"

@implementation LklDistubTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.zeView=[[Lkllabelview alloc]initWithFrame:CGRectMake(30, ScreenHeight * 0.1 +10, ScreenWidth-60, ScreenHeight * 0.1 -15) segmentedCount:7 segmentedTitles:@[@"日",@"一",@"二",@"三",@"四",@"五",@"六"]];
    
    [self.contentView addSubview:self.zeView];
    

    self.beginLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 20, ScreenWidth * 0.3, ScreenHeight * 0.1 -25)];
    
    self.beginLabel.textAlignment=NSTextAlignmentCenter;
    self.beginLabel.layer.borderWidth=0.50;
    self.beginLabel.layer.borderColor=[UIColor blackColor].CGColor;
    self.beginLabel.layer.cornerRadius=5.0;
    self.beginLabel.layer.masksToBounds=YES;
    [self.contentView addSubview:_beginLabel];
    
    self.endlabel=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth -30-ScreenWidth * 0.3, 20, ScreenWidth * 0.3, ScreenHeight * 0.1 -25)];
    
    self.endlabel.textAlignment=NSTextAlignmentCenter;
    self.endlabel.layer.borderWidth=0.50;
    self.endlabel.layer.borderColor=[UIColor blackColor].CGColor;
    self.endlabel.layer.cornerRadius=5.0;
    self.endlabel.layer.masksToBounds=YES;
    [self.contentView addSubview:_endlabel];
    
    UIView * line=[[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2-5, 20 +self.beginLabel.frame.size.height/2, 10, 1)];
    line.backgroundColor=[UIColor blackColor];
    [self.contentView addSubview:line];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
