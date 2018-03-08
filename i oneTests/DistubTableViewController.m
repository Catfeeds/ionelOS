//
//  DistubTableViewController.m
//  ione
//
//  Created by lkl on 2017/3/29.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "DistubTableViewController.h"
#import "LklDistubTableViewCell.h"
#import "LKLNetToll.h"
#import "MBProgressHUD+Add.h"
#import "UIViewController+hide.h"
#import "NoDisturbingModel.h"
#import "LklView.h"
#import "LklDisturbViewController.h"
#import "MyDisturbViewController.h"
@interface DistubTableViewController ()<ZESegmentedsViewDelegate>
@property(nonatomic,strong)NSMutableArray * beginArr;
@property(nonatomic,strong)NSMutableArray * endArr;
@property(nonatomic,strong)NSMutableArray * indexArr;
@property(nonatomic,strong)NSMutableArray * timeArr;



@property(nonatomic,copy)NSString * date;
@property(nonatomic,copy)NSString * endDate;
@property(nonatomic,strong)LklView * lklView;
@end

@implementation DistubTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"免打扰";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    
    UIBarButtonItem * right=[[UIBarButtonItem alloc]initWithTitle:@"➕" style:UIBarButtonItemStylePlain target:self action:@selector(tapped)];
    
    self.navigationItem.rightBarButtonItem = right;
 
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
   
    
}
-(void)back:(UIBarButtonItem *)bar{
    
    
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)tapped{
    LklDisturbViewController * vc=[[LklDisturbViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _indexArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LklDistubTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"LklDistubTableViewCell" owner:nil options:nil] lastObject];
    }
    
    
    
    cell.beginLabel.text=self.beginArr[indexPath.row];
    cell.endlabel.text=self.endArr[indexPath.row];
    cell.zeView.repeatStr=self.timeArr[indexPath.row];

    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScreenHeight * 0.2;
}
//  点击单元格的时候取消选中单元格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyDisturbViewController * vc=[[MyDisturbViewController alloc]init];
    vc.begin=self.beginArr[indexPath.row];
    vc.end=self.endArr[indexPath.row];
     vc.repeat=self.timeArr[indexPath.row];
    vc.index=[self.indexArr[indexPath.row] integerValue];
    [self.navigationController pushViewController:vc animated:YES];
    
  
}
-(void)requestData{
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    
    NSString *GetDeviceNoDisturbURl1=[NSString stringWithFormat:@"%@token=%@&imei=%@",GetDeviceNoDisturbURl,[userDefaults objectForKey:@"userTokentoken"],[userDefaults objectForKey:@"lastImei"]];
    LKLNetToll *net=[LKLNetToll shareInstance];
    NSLog(@"获取的链接%@",GetDeviceNoDisturbURl1);
    [net GET:GetDeviceNoDisturbURl1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"获取免打扰%@",responseObject);
        if ([responseObject[@"errcode"] integerValue]==0) {
            [self viewControllerHideHud];
            
            for (NSDictionary * dict in responseObject[@"data"]) {
                NoDisturbingModel * model=[NoDisturbingModel noDisturbingModelWithDict: dict];
                NSString * begin=model.begin;
                NSString * end=model.end;
                NSString * repeat=model.repeat;
                NSString * index=model.index;
                
                [self.beginArr addObject:begin];
                [self.endArr addObject:end];
                [self.indexArr addObject:index];
                [self.timeArr addObject:repeat];
                
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


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了删除");
        
        LKLNetToll * net=[LKLNetToll shareInstance];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        NSString * SetDevicePBURl1=[NSString stringWithFormat:@"%@&token=%@&imei=%@&indexe=%@&begins=&ends=&repeats=",deleteDeviceURL,[userDefaults objectForKey:@"userTokentoken"],[userDefaults objectForKey:@"lastImei"],self.indexArr[indexPath.row]];
        [SVProgressHUD showWithStatus:@"删除中" maskType:SVProgressHUDMaskTypeClear];
        
        [net  GET:SetDevicePBURl1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"删除响应%@",responseObject);
            if ([responseObject[@"errcode"] integerValue]==0) {
                [self viewControllerHideHud];
                
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
        [_indexArr removeObjectAtIndex:indexPath.row];
        
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    }];
  
    return @[deleteRowAction];
    
}


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    
   
    
            _beginArr=[NSMutableArray array];

  
 

            _endArr=[NSMutableArray array];

 

        
    
            _indexArr=[NSMutableArray array];
    
    
 
        
            _timeArr=[NSMutableArray array];
        


    
     [self requestData];
}

@end
