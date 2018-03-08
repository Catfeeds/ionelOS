//
//  MyDisturbViewController.h
//  ione
//
//  Created by lkl on 2017/5/2.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mydisturbview.h"
@interface MyDisturbViewController : UIViewController

@property(nonatomic,copy)NSString * begin;
@property(nonatomic,copy)NSString * end;
@property(nonatomic,strong)Mydisturbview * lklview;
@property(nonatomic,copy)NSString * repeat;

@property(nonatomic,assign)NSInteger index;

@property(nonatomic,copy)NSString * endDate;
@property(nonatomic,copy)NSString * beginDate;
@end
