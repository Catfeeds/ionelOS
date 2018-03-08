//
//  RegistViewController.h
//  XJiaZhuang
//
//  Created by 李晨侃 on 15/10/28.
//  Copyright © 2015年 李晨侃. All rights reserved.
//

#import "BaseViewController.h"
//@protocol RegisteViewControllerDelegate <NSObject>
//-(void)sendTelValue:(NSString *)value1 withPassword:(NSString *)value2;

//@end
typedef void (^ReturnTextBlock)(NSString * showtext);
@interface RegistViewController : BaseViewController
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
-(void)returnText:(ReturnTextBlock)block;
@end
