//
//  BindViewController.h
//  ione
//
//  Created by lkl on 2017/2/28.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeViewController.h"
@interface BindViewController : UIViewController<toBoundDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *fmButton;
@property (weak, nonatomic) IBOutlet UIButton *smButton;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UIButton *qdButton;
@property(nonatomic,copy)NSString * str;
@end
