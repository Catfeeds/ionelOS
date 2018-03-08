//
//  SheZhiTableViewCell.m
//  ione
//
//  Created by lkl on 2017/5/3.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "SheZhiTableViewCell.h"

@implementation SheZhiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)tapped:(id)sender {
    [self.swtichdelegate switchTapped:sender];
}

@end
