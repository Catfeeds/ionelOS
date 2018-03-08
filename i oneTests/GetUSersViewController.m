//
//  GetUSersViewController.m
//  ione
//
//  Created by lkl on 2017/3/9.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "GetUSersViewController.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "UIViewController+hide.h"
#import "LKLNetToll.h"
#import "GetUsersTableViewCell.h"
#import "GetUserManagerModel.h"
@interface GetUSersViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,copy)NSString * tokenURL;
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,strong)NSMutableArray * idArr;
@end

@implementation GetUSersViewController
-(NSMutableArray *)dataArr{
    if (_dataArr==nil) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)idArr{

    if (_idArr==nil) {
        _idArr=[NSMutableArray array];
    }
    return _idArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"绑定的用户";
  
  
    
    
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }

    [self.view addSubview:self.tableView];
      [self requsetData];
}
-(void)requsetData{
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    
    LKLNetToll * net=[LKLNetToll shareInstance];
    
    self.tokenURL=[userDefaults objectForKey:@"userTokentoken"];
    
    NSString * getUserURL=[NSString stringWithFormat:@"%@token=%@&imei=%@",getBondeUsers,self.tokenURL,self.imei];
    [net GET:getUserURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"res=%@",responseObject);

        if ([responseObject[@"errcode"] integerValue]==0) {
            [self viewControllerHideHud];
            for (NSDictionary * dcit in responseObject[@"data"]) {
                
                GetUserManagerModel * model=[GetUserManagerModel initWithDict:dcit];
                [self.dataArr addObject:model];
                
//                [self.dataArr addObject:dcit[@"name"]];
//                [self.idArr addObject:dcit[@"id"]];
            }
              [self.tableView reloadData];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    GetUsersTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"GetUsersTableViewCell" owner:self options:nil] lastObject];
        
    }
      cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    GetUserManagerModel * model=self.dataArr[indexPath.row];
    
    cell.phone.text=model.name;
    cell.nick.text=model.nick;
    if ([cell.phone.text isEqualToString:[userDefaults objectForKey:@"USERname"]]) {
         cell.image.image=[UIImage imageNamed:@"管理员-1"];
        
    }
   
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertController * VC=[UIAlertController alertControllerWithTitle:nil message:@"设置管理员" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action1=[UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        LKLNetToll * net=[LKLNetToll shareInstance];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        
         GetUserManagerModel * model=self.dataArr[indexPath.row];
        
        NSString * bindMasterURL=[NSString stringWithFormat:@"%@token=%@&imei=%@&user=%@",bindMaster,self.tokenURL,self.imei,[NSNumber numberWithInteger:model.ID]];
        
        [net GET:bindMasterURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"管理员%@",responseObject);
            if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
                
                [SVProgressHUD showSuccessWithStatus:@"成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];

     
    }];
    UIAlertAction * action2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
            }];
    [VC addAction:action1];
    [VC addAction:action2];
    [self presentViewController:VC animated:YES completion:nil];
    
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
