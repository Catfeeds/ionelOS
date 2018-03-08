//
//  RePassWorldViewController.m
//  ione
//
//  Created by lkl on 2017/4/7.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "RePassWorldViewController.h"
#import "MBProgressHUD+Add.h"
#import "RePassSecondViewController.h"
#import "LKLNetToll.h"
@interface RePassWorldViewController ()

@end

@implementation RePassWorldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"重置密码";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)codeButtonTapped:(id)sender {
    if (self.phoneText.text.length==0) {
        [MBProgressHUD showSuccess:@"请输入手机号" toView:self.view];
    }
    else{
        //创建请求工具对象
        LKLNetToll *newWorkTool = [LKLNetToll shareInstance];
        
        //设置网络请求标识
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString * tokenURL=@"8c4e323f771e226e1a89c72ee6efedaf";
        
        NSString * getVerrifyURl=[[NSString stringWithFormat:@"%@&phone=%@&token=%@",getVerifyCodeURL,self.phoneText.text,tokenURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //[newWorkTool GET:getVerrifyURl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            //NSLog(@"发送验证码%@",responseObject);
            
            RePassSecondViewController * VC=[[RePassSecondViewController alloc]initWithNibName:@"RePassSecondViewController" bundle:nil];
            VC.imei=self.phoneText.text;
            [self.navigationController pushViewController:VC animated:YES];
            
        //} failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        //}];

    
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
