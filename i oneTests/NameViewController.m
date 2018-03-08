//
//  NameViewController.m
//  ione
//
//  Created by zlt on 16/8/6.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import "NameViewController.h"


@interface NameViewController ()
@property(nonatomic,copy)NSString * tokenURL;

@end

@implementation NameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设备名称";
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)qdButtonAction:(id)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    self.tokenURL=[userDefaults objectForKey:@"userToken"];
    NSString * nameURL1=[NSString stringWithFormat:@"%@token=%@&imei=%@&name=%@",nameURL,self.tokenURL,self.code.text,_textField.text];
    NSLog(@"名字%@",nameURL1);
    NSString * nameURL2=[nameURL1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:nameURL2 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"返回的是%@",responseObject);
        if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
           
            [self showAlerViewWithTitle:nil Message:@"设置成功"];
            
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

         [self showAlerViewWithTitle:nil Message:@"设置不成功，请重新设置"];
    }];

    
}
@end
