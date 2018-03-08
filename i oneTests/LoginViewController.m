//
//  LoginViewController.m
//  XJiaZhuang
//
//  Created by 李晨侃 on 15/10/28.
//  Copyright © 2015年 李晨侃. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"


#import "CJMD5.h"
#import "LoginModel.h"
#import "MianViewController.h"
#import "BaseNavigationViewController.h"
#import "MBProgressHUD+Add.h"
#import "RePassWorldViewController.h"
#import "LKLNetToll.h"
@interface LoginViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *telTextField;
@property (strong, nonatomic) IBOutlet UITextField *pwdTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property(nonatomic,copy)NSString * tokenStr;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title=@"登录";
    self.telTextField.delegate=self;
    self.pwdTextField.delegate=self;
  
}

- (IBAction)loginBtnAction:(id)sender {
    
    if (self.telTextField.text.length != 11) {
        
        [MBProgressHUD showSuccess:@"请正确填写手机号" toView:self.view];
        return;
    }
    
    if (self.pwdTextField.text.length == 0) {
         [MBProgressHUD showSuccess:@"请正确填写密码" toView:self.view];
        return;
    }
    
    [self loginRequest];
}

- (IBAction)registBtnAction:(id)sender {
    RegistViewController *registController = [[RegistViewController alloc] initWithNibName:@"RegistViewController" bundle:nil];
    registController.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:registController animated:YES];

}
- (IBAction)forgetPwd:(id)sender {
    RePassWorldViewController *resetPasswordViewController = [[RePassWorldViewController alloc] initWithNibName:@"RePassWorldViewController" bundle:nil];
    resetPasswordViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:resetPasswordViewController animated:YES];

}

- (IBAction)goBackAction:(id)sender {
    

    
}

- (void)loginRequest {
    [MBProgressHUD showMessag:@"登陆中" toView:self.view];
    //创建请求工具对象
    LKLNetToll *newWorkTool = [LKLNetToll shareInstance];
    
    //设置网络请求标识
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

   NSString * userURL=self.telTextField.text;
    NSString * passwordURL=[CJMD5 md5HexDigest:self.pwdTextField.text];

        NSString * tokenURL=@"8c4e323f771e226e1a89c72ee6efedaf";
    NSString * loginURL1=[NSString stringWithFormat:@"%@username=%@&password=%@&token=%@",loginURL,userURL,passwordURL,tokenURL];
    NSLog(@"登录URL%@",loginURL1);
    
    [newWorkTool GET:loginURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * strErrcode=[responseObject[@"errcode"] stringValue];
        if ([strErrcode isEqualToString:@"0"]) {
            NSLog(@"登陆结果%@",responseObject);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            
            
           AppDelegate * appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
           appDelegate.isLogin=YES;
        
             self.tokenStr=responseObject[@"data"][@"token"];//用户token

            [userDefaults setObject:self.tokenStr forKey:@"userTokentoken"];
            
            [userDefaults setObject: self.telTextField.text forKey:@"USERname"];
            if ([responseObject[@"data"][@"user_nick"] isKindOfClass:[NSNull class]]) {
                
            }
            else{
            [userDefaults setObject:responseObject[@"data"][@"user_nick"] forKey:@"nick"];
            }
            appDelegate.window.rootViewController= [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
            
        }else if([strErrcode isEqualToString:@"-2"]){

            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [MBProgressHUD showSuccess:@"登录失败" toView:self.view];
            
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
          [MBProgressHUD hideHUDForView:self.view animated:YES];
         [MBProgressHUD showSuccess:@"登录失败,检查网络" toView:self.view];
        NSLog(@"错误%@",error);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
