//
//  NickViewController.m
//  ione
//
//  Created by lkl on 2017/5/11.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "NickViewController.h"
#import "LKLNetToll.h"
#import "UIViewController+hide.h"
@interface NickViewController ()<UITextViewDelegate>

@end

@implementation NickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title=@"修改昵称";
    self.qqq.layer.cornerRadius=5.0;
    self.qqq.layer.borderWidth=0.5;
    self.qqq.layer.borderColor=[[UIColor lightGrayColor] CGColor
                                ];
    self.button.layer.cornerRadius=5.0;
    
}
- (IBAction)tapped:(id)sender {
    LKLNetToll * net=[LKLNetToll shareInstance];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    if (self.qqq.text.length==0) {
        return;
    }
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    NSString * url=[NSString stringWithFormat:@"%@&token=%@&user_nick=%@",nickURL,[userDefaults objectForKey:@"userTokentoken"],self.qqq.text];
    NSString  *urlcoding=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [net GET:urlcoding parameters:nickURL success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"errcode"] integerValue]==0) {
            [self viewControllerHideHud];
            [self sucess];
            [userDefaults setObject:self.qqq.text forKey:@"nick"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else{
            [self viewControllerHideHud];
            [self hideMbprogressMode];
        
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
