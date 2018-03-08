//
//  DeviceListViewController.h
//  ione
//
//  Created by lkl on 2017/3/28.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic,strong)NSArray * nameArr;
@property(nonatomic,strong)NSArray * imeiArr;
@property(nonatomic,strong)NSArray * phoneArr;
@end
