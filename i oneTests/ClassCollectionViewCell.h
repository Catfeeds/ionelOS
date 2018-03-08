//
//  ClassCollectionViewCell.h
//  i one
//
//  Created by zlt on 16/7/20.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic,strong)UIView * redView;

@end
