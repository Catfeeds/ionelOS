//
//  RePassSecondViewController.m
//  ione
//
//  Created by lkl on 2017/4/7.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "RePassSecondViewController.h"
#import "MBProgressHUD+Add.h"
#import "LKLNetToll.h"
@interface RePassSecondViewController ()

@end

@implementation RePassSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"重置密码";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)qdButtonTapped:(id)sender {
    if (_codeText.text.length ==0) {
        [MBProgressHUD showSuccess:@"请输入验证码" toView:self.view];
        return;
    }

    if (_passWordText.text.length == 0) {
          [MBProgressHUD showSuccess:@"请输入密码" toView:self.view];
        return;
    }
    
    [self usersupdatePassRequest];
}
-(void)usersupdatePassRequest{
    //创建请求工具对象
    LKLNetToll *newWorkTool = [LKLNetToll shareInstance];
    
    //设置网络请求标识
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
     NSString * tokenURL=@"8c4e323f771e226e1a89c72ee6efedaf";
    NSString * rePass=[NSString stringWithFormat:@"%@&token=%@&username=%@&password=%@&code=%@",rePassword,tokenURL,self.imei,_passWordText.text,_codeText.text];
    
    [newWorkTool GET:rePass parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject[@"errcode"] stringValue] isEqualToString:@"0"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            [MBProgressHUD showError:@"设置密码失败" toView:self.view];
        
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
