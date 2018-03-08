//
//  ListTableViewCell.h
//  ione
//
//  Created by lkl on 2017/4/25.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;

@end
