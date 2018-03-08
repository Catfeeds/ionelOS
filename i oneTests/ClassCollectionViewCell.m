//
//  ClassCollectionViewCell.m
//  i one
//
//  Created by zlt on 16/7/20.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import "ClassCollectionViewCell.h"

@implementation ClassCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.redView=[[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/5-13, 5, 8, 8)];
    self.redView.backgroundColor=[UIColor redColor];
    self.redView.layer.cornerRadius=4.0;
    self.redView.hidden=YES;
    [self.contentView addSubview:self.redView];
}

@end
