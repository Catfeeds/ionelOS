//
//  BindViewController.m
//  ione
//
//  Created by lkl on 2017/2/28.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "BindViewController.h"
#import "NameVCViewController.h"
#import "QRCodeViewController.h"
#import "VerViewController.h"
@interface BindViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSArray* dataArr;
@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,copy)NSString * tokenURL;
@property(nonatomic,strong)NameVCViewController * nameVC;
@property(nonatomic,assign)BOOL keyBoardlsVisible;
@end

@implementation BindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image=[UIImage imageNamed:@"icon"];
    self.title=@"绑定";
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
  }
-(void)keyboardDidHide:(NSNotification *)notification
{
    NSLog(@"*-----HideKeyBoard");
    _keyBoardlsVisible = NO;
}

-(void)keyboardDidShow:(NSNotification *)notification
{
    NSLog(@"*-----ShowKeyBoard");
    _keyBoardlsVisible = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}
-(void)viewWillLayoutSubviews{

    self.qdButton.layer.cornerRadius=15.0;
    self.fmButton.layer.cornerRadius=15.0;
    self.smButton.layer.cornerRadius=15.0;
    self.codeText.layer.cornerRadius=2.0;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)smButtonTapped:(id)sender {
    
    QRCodeViewController * qrVC=[[QRCodeViewController alloc]init];
    qrVC.toBoundDelegate=self;
    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:qrVC];
//    
//    [self presentViewController:nav animated:YES completion:nil];
    
    [self.navigationController pushViewController:qrVC animated:YES];
}
-(void)toBoundDelegate:(NSString *)str{
    _str=str;
    
}
- (IBAction)qdButtontapped:(id)sender {
     [self bindingEquipment];
    if (_keyBoardlsVisible==YES) {
        

        [self.view endEditing:YES];
    }
    
    }

- (IBAction)fmButtonTapped:(id)sender {
     self.dataArr=[NSArray array];
     self.dataArr=@[@"爷爷",@"奶奶",@"爸爸",@"妈妈",@"自定义"];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenHeight/3 ,ScreenWidth * 0.15 * self.dataArr.count + ScreenWidth * 0.2) style:UITableViewStylePlain];
    self.tableView.center=CGPointMake(ScreenWidth/2, ScreenHeight/2);
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
   
   
    self.tableView.scrollEnabled=NO;
   
    
    _bgView=[[UIView alloc]initWithFrame:self.view.bounds];
    _bgView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:_bgView];
    
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
  [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"head1"];
    [_bgView addSubview:self.tableView];
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView insertSubview:btn belowSubview:self.tableView];
}
-(void)buttonTapped:(UIButton *)button{

    [UIView animateWithDuration:0.2 animations:^{
        [self.bgView removeFromSuperview];
        self.bgView=nil;
    }];

}
//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//    UITouch * touch=[touches anyObject];
//CGPoint  ponit1= [touch locationInView:self.bgView];
//    
//    CGRect rect1=self.tableView.bounds;
//    
//    
//    if (!CGRectContainsPoint(rect1,ponit1)) {
//        [self.bgView removeFromSuperview];
//        self.bgView=nil;
//    }
//    
//    
//}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UITableViewHeaderFooterView * view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"head1" ];
    
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenHeight/3, ScreenWidth * 0.2-5)];
    label.text=@"选择类型";
    label.textColor=[UIColor brownColor];
    label.backgroundColor=[UIColor whiteColor ];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont boldSystemFontOfSize:17];
    [view.contentView addSubview:label];
    
    return view;
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ScreenWidth * 0.2;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return ScreenWidth * 0.15;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    cell.textLabel.text=self.dataArr[indexPath.row];
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * string=self.dataArr[indexPath.row];
    if (indexPath.row !=4) {
       [self.fmButton setTitle:string forState:UIControlStateNormal];
    }
   
    [self.bgView removeFromSuperview ];
    self.bgView=nil;
    if (indexPath.section==0 && indexPath.row==4) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *VC = [UIAlertController alertControllerWithTitle:@"关系" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [VC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
     
        }];
        
        UIAlertAction *aa = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"确定");
       self.fmButton.titleLabel.text=  VC.textFields[0].text;
            
        }];
        UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        
        [VC addAction:aa];
        [VC addAction:a1];
        [self presentViewController:VC animated:YES completion:nil];
     
    }

    
    
}
-(void)bindingEquipment{
    
    if ([self.codeText.text isEqual:@""]) {
        [SVProgressHUD showSuccessWithStatus:@"请输入账号" maskType:SVProgressHUDMaskTypeBlack];
    }
    else{
        self.tokenURL=[userDefaults objectForKey:@"userToken"];
        NSString * bindURL1=[NSString stringWithFormat:@"%@token1=%@&token2=8c4e323f771e226e1a89c72ee6efedaf&imei=%@&nick=%@",bindURL,self.tokenURL,self.codeText.text,self.fmButton.titleLabel.text];
        
        NSLog(@"url=%@",bindURL1);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        NSString * bindurl1  =[bindURL1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [manager GET:bindurl1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"绑定的响应结果%@",responseObject);
         
            NSString * strerrcode=[[responseObject objectForKey:@"errcode"] stringValue];
            if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
                 [SVProgressHUD showSuccessWithStatus:@"成功" ];
                //[self getBonds];
                _nameVC=[[NameVCViewController alloc]init];
                
                
                
                if ((!self.codeText.text || self.codeText.text.length==0)) {
                    _nameVC.str=nil;
                }
                else{
                    
                    _nameVC.str=self.codeText.text;
                    
                } 
                
                [self.navigationController pushViewController:_nameVC  animated:YES];
                
                
                
            }
            

            else   if ([strerrcode isEqualToString:@"-9"]) {
                VerViewController * verVC=[[VerViewController alloc]initWithNibName:@"VerViewController" bundle:nil];
                verVC.imei=self.codeText.text;
                [self.navigationController presentViewController:verVC animated:YES completion:nil];
                
                NSLog(@"已经绑定");
   
            }
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"error=%@",error);
        }];
    }
}
-(void)getBonds{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    self.tokenURL=[userDefaults objectForKey:@"userToken"];
    
    
    
    NSString * getBondsURL1=[NSString stringWithFormat:@"%@token=%@",getBondsURL,self.tokenURL];
    NSLog(@"设备%@",getBondsURL1);
    [manager GET:getBondsURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
            NSMutableArray *  arr= responseObject[@"data"];
            
            [userDefaults setValue:arr forKey:@"getBonds"];
            
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
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
@end
