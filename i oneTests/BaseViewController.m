//
//  BaseViewController.m
//  项目三
//
//  Created by lx on 16/4/14.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import "BaseViewController.h"
#import "LaunchView.h"
#import "LKLNetToll.h"
@interface BaseViewController ()<RunPageControllerDelegate>
@property(nonatomic,strong)LaunchView *launchView;
@end

@implementation BaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.launchView=[[LaunchView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//    self.launchView.delegate=self;
//    [self.view addSubview:self.launchView];
   // self.view.backgroundColor=[UIColor colorWithRed:221.0/255.0 green:242.0/255.0 blue:162.0/255.0 alpha:1];
    self.view.backgroundColor=[UIColor whiteColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];//隐藏字
}
//-(void)OnButtonClick{
//
//    [UIView animateWithDuration:0.5 animations:^{
//        self.launchView.alpha = 0;
//    } completion:^(BOOL finished) {
//        [self.launchView removeFromSuperview];
//    }];
//
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showAlerViewWithTitle:(NSString*) title Message:(NSString*) message{

    UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
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
