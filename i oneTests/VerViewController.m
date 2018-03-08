//
//  VerViewController.m
//  ione
//
//  Created by lkl on 2016/12/30.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import "VerViewController.h"
#import "SVProgressHUD.h"
@interface VerViewController ()<UITextFieldDelegate>
@property(nonatomic,copy)NSString * tokenURL;
@end

@implementation VerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)QdButtonTapped:(id)sender {
    self.tokenURL=[userDefaults objectForKey:@"userToken"];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    NSString * BindReqURl1=[NSString stringWithFormat:@"%@&token1=%@&token2=8c4e323f771e226e1a89c72ee6efedaf&imei=%@&msg=%@",BindReqURL,self.tokenURL,self.imei,self.textField.text];
    NSString * string=[BindReqURl1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
           [manager GET:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
               NSLog(@"成功");
               [SVProgressHUD showSuccessWithStatus:@"正在请求绑定"];
           } failure:^(NSURLSessionDataTask *task, NSError *error) {
               
               [SVProgressHUD showErrorWithStatus:@"请求失败"];
               NSLog(@"请求绑定失败");
           }];
     [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)CancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES ];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    // 开始动画(定义了动画的名字)
    [UIView beginAnimations:@"viewUp" context:nil];
    // 设置时长
    [UIView setAnimationDuration:0.2f];
    // 设置动画内容
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - ScreenWidth *0.5, self.view.frame.size.width, self.view.frame.size.height);
    // 提交动画
    [UIView commitAnimations];
    
}
// 结束编辑
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // 开始动画(定义了动画的名字)
    [UIView beginAnimations:@"viewDown" context:nil];
    // 设置时长
    [UIView setAnimationDuration:0.2f];
    // 设置动画内容
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + ScreenWidth *0.5, self.view.frame.size.width, self.view.frame.size.height);
    // 提交动画
    [UIView commitAnimations];
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
