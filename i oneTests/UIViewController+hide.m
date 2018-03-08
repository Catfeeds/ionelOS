//
//  UIViewController+hide.m
//  ione
//
//  Created by lkl on 2017/4/18.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "UIViewController+hide.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD+Add.h"
@implementation UIViewController (hide)
-(void)viewControllerHideHud {
    [self performSelector:@selector(_hideHud) withObject:nil afterDelay:1.0f];
}
- (void)_hideHud {
    [SVProgressHUD dismiss];
}

-(void)succeed{
    
    [self performSelector:@selector(_succeed) withObject:nil afterDelay:1.0f];
    
}
-(void)_succeed{
    
    [MBProgressHUD showSuccess:@"成功" toView:self.view];
}
-(void)fail{
    
    [self performSelector:@selector(_fail) withObject:nil afterDelay:1.0f];
    
}


-(void)_fail{
    
    [MBProgressHUD showSuccess:@"失败" toView:self.view];
}

-(void)sucess{
    
    [self performSelector:@selector(_sucess) withObject:nil afterDelay:1.0f];
    
}
-(void)_sucess{
    
    [MBProgressHUD showSuccess:@"设置成功" toView:self.view];
}


-(void)hideMbprogress{

[self performSelector:@selector(hideIt) withObject:nil afterDelay:1.0f];

}
-(void)hideIt{

    [MBProgressHUD showSuccess:@"获取数据失败" toView:self.view];
}

-(void)hideMbprogressMode{
    
    [self performSelector:@selector(hideItMode) withObject:nil afterDelay:1.0f];
    
}
-(void)hideItMode{
    
    [MBProgressHUD showSuccess:@"设置失败" toView:self.view];
}
-(void)hideMbprogressNet{
 [self performSelector:@selector(hideItNet) withObject:nil afterDelay:1.0f];

}
-(void)hideItNet{
    
    [MBProgressHUD showSuccess:@"请检查网络" toView:self.view];
}
-(void)hideMbprogressManager{
    [self performSelector:@selector(hideItmanager) withObject:nil afterDelay:1.0f];
    
}
-(void)hideItmanager{
    
    [MBProgressHUD showSuccess:@"您不是管理员，没有权限查看" toView:self.view];
}
-(void)hideMbprogressBond{
    [self performSelector:@selector(hideItBond) withObject:nil afterDelay:1.0f];
    
}
-(void)hideItBond{
    
    [MBProgressHUD showSuccess:@"请先绑定设备" toView:self.view];
}
-(void)hideMbprogressrequest{
    [self performSelector:@selector(hideItrequest) withObject:nil afterDelay:1.0f];
    
}
-(void)hideItrequest{
    
    [MBProgressHUD showSuccess:@"请求发送成功" toView:self.view];
}
-(void)hideMbprogressrequestsucess{
    [self performSelector:@selector(hideItrequestsucess) withObject:nil afterDelay:1.0f];
    
}
-(void)hideItrequestsucess{
    
    [MBProgressHUD showSuccess:@"已经被绑定" toView:self.view];
}
-(void)hideMbprogressrequestfail{
    [self performSelector:@selector(hideItrequestfail) withObject:nil afterDelay:1.0f];
    
}
-(void)hideItrequestfail{
    
    [MBProgressHUD showSuccess:@"绑定失败" toView:self.view];
}
-(void)hideMbprogressrequestreview{
    [self performSelector:@selector(hideItrequestreview) withObject:nil afterDelay:1.0f];
    
}
-(void)hideItrequestreview{
    
    [MBProgressHUD showSuccess:@"等待管理员审核" toView:self.view];
}
-(void)hideMbprogressrequestReview{
    [self performSelector:@selector(hideItrequestReview) withObject:nil afterDelay:1.0f];
    
}
-(void)hideItrequestReview{
    
    [MBProgressHUD showSuccess:@"已经绑定" toView:self.view];
}
-(void)hideMbprogressrequestfour{
    [self performSelector:@selector(hideItrequestfour) withObject:nil afterDelay:1.0f];
    
}
-(void)hideItrequestfour{
    
    [MBProgressHUD showSuccess:@"最多设置四个免打扰" toView:self.view];
}

-(void)hideMbprogressrequestFail{
    [self performSelector:@selector(hideItrequestFail) withObject:nil afterDelay:1.0f];
    
}
-(void)hideItrequestFail{
    
    [MBProgressHUD showSuccess:@"请求失败" toView:self.view];
}
-(void)hideMbprogressrequestbond{
    [self performSelector:@selector(hideItrequestbond) withObject:nil afterDelay:1.0f];
    
}
-(void)hideItrequestbond{
    
    [MBProgressHUD showSuccess:@"申请绑定" toView:self.view];
}
@end
