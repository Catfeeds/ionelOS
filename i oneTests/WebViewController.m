//
//  WebViewController.m
//  ione
//
//  Created by lkl on 2017/4/25.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"详情";
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets=NO;
    UIWebView * webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
    webview.backgroundColor=[UIColor whiteColor];
    
    
      
    NSURL *url = [NSURL URLWithString:_webStr];
    
    
    NSString * htmlstr = [[NSString alloc]initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlstr]]];
    [webview loadHTMLString:htmlstr baseURL:url];
    
    
    [self.view addSubview:webview];
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
