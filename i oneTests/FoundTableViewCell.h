//
//  FoundTableViewCell.h
//  ione
//
//  Created by lkl on 2017/4/10.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myAticle.h"
@interface FoundTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
