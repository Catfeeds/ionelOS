//
//  ClockListTableViewCell.h
//  ione
//
//  Created by lkl on 2017/5/12.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lkllabelview.h"
@interface ClockListTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * beginLabel;
@property(nonatomic,strong)UIButton * deleteButton;
@property(nonatomic,strong)Lkllabelview * zeView;
@property(nonatomic,strong)UILabel * textView;

@end
