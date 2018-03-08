//
//  DeviceListViewController.m
//  ione
//
//  Created by lkl on 2017/3/28.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "DeviceListViewController.h"
#import "AddPhoneViewController.h"
#import "LKLNetToll.h"
#import "MBProgressHUD+Add.h"
#import "PhoneListModel.h"
#import "UIViewController+hide.h"
#import "GetBondsModel.h"
#import "FoundTableViewCell.h"
#import "GetUserManagerModel.h"
@interface DeviceListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)NSString * tokenURL;

@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,strong)NSMutableArray * dataArr1;


@end

@implementation DeviceListViewController
-(NSMutableArray *)dataArr1{

    if (_dataArr1==nil) {
        _dataArr1=[NSMutableArray array];
    }
    return _dataArr1;
}
-(NSArray *)nameArr{
    
    if (_nameArr==nil) {
        _nameArr=[NSArray array];
    }
    return _nameArr;
}
-(NSArray *)phoneArr{
    
    if (_phoneArr==nil) {
        _phoneArr=[NSArray array];
    }
    return _phoneArr;
}
-(NSArray *)imeiArr{
    if (_imeiArr==nil) {
        _imeiArr=[NSArray array];
    }
    return _imeiArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title=@"手表通讯录";
     self.tokenURL=[userDefaults objectForKey:@"userTokentoken"];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UIBarButtonItem * rightButtonItem=[[UIBarButtonItem alloc]initWithTitle:Localized(@"➕") style:UIBarButtonItemStylePlain target:self action:@selector(loginAction:)];
    self.navigationItem.rightBarButtonItem=rightButtonItem;
    // Do any additional setup after loading the view from its nib.
 
    
   
    if ([userDefaults objectForKey:@"indexCellCell"]) {
        
        
        NSInteger index=[[userDefaults objectForKey:@"indexCellCell"] integerValue];
        self.nameLabel.text=self.nameArr[index];
         self.phoneLabel.text=self.phoneArr[index];
    }
    
    [self loadgetbounduser];
    
}
-(void)loadgetbounduser{

    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    
    LKLNetToll * net=[LKLNetToll shareInstance];
    
    self.tokenURL=[userDefaults objectForKey:@"userTokentoken"];
    
    NSString * getUserURL=[NSString stringWithFormat:@"%@token=%@&imei=%@",getBondeUsers,self.tokenURL,[userDefaults objectForKey:@"lastImei"]];
    [net GET:getUserURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"res=%@",responseObject);
        
        if ([responseObject[@"errcode"] integerValue]==0) {
            [self viewControllerHideHud];
            for (NSDictionary * dcit in responseObject[@"data"]) {
                
                GetUserManagerModel * model=[GetUserManagerModel initWithDict:dcit];
                [self.dataArr1 addObject:model];
                
            }
            [self.tabelView reloadData];
        }
        
        else{
            [self viewControllerHideHud];
            [self hideMbprogressManager];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self viewControllerHideHud];
        [self hideMbprogressNet];
    }];

}
-(void)loadTongXunLu{
    

         [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
        
    LKLNetToll * lkl=[LKLNetToll shareInstance];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
   
    NSString * GetDevicePBURL1=[NSString stringWithFormat:@"%@token=%@&imei=%@",GetDevicePBURL,self.tokenURL,[userDefaults objectForKey:@"lastImei"]];
    [lkl GET:GetDevicePBURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"通讯录%@",responseObject);

        if ([responseObject[@"errcode"] integerValue] ==0) {
              [self viewControllerHideHud];
            

            for (NSDictionary * dict in responseObject[@"data"]) {
                
                
                if (responseObject[@"data"] !=nil) {
                    
                  
                PhoneListModel * phoneListModel=[PhoneListModel phoneListModelWithDict:dict];
              
                [self.dataArr addObject:phoneListModel];
                
                
                }
                
            }
            [self.tabelView reloadData];
            
        }
        else{
             [self viewControllerHideHud];
            [self hideMbprogress];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [self viewControllerHideHud];
        [self hideMbprogressNet];
        
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   if (section==0) {
       
    return     self.dataArr1.count;
    }
   else{
        return self.dataArr.count;
   }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FoundTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"FoundTableViewCell" owner:self options:nil] lastObject];
        
    }
    if (indexPath.section==1) {
        PhoneListModel * model=self.dataArr[indexPath.row];
        
        cell.title.text=model.name;
        cell.time.text=model.number;
        cell.image.image=[UIImage imageNamed:@"圈子图标"];
    }
    else{
        GetUserManagerModel * model=self.dataArr1[indexPath.row];
        cell.title.text=model.nick;
        cell.time.text=model.name;
        cell.image.image=[UIImage imageNamed:@"圈子图标"];
    }
    
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
   if (section==0) {
        NSString * str=@"家人";
        return str;
   }
   else{
       NSString * str=@"朋友";
        return str;
   }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return ScreenWidth * 0.1;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}//为了防止第二组头视图有多的空白
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScreenWidth * 0.2;

}
-(void)loginAction:(UIButton *)button{
    AddPhoneViewController * addVC=[[AddPhoneViewController alloc]initWithNibName:@"AddPhoneViewController" bundle:nil];
    
    [self.navigationController pushViewController:addVC animated:YES];

}
//设置编辑风格EditingStyle
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.tabelView.editing)    //----通过表视图是否处于编辑状态来选择是左滑删除，还是多选删除。
//    {
//        //当表视图处于没有未编辑状态时选择多选删除
//        return UITableViewCellEditingStyleDelete| UITableViewCellEditingStyleInsert;
//    }
     if(indexPath.section==1)
    {
        //当表视图处于没有未编辑状态时选择左滑删除
        return UITableViewCellEditingStyleDelete;
    }
     else{
         return nil;
     }
}



//根据不同的editingstyle执行数据删除操作（点击左滑删除按钮的执行的方法）
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhoneListModel *model=self.dataArr[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        [_dataArr removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        LKLNetToll * net=[LKLNetToll shareInstance];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        self.tokenURL=[userDefaults objectForKey:@"userToken"];
        NSString * SetDevicePBURl1=[NSString stringWithFormat:@"%@&token=%@&imei=%@&indexes=%@&numbers=&names=",SetDevicePBURl,[userDefaults objectForKey:@"userTokentoken"],[userDefaults objectForKey:@"lastImei"],model.index];
        
        [net GET:SetDevicePBURl1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSLog(@"删除的响应%@",responseObject);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        

        
    }
    else if(editingStyle == (UITableViewCellEditingStyleDelete| UITableViewCellEditingStyleInsert))
    {
        
    }
    
}
//修改左滑删除按钮的title
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}





//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//        return  nil;
//    
//}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.dataArr=[NSMutableArray array];
      [self loadTongXunLu]; 
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
