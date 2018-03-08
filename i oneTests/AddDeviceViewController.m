//
//  AddDeviceViewController.m
//  ione
//
//  Created by lkl on 2017/3/29.
//  Copyright © 2017年 lkl. All rights reserved.
//


#import "AddDeviceViewController.h"
#import "QRCodeViewController.h"
#import "ClassCollectionViewCell.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD+Add.h"
#import "LKLNetToll.h"
#import "GetBondsModel.h"
#import "UIViewController+hide.h"
@interface AddDeviceViewController ()<UITextFieldDelegate,toBoundDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIButton *SMButton;
@property (weak, nonatomic) IBOutlet UILabel *guanxiLabel;
@property(nonatomic,strong)UIButton * xialaButton;
@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout * flowLayOut;
@property(nonatomic,strong)NSArray * titleArr;
@property(nonatomic,strong)UIView * collectionBgView;//集合视图的背景图
@property(nonatomic,strong)UITextField * reViewText;
@property(nonatomic,strong)UITextField * nameTextfield;
@property(nonatomic,strong)NSString * tokenURL;
@property(nonatomic,strong)NSMutableArray * arr1;
@property(nonatomic,strong)NSMutableArray * nameArr;
@end

@implementation AddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arr1=[NSMutableArray array];
    self.nameArr=[NSMutableArray array];
     self.tokenURL=[userDefaults objectForKey:@"userTokentoken"];
    self.title=@"添加手表";
    self.titleArr=@[@"爸爸",@"妈妈",@"爷爷",@"奶奶",@"叔叔",@"阿姨",@"其它"];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets=NO;
   self.guanxiLabel.userInteractionEnabled=YES;
  
    self.addButton.layer.cornerRadius=10.0;
    self.addButton.layer.masksToBounds=YES;
    //self.guanxiLabel.layer.borderWidth=0.5;
    //self.guanxiLabel.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    //self.guanxiLabel.layer.masksToBounds=YES;
    //self.guanxiLabel.layer.cornerRadius=5.0;
   
    
    //self.imeiText.layer.borderWidth=0.5;
    //self.imeiText.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    //self.imeiText.layer.masksToBounds=YES;
    //self.imeiText.layer.cornerRadius=5.0;
    
    self.xialaButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    self.xialaButton.frame=CGRectZero;
    
    [self.xialaButton setBackgroundImage:[UIImage imageNamed:@"下翻"] forState:UIControlStateNormal];
    [self.xialaButton addTarget:self action:@selector(xialaButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.guanxiLabel addSubview:self.xialaButton];

   }



//创建要在viewdidiload里面修改范围可以在这个方法里面
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
     NSLog(@"关系的宽%f %f %f",self.guanxiLabel.bounds.size.width,ScreenWidth,ScreenHeight);
    
    self.xialaButton.frame=CGRectMake(self.guanxiLabel.bounds.size.width-25, 5, 20, 20);
 
}
-(void)xialaButtonTapped:(UIButton *)button{
    self.collectionBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
      self.collectionBgView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.collectionBgView];
    UIButton * bgButton=[UIButton buttonWithType:UIButtonTypeCustom];
    bgButton.backgroundColor=[UIColor clearColor];
    bgButton.frame=self.collectionBgView.frame;
    [bgButton addTarget:self action:@selector(bgButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.collectionBgView addSubview:bgButton];//透明的按钮
    
    self.flowLayOut=[[UICollectionViewFlowLayout alloc]init];
    self.flowLayOut.minimumLineSpacing=1;
    self.flowLayOut.minimumInteritemSpacing=1;
    
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0,self.guanxiLabel.frame.origin.y, ScreenWidth,
                                                                          ScreenWidth/2) collectionViewLayout:self.flowLayOut];
    
    self.collectionView.backgroundColor=[UIColor whiteColor];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    
    
    [self.collectionBgView addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ClassCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];

}
#pragma  mark __-透明的按钮被电击

-(void)bgButtonTapped:(UIButton *)button{
    [self.collectionBgView removeFromSuperview];
    self.collectionBgView=nil;

}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
        ClassCollectionViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.text=self.titleArr[indexPath.item];
        cell.backgroundColor=[UIColor whiteColor];
        cell.imageView.image=[UIImage imageNamed:@"星星"];
         return cell;
    
   
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(1,0,1, 0);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return CGSizeMake((ScreenWidth -3)/4 ,(ScreenWidth/2-3)/2);
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
    
    if (indexPath.item<=5) {
        [self.collectionBgView removeFromSuperview];
        self.collectionBgView=nil;
        self.guanxiLabel.text=self.titleArr[indexPath.item];
    }
    else{
        UIView * qdView=[[UIView alloc]initWithFrame:CGRectMake(0,self.guanxiLabel.frame.origin.y, ScreenWidth,
                                                                ScreenWidth/2)];
        
        qdView.backgroundColor=[UIColor whiteColor];
        
        [self.collectionBgView addSubview:qdView];
        
        [self.collectionView removeFromSuperview];
        self.collectionView=nil;
        
        _nameTextfield=[[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth/4, qdView.bounds.size.height/2-15-10, ScreenWidth/2, 30)];
        _nameTextfield.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        _nameTextfield.layer.borderWidth=0.5;
        _nameTextfield.layer.cornerRadius=5.0;
        _nameTextfield.layer.masksToBounds=YES;
        
        //_nameTextfield.placeholder=@"输入名称";
        _nameTextfield.delegate=self;
        
        [qdView addSubview:_nameTextfield];
        
        UIButton * qdButton=[UIButton buttonWithType:UIButtonTypeCustom];
        qdButton.frame=CGRectMake(ScreenWidth/4, qdView.bounds.size.height/2 +10, ScreenWidth/2, 30);
        [qdButton setTitle:@"确定" forState:UIControlStateNormal];
        [qdButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        qdButton.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        qdButton.layer.borderWidth=0.5;
        qdButton.layer.cornerRadius=5.0;
        qdButton.layer.masksToBounds=YES;
        [qdButton addTarget:self action:@selector(qdClicked:) forControlEvents:UIControlEventTouchUpInside];
        [qdView addSubview:qdButton];
        
        
    }
    
  
}

-(void)qdClicked:(UIButton *)button{

    [self.collectionBgView removeFromSuperview];
    self.collectionBgView=nil;

    if (_nameTextfield.text.length !=0) {
        
        self.guanxiLabel.text=_nameTextfield.text;
        
        
    }
}
- (IBAction)addButontapped:(id)sender {
     if([self.addButton.titleLabel.text isEqualToString:@"完成"]){
         
         if (self.addButton.tag==101) {
             [self.navigationController popViewControllerAnimated:YES];
         }
         
         else{
         if (self.nameText.text.length==0) {
             [MBProgressHUD showSuccess:@"输入名字" toView:self.view];
             return;
         }
         if (self.phoneText.text.length==0) {
             [MBProgressHUD showSuccess:@"输入号码" toView:self.view];
             return;
         }
         
         [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
         //创建请求工具对象
         LKLNetToll *newWorkTool = [LKLNetToll shareInstance];
         
         //设置网络请求标识
         [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
         
        
         NSString * nameURL1=[NSString stringWithFormat:@"%@token=%@&imei=%@&name=%@&phone=%@",nameURL,self.tokenURL,self.imeiText.text,self.nameText.text,self.phoneText.text];
         NSLog(@"名字%@",nameURL1);
         NSString * nameURL2=[nameURL1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
         [newWorkTool GET:nameURL2 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
             
             NSLog(@"返回的是%@",responseObject);
             NSString * strerrcode=[[responseObject objectForKey:@"errcode"] stringValue];
             if ([strerrcode isEqualToString:@"0"]){
  
 
                         [self viewControllerHideHud];
 

                          [self.navigationController popViewControllerAnimated:YES];
 
                     }
                     else{
                         [self viewControllerHideHud];
                          [self hideMbprogressMode];
                         
                     }
     
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
               [self viewControllerHideHud];
             [self hideMbprogressMode];
             
             
         }];
         }
   
    }
   else  if ([self.addButton.titleLabel.text isEqualToString:@"请求"]){

       if (self.reViewText.text.length==0) {
           [MBProgressHUD showSuccess:@"请输入申请" toView:self.view];
           return;
       }
         [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
       //创建请求工具对象
       LKLNetToll *newWorkTool = [LKLNetToll shareInstance];
       
       //设置网络请求标识
       [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
       
        NSString * BindReqURl1=[NSString stringWithFormat:@"%@&token1=%@&token2=8c4e323f771e226e1a89c72ee6efedaf&imei=%@&msg=%@",BindReqURL,self.tokenURL,self.imeiText.text,self.reviewText.text];
        NSString * string=[BindReqURl1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [newWorkTool GET:string parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString * strerrcode=[[responseObject objectForKey:@"errcode"] stringValue];
            if ([strerrcode isEqualToString:@"0"]){
            NSLog(@"成功");
                [self viewControllerHideHud];
                [self hideMbprogressrequest];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                            self.nameLabel.hidden=YES;
                            self.nameText.hidden=YES;
                    self.nameView.hidden=YES;
                            self.phoneText.hidden=YES;
                            self.phoneLabel.hidden=YES;
                    self.phoneView.hidden=YES;
                            self.reViewText.hidden=YES;
                            [self.addButton setTitle:@"完成" forState:UIControlStateNormal];
                    self.addButton.tag=101;
                    
                });
            }
            else{
                [self viewControllerHideHud];
                [self hideMbprogressrequestFail];
                
                
            }
 
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self viewControllerHideHud];
             [self hideMbprogressrequestFail];
            NSLog(@"请求绑定失败");
        }];

        
    }
   else{
       self.imeiText.enabled = NO;
       self.SMButton.enabled = NO;
       self.xialaButton.enabled = NO;
       
    if ([self.imeiText.text isEqual:@""]) {
       [MBProgressHUD showSuccess:@"输入账号或者扫描"];
        return;
       
    }
       if (self.guanxiLabel.text.length==0) {
         [MBProgressHUD showSuccess:@"选择关系"];
           return;
       }
    

         [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
        
        NSString * bindURL1=[NSString stringWithFormat:@"%@token1=%@&token2=8c4e323f771e226e1a89c72ee6efedaf&imei=%@&nick=%@",bindURL,self.tokenURL,self.imeiText.text,self.guanxiLabel.text];
        
        NSLog(@"url=%@",bindURL1);
        
       //创建请求工具对象
       LKLNetToll *newWorkTool = [LKLNetToll shareInstance];
       
       //设置网络请求标识
       [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString * bindurl1  =[bindURL1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [newWorkTool GET:bindurl1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"绑定的响应结果%@",responseObject);
            
            NSString * strerrcode=[[responseObject objectForKey:@"errcode"] stringValue];
            if ([strerrcode isEqualToString:@"0"] || [strerrcode isEqualToString:@"1"] ) {

                 [self viewControllerHideHud];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.nameLabel.hidden=NO;
                    self.nameText.hidden=NO;
                    self.nameView.hidden=NO;
                    self.phoneText.hidden=NO;
                    self.phoneLabel.hidden=NO;
                    self.phoneView.hidden=NO;
                    
                    [self.addButton setTitle:@"完成" forState:UIControlStateNormal];
                    self.addButton.tag=100;
                    
                });

            }

            else   if ([strerrcode isEqualToString:@"-9"]){
                
                [self viewControllerHideHud];
                
                [self hideMbprogressrequestbond];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.addButton setTitle:@"请求" forState:UIControlStateNormal];
                    _reViewText=[[UITextField alloc]initWithFrame:CGRectMake(10, self.guanxiLabel.frame.origin.y + 30 +15, ScreenWidth-20, ScreenWidth/2)];
                    _reViewText.contentVerticalAlignment=UIControlContentVerticalAlignmentTop;
                    _reViewText.placeholder=@"该账号已被绑定，发送请求绑定信息";
                    
                    _reViewText.delegate=self;
                    _reViewText.borderStyle=UITextBorderStyleRoundedRect;
                    [self.view addSubview:_reViewText];
                });
            }
            
            else   if ([strerrcode isEqualToString:@"-14"]){
                
                [self viewControllerHideHud];
                [self hideMbprogressrequestreview];
                
            
            }

            else{
              [self viewControllerHideHud];
                
                [self hideMbprogressrequestfail];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"error=%@",error);
              [self viewControllerHideHud];
            [self hideMbprogressrequestFail];
        }];
   }
}
- (IBAction)SMButtonTapped:(id)sender {
    QRCodeViewController * qrVC=[[QRCodeViewController alloc]init];
    qrVC.toBoundDelegate=self;
    
    qrVC.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:qrVC animated:YES];
}
-(void)fromImeiToAdddevice:(NSString *)str{
    self.imeiText.text=str;
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
