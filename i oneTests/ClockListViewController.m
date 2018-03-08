//
//  ClockListViewController.m
//  ione
//
//  Created by lkl on 2017/5/11.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "ClockListViewController.h"
#import "AddClockViewController.h"
#import "ClockListTableViewCell.h"
#import "LKLNetToll.h"
#import "UIViewController+hide.h"
#import "ClockModel.h"
#import "EditClockViewController.h"
@interface ClockListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation ClockListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"闹钟列表";
    self.automaticallyAdjustsScrollViewInsets=NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    
    UIBarButtonItem * right=[[UIBarButtonItem alloc]initWithTitle:@"➕" style:UIBarButtonItemStylePlain target:self action:@selector(tapped)];
    
    self.navigationItem.rightBarButtonItem = right;
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
     self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
[self.view addSubview:self.tableView];
   
}
-(void)tapped{
    AddClockViewController * VC=[[AddClockViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClockListTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
     cell   =[[[NSBundle mainBundle] loadNibNamed:@"ClockListTableViewCell" owner:nil options:nil] lastObject];
    }
    ClockModel * model=self.dataArr[indexPath.row];
    cell.zeView.repeatStr=model.repeat;
    cell.beginLabel.text=model.begin;
    if ([model.about isKindOfClass:[NSNull class]]) {
        cell.textView.text=@"";
    }
    else{
    cell.textView.text=model.about;
    }
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScreenHeight * 0.3;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    EditClockViewController * VC=[[EditClockViewController alloc]init];
    VC.model=self.dataArr[indexPath.row];
    [self.navigationController pushViewController:VC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadData{
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    
    NSString *GetDeviceNoDisturbURl1=[NSString stringWithFormat:@"%@token=%@&imei=%@",listClockURL,[userDefaults objectForKey:@"userTokentoken"],[userDefaults objectForKey:@"lastImei"]];
    LKLNetToll *net=[LKLNetToll shareInstance];
    NSLog(@"闹钟链接%@",GetDeviceNoDisturbURl1);
    [net GET:GetDeviceNoDisturbURl1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"获取闹钟%@",responseObject);
        if ([responseObject[@"errcode"] integerValue]==0) {
            [self viewControllerHideHud];
            self.dataArr=[NSMutableArray array];
            

            for (NSDictionary * dict in responseObject[@"data"]) {
                ClockModel * model=[ClockModel initWithDict: dict];
  
                [self.dataArr addObject:model];
                
     
            }
            [self.tableView reloadData];
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     [self loadData];
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了删除");
        ClockModel * model=self.dataArr[indexPath.row];
        
        LKLNetToll * net=[LKLNetToll shareInstance];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        NSString * SetDevicePBURl1=[NSString stringWithFormat:@"%@&token=%@&imei=%@&index=%@",delclockURL,[userDefaults objectForKey:@"userTokentoken"],[userDefaults objectForKey:@"lastImei"],model.index];
        [SVProgressHUD showWithStatus:@"删除中" maskType:SVProgressHUDMaskTypeClear];
        
        [net  GET:SetDevicePBURl1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"删除响应%@",responseObject);
            if ([responseObject[@"errcode"] integerValue]==0) {
                [self viewControllerHideHud];
                
            }
            else{
            [self viewControllerHideHud];
                [self fail];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
        [self.dataArr removeObjectAtIndex:indexPath.row];
        
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    }];
    
    return @[deleteRowAction];
    
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
