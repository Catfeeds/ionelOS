//
//  NewsTableViewCell.h
//  ione
//
//  Created by zlt on 16/11/28.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *firstLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *status;

@end
