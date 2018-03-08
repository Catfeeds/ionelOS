//
//  AddDeviceViewController.h
//  ione
//
//  Created by lkl on 2017/3/29.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDeviceViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *imeiText;
@property (weak, nonatomic) IBOutlet UITextField *fmText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *reviewText;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *phoneView;

@end
