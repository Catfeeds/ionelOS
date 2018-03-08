//
//  FangzousanViewController.m
//  ione
//
//  Created by lkl on 2017/3/30.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "FangzousanViewController.h"

@interface FangzousanViewController ()

@end

@implementation FangzousanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"防走散";
      self.view.backgroundColor=[UIColor whiteColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];//隐藏字

    self.automaticallyAdjustsScrollViewInsets=NO;
    //读取gif数据
      NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"phone6" ofType:@"gif"]];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,64, ScreenWidth,ScreenHeight-64)];
    //取消回弹效果
    webView.scrollView.bounces=NO;
    webView.backgroundColor = [UIColor clearColor];
    //设置缩放模式
    webView.scalesPageToFit = YES;
    //用webView加载数据
    [webView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight-40, ScreenWidth, 40)];
    label.backgroundColor = [UIColor redColor];
    [label setText:@"请确认您的手表支持蓝牙4.0功能"];
    label.textAlignment = NSTextAlignmentCenter;
     [self.view addSubview:webView];
    [self.view addSubview:label];
    
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
