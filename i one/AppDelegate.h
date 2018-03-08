//
//  AppDelegate.h
//  i one
//
//  Created by zlt on 16/7/13.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModel.h"
#import "DataBase.h"
#import "ChatDAtabase.h"
static NSString *appKey = @"8708d22a2777844638baeb96";
static NSString *channel = @"App Store";
static BOOL isProduction = FALSE;
@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,assign)BOOL isLogin;
@property(nonatomic,strong)LoginModel * loginModel;
@property(nonatomic,strong)DataBase * dataBase;
@property(nonatomic,strong)NSMutableArray * arr1;
@property(nonatomic,strong)ChatDAtabase * chatDatabase;
@property(nonatomic,strong)NSArray * imeiArr;//userdefult保存的设备号shuzu
@property(nonatomic,copy)NSString * username;//用户名
@end

