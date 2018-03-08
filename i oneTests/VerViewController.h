//
//  VerViewController.h
//  ione
//
//  Created by lkl on 2016/12/30.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *QdButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *CancelButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property(nonatomic,copy)NSString * imei;
@end
