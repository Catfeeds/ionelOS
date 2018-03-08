//
//  ManagerViewController.m
//  ione
//
//  Created by lkl on 2017/3/28.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "ManagerViewController.h"
#import "DeviceInfoViewController.h"
#import "DeviceListViewController.h"
#import "DistubTableViewController.h"
#import "LocationModeTableViewController.h"
#import "GetUSersViewController.h"
#import "ManagerTableViewCell.h"
#import "LKLNetToll.h"
#import "UIViewController+hide.h"
#import "ClockListViewController.h"
@interface ManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray * titleArr;

@end

@implementation ManagerViewController
-(NSArray *)nameArr{

    if (_nameArr==nil) {
        _nameArr=[NSArray array];
    }
    return _nameArr;
}
-(NSArray *)imeiArr{
    if (_imeiArr==nil) {
        _imeiArr=[NSArray array];
    }
    return _imeiArr;
}
-(NSArray *)phoneArr{
    
    if (_phoneArr==nil) {
        _phoneArr=[NSArray array];
    }
    return _phoneArr;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title=@"管理";
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];//隐藏字
     self.automaticallyAdjustsScrollViewInsets=NO;
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
    self.titleArr=@[@"手表信息",@"手表通讯录",@"免打扰",@"设置闹钟",@"定位模式",@"管理员设置",@"找手表",@"远程关机"];
    
    
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, ScreenHeight-49, ScreenWidth, 49);
    [button setTitle:@"解除绑定" forState:UIControlStateNormal];
    button.backgroundColor=[UIColor redColor];
    [button addTarget:self action:@selector(myButtontapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)myButtontapped:(UIButton *)button{
    
    UIAlertController * VC=[UIAlertController alertControllerWithTitle:nil message:@"是否解除绑定？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action1 =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        LKLNetToll * net=[LKLNetToll shareInstance];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
        
        NSString * unbindURL1=[NSString stringWithFormat:@"%@token=%@&imei=%@",unBindURL,[userDefaults objectForKey:@"userTokentoken"],[userDefaults objectForKey:@"lastImei"]];
        NSLog(@"解绑接口%@",unbindURL1);
        [net GET:unbindURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"解绑响应%@",responseObject);
            NSDictionary * dict=responseObject[@"data"];
            NSLog(@"字典%@",dict);
            [userDefaults setObject:nil forKey:@"lastImei"];
            if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
                [self viewControllerHideHud];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else{
                [self viewControllerHideHud];
                [self fail];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self viewControllerHideHud];
            
            
            [self hideMbprogressNet];
        }];
        
    }];
    
    UIAlertAction * action2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [VC addAction:action1];
    [VC addAction:action2];
    [self presentViewController:VC animated:YES completion:nil];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.titleArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ManagerTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"ManagerTableViewCell" owner:self options:nil] lastObject];
        if (indexPath.row <8) {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
       
    }
    cell.label.text=self.titleArr[indexPath.row];
    if (indexPath.row==0) {
        cell.image.image=[UIImage imageNamed:@"短信"];
    }
    else if (indexPath.row==1){
        cell.image.image=[UIImage imageNamed:@"通讯录"];
    
    }else if (indexPath.row==2){
    cell.image.image=[UIImage imageNamed:@"免打扰"];
    }else if (indexPath.row==3){
    cell.image.image=[UIImage imageNamed:@"闹钟"];
    }else if (indexPath.row==4){
    cell.image.image=[UIImage imageNamed:@"定位"];
    }else if (indexPath.row==5){
       cell.image.image=[UIImage imageNamed:@"管理员"];
    }
    else if (indexPath.row==6){
    cell.image.image=[UIImage imageNamed:@"找手表"];
    }
    else{
    cell.image.image=[UIImage imageNamed:@"关机"];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
  DeviceInfoViewController * deviceVC=      [[DeviceInfoViewController alloc]initWithNibName:@"DeviceInfoViewController" bundle:nil];
        [self.navigationController pushViewController:deviceVC animated:YES];
    }
    else if (indexPath.row==1){
        DeviceListViewController * list=[[DeviceListViewController alloc]initWithNibName:@"DeviceListViewController" bundle:nil];
        list.nameArr=self.nameArr;
        list.imeiArr=self.imeiArr;
        list.phoneArr=self.phoneArr;
        [self.navigationController pushViewController:list animated:YES];
    }
    else if (indexPath.row==2){
        DistubTableViewController * distub=[[DistubTableViewController alloc]initWithNibName:@"DistubTableViewController" bundle:nil];
        [self.navigationController pushViewController:distub animated:YES];
    } else if (indexPath.row==3){
        ClockListViewController * Vc=[[ClockListViewController alloc]init];
        
    [self.navigationController pushViewController:Vc animated:YES];
    }
    else if (indexPath.row==4){
    
        LocationModeTableViewController * VC=[[LocationModeTableViewController alloc]initWithNibName:@"LocationModeTableViewController" bundle:nil];
        [self.navigationController pushViewController:VC animated:YES];
    }
    else if (indexPath.row==5){
    
        GetUSersViewController * getUsers=[[GetUSersViewController alloc]init];
        getUsers.imei=[userDefaults objectForKey:@"lastImei"];
        [self.navigationController pushViewController:getUsers animated:YES];
    
    }
    else if (indexPath.row==6){
        UIAlertController * VC=[UIAlertController alertControllerWithTitle:nil message:@"是否发送指令" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
            LKLNetToll * net=[LKLNetToll shareInstance];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
            NSString * url=[NSString stringWithFormat:@"%@&token=%@&imei=%@",seekdeviceURL,[userDefaults objectForKey:@"userTokentoken"],[userDefaults objectForKey:@"lastImei"]];
            [net GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"errcode"] integerValue]==0) {
                    [self viewControllerHideHud];
                    [self succeed];
                    
                    
                    
                }
                else{
                    [self viewControllerHideHud];
                    [self fail];
                    
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
               [self viewControllerHideHud];
                [self hideMbprogressNet];
            }];
            
        }];
        UIAlertAction * action2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [VC addAction:action1];
        [VC addAction:action2];
        [self presentViewController:VC animated:YES completion:nil];
        

    
    }
    else if (indexPath.row==7){
        UIAlertController * VC=[UIAlertController alertControllerWithTitle:nil message:@"是否关闭手表" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
            LKLNetToll * net=[LKLNetToll shareInstance];
            [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
            NSString * url=[NSString stringWithFormat:@"%@&token=%@&imei=%@",shutdownURL,[userDefaults objectForKey:@"userTokentoken"],[userDefaults objectForKey:@"lastImei"]];
            [net GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"errcode"] integerValue]==0) {
                    [self viewControllerHideHud];
                    [self succeed];
                    
                    
                    
                }
                else{
                    [self viewControllerHideHud];
                    [self fail];
                    
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self viewControllerHideHud];
                [self hideMbprogressNet];
            }];

            
            
        }];
        UIAlertAction * action2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [VC addAction:action1];
        [VC addAction:action2];
        [self presentViewController:VC animated:YES completion:nil];
        

    
    }
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
