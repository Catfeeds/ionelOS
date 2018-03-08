//
//  LklDistubTableViewCell.h
//  ione
//
//  Created by lkl on 2017/3/29.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Lkllabelview.h"

//@protocol deleteDistubDelegate <NSObject>
//
//-(void)deleteDistub:(UIButton *)button;
//
//@end

@interface LklDistubTableViewCell : UITableViewCell


@property(nonatomic,strong)Lkllabelview * zeView;


//@property(nonatomic,weak)id <deleteDistubDelegate>deleteDelegate;

@property(nonatomic,strong)UILabel * beginLabel;
@property(nonatomic,strong)UILabel * endlabel;


@end
