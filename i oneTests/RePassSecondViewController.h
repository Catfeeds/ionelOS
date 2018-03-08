//
//  RePassSecondViewController.h
//  ione
//
//  Created by lkl on 2017/4/7.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RePassSecondViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *passWordlabel;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UITextField *passWordText;
@property (weak, nonatomic) IBOutlet UIButton *qdButton;
@property(nonatomic,copy)NSString * imei;
@end
