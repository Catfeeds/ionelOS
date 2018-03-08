//
//  XiaoxiTableViewCell.m
//  ione
//
//  Created by lkl on 2017/4/8.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "XiaoxiTableViewCell.h"

@implementation XiaoxiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.redview.layer.cornerRadius=4.0;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
