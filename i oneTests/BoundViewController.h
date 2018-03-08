//
//  BoundViewController.h
//  ione
//
//  Created by zlt on 16/10/19.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "QRCodeViewController.h"

@interface BoundViewController : BaseViewController<toBoundDelegate>
@property(nonatomic,strong)UITextField * textField;
@property(nonatomic,strong)UIButton * smButton;
@property(nonatomic,strong)UIButton * qdButton;
@property(nonatomic,copy)NSString * str;
@property(nonatomic,copy)NSString * nameStr;
@end
