//
//  NameViewController.h
//  ione
//
//  Created by zlt on 16/8/6.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@protocol nameViewContollerDelegate <NSObject>

@end
@interface NameViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UILabel *code;
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end
