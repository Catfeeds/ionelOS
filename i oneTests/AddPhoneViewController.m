//
//  AddPhoneViewController.m
//  ione
//
//  Created by lkl on 2017/3/29.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "AddPhoneViewController.h"
#import "LKLNetToll.h"
#import "UIViewController+hide.h"
#import "MBProgressHUD+Add.h"
#import "PhoneListModel.h"
@interface AddPhoneViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property(nonatomic,copy)NSString * tokenURL;
@end

@implementation AddPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加电话";
    self.addButton.layer.cornerRadius=10.0;
  
    

}

- (IBAction)addButtonTapped:(id)sender {
    [SVProgressHUD showWithStatus:@"上传中" maskType:SVProgressHUDMaskTypeClear];
    LKLNetToll * net=[LKLNetToll shareInstance];
    self.tokenURL=[userDefaults objectForKey:@"userTokentoken"];
    NSString * imei=[userDefaults objectForKey:@"lastImei"];
    
    NSString * SetDevicePBURl1=[NSString stringWithFormat:@"%@&token=%@&imei=%@&indexes=&numbers=%@&names=%@",SetDevicePBURl,self.tokenURL,imei ,self.phoneText.text,self.nameText.text];
    
    NSString * nameURL2=[SetDevicePBURl1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [net GET:nameURL2 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"errcode"] integerValue]==0) {
           
           
            
            
            NSString * GetDevicePBURL1=[NSString stringWithFormat:@"%@token=%@&imei=%@",GetDevicePBURL,self.tokenURL,[userDefaults objectForKey:@"lastImei"]];
            
            [net GET:GetDevicePBURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"通讯录%@",responseObject);
                
                if ([responseObject[@"errcode"] integerValue] ==0) {
                    
               [self viewControllerHideHud];
               [self.navigationController popViewControllerAnimated:YES];
          [userDefaults setObject:responseObject[@"data"] forKey:@"TongXunLuData"];
        
                    }
  
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
            }];
   
        }
        else{
        [self viewControllerHideHud];
            [MBProgressHUD showSuccess:@"上传失败" toView:self.view];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self viewControllerHideHud];
        [MBProgressHUD showSuccess:@"检查网络" toView:self.view];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
