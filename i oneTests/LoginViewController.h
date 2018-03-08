//
//  LoginViewController.h
//  XJiaZhuang
//
//  Created by 李晨侃 on 15/10/28.
//  Copyright © 2015年 李晨侃. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^ReturnTextBlock)(NSString * showtext);
@protocol LoginDelegate <NSObject>
-(void)loginSuccess:(NSString *)token;
@end
@interface LoginViewController : BaseViewController
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
@property(nonatomic,strong)id <LoginDelegate>loginDelegate;
@end
