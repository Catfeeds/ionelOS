//
//  NameVCViewController.m
//  ione
//
//  Created by zlt on 16/10/21.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import "NameVCViewController.h"

#import "BaseNavigationViewController.h"
@interface NameVCViewController ()<UITextFieldDelegate>
@property(nonatomic,copy)NSString * tokenURL;
@end

@implementation NameVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title=@"设置名字";
    
   
    
    UILabel * label1=[[UILabel alloc]initWithFrame:CGRectMake(0,ScreenWidth * 0.2666666667, ScreenWidth * 0.4, ScreenWidth * 0.1)];
    label1.text=@"设备编号:";
    label1.textAlignment=NSTextAlignmentCenter;
    label1.font=[UIFont systemFontOfSize:18];
    
    [self.view addSubview:label1];
    
    _label2=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 0.4, ScreenWidth * 0.27, ScreenWidth * 0.6, ScreenWidth * 0.1)];

    _label2.font=[UIFont systemFontOfSize:18];
    
    
  _label2.text=self.str;
    
    [self.view addSubview:_label2];
    
    UILabel * label3=[[UILabel alloc]initWithFrame:CGRectMake(0, ScreenWidth * 0.54, ScreenWidth * 0.4, ScreenWidth * 0.1)];
    label3.text=@"设备名称:";
    label3.font=[UIFont systemFontOfSize:18];
    label3.textAlignment=NSTextAlignmentCenter;
     [self.view addSubview:label3];
    
    
   _textField=[[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth * 0.4, ScreenWidth * 0.54, ScreenWidth * 0.5, ScreenWidth * 0.1)];
    _textField.delegate=self;
    
   
    _textField.placeholder=@"请输入设备名字";
    _textField.borderStyle=UITextBorderStyleRoundedRect;
    
    
    
    [self.view addSubview:_textField];
    
 
    
    UIButton * qdButton=[UIButton buttonWithType:UIButtonTypeCustom];

    
     qdButton.frame=CGRectMake(0, 0,ScreenWidth * 0.72, ScreenWidth * 0.1);
    qdButton.center=CGPointMake(ScreenWidth/2, ScreenWidth * 0.94);
    [qdButton setTitle:@"确定" forState:UIControlStateNormal];
    [qdButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    qdButton.backgroundColor=[UIColor blueColor];
    [qdButton addTarget:self action:@selector(qdButtonActionx:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qdButton];
    
    

    
    [self requestData];
}
-(void)qdButtonActionx:(UIButton *)button{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    self.tokenURL=[userDefaults objectForKey:@"userToken"];
    NSString * nameURL1=[NSString stringWithFormat:@"%@token=%@&imei=%@&name=%@",nameURL,self.tokenURL,_label2.text,_textField.text];
    NSLog(@"名字%@",nameURL1);
    NSString * nameURL2=[nameURL1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:nameURL2 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"返回的是%@",responseObject);
        if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
            
           // [self showAlerViewWithTitle:nil Message:@"设置成功"];
            
            [userDefaults setObject:_textField.text forKey:@"nameText"];
        }
        else{
        
           [self showAlerViewWithTitle:nil Message:@"设置不成功，请重新设置"];
        
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self showAlerViewWithTitle:nil Message:@"设置不成功，请重新设置"];
    }];


     [self.navigationController popToRootViewControllerAnimated:YES];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)requestData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    self.tokenURL=[userDefaults objectForKey:@"userToken"];
    NSString * getinfoURL1=[NSString stringWithFormat:@"%@token=%@&imei=%@",getinfoURL,self.tokenURL,self.label2.text];
    
    NSLog(@"设备信息%@",getinfoURL1);
    
    NSString * getinfoURL2=[getinfoURL1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:getinfoURL2 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"信息响应%@",responseObject);
        
        if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
            NSDictionary *  dict=responseObject[@"data"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([dict[@"name"] isKindOfClass:[NSNull class]]) {
                     self.textField.text=@"";
                }
                else{
                self.textField.text=dict[@"name"];
                }
            });
          
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误%@",error);
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    
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
