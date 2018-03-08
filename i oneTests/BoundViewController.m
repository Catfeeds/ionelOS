//
//  BoundViewController.m
//  ione
//
//  Created by zlt on 16/10/19.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import "BoundViewController.h"
#import "SVProgressHUD.h"
#import "QRCodeViewController.h"

#import "NameVCViewController.h"
#import "VerViewController.h"
@interface BoundViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,copy)NSString * tokenURL;
@property(nonatomic,strong)NameVCViewController * nameVC;
@property(nonatomic,strong)UIButton * nameButton;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSArray * dataArr;
@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,strong)UIView * wView;
@end

@implementation BoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"绑定设备";
    
    _nameButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _nameButton.frame=CGRectMake(0, 0,ScreenWidth * 0.5333 ,ScreenWidth * 0.1 );
    _nameButton.center=CGPointMake(ScreenWidth/2, 64 + ScreenWidth * 0.05);
    [_nameButton setTitle:@"家庭成员" forState:UIControlStateNormal];
    
    _nameButton.backgroundColor=[UIColor blueColor];
    [_nameButton addTarget:self action:@selector(nameButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nameButton];
    
    
    self.textField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth * 0.533333, ScreenWidth * 0.1067)];
    self.textField.delegate=self;
    self.textField.center=CGPointMake(ScreenWidth/2, ScreenWidth * 0.53333);
    
    self.textField.borderStyle=UITextBorderStyleLine;
    self.textField.placeholder=@"请输入设备编号绑定";

    [self.view addSubview:self.textField];
    
    
    self.smButton=[UIButton buttonWithType:UIButtonTypeCustom];
  
    

   
    self.smButton.frame=CGRectMake(0, 0, ScreenWidth * 0.5333, ScreenWidth * 0.1);
    self.smButton.center=CGPointMake(ScreenWidth/2, ScreenWidth * 0.8);
    
    [self.smButton setTitle:@"扫描二维码绑定" forState:UIControlStateNormal];
    [self.smButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.smButton.backgroundColor=[UIColor blueColor];
    [self.smButton addTarget:self action:@selector(smButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.smButton];
   
    
    self.qdButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    self.qdButton.frame=CGRectMake(0, 0, ScreenWidth * 0.53333, ScreenWidth * 0.1);
    self.qdButton.center=CGPointMake(ScreenWidth/2, ScreenWidth * 1.06667);

    [self.qdButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.qdButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.qdButton.backgroundColor=[UIColor blueColor];
    [self.qdButton addTarget:self action:@selector(qdButtonAction1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.qdButton];
   
    
}
-(void)nameButtonTapped:(UIButton *)button{
    
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2 ,ScreenWidth/2) style:UITableViewStylePlain];
    self.tableView.center=CGPointMake(ScreenWidth/2, ScreenHeight/2);
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.dataArr=[NSArray array];
    self.dataArr=@[@"爷爷",@"奶奶",@"爸爸",@"妈妈"];
    _bgView=[[UIView alloc]initWithFrame:self.view.bounds];
    _bgView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.7];

    [[[UIApplication sharedApplication] keyWindow] addSubview:_bgView];
    

    
    [_bgView addSubview:self.tableView];
    

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (cell==nil) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    
    cell.textLabel.text=self.dataArr[indexPath.row];
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * string=self.dataArr[indexPath.row];
    
    [self.nameButton setTitle:string forState:UIControlStateNormal];
    [self.bgView removeFromSuperview ];
    self.bgView=nil;


}
//375  667
-(void)smButtonAction :(UIButton *)button{
    QRCodeViewController * qrVC=[[QRCodeViewController alloc]init];
     qrVC.toBoundDelegate=self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:qrVC];
    
    [self presentViewController:nav animated:YES completion:nil];

    
}
-(void)toBoundDelegate:(NSString *)str{
    _str=str;

}
-(void)qdButtonAction1 :(UIButton *)button{
    NSLog(@"%f_____%f",ScreenWidth,ScreenHeight);
    
   
     [self bindingEquipment];
   
}
-(void)bindingEquipment{
    
    if ([self.textField.text isEqual:@""]) {
        [SVProgressHUD showSuccessWithStatus:@"请输入账号" maskType:SVProgressHUDMaskTypeBlack];
    }
    else{
    self.tokenURL=[userDefaults objectForKey:@"userToken"];
    NSString * bindURL1=[NSString stringWithFormat:@"%@token1=%@&token2=8c4e323f771e226e1a89c72ee6efedaf&imei=%@&nick=%@",bindURL,self.tokenURL,self.textField.text,self.nameButton.titleLabel.text];

    NSLog(@"url=%@",bindURL1);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSString * bindurl1  =[bindURL1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:bindurl1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"绑定的响应结果%@",responseObject);
        
        if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
            [SVProgressHUD showSuccessWithStatus:@"成功" ];
            _nameVC=[[NameVCViewController alloc]init];
            
            if ((!self.textField.text || self.textField.text.length==0)) {
                _nameVC.str=nil;
            }
            else{
                
                _nameVC.str=self.textField.text;
                
            }
            
            [self.navigationController pushViewController:_nameVC  animated:YES];
            
            
            
        }
      
        
    else   if ([responseObject[@"errmsg"] isEqualToString:@"authorization require"]) {
        VerViewController * verVC=[[VerViewController alloc]initWithNibName:@"VerViewController" bundle:nil];
        verVC.imei=self.textField.text;
        [self.navigationController presentViewController:verVC animated:YES completion:nil];
        
        NSLog(@"已经绑定");
        
        
         
       }
       
       
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error=%@",error);
    }];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

@end
