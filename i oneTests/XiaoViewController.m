//
//  XiaoViewController.m
//  ione
//
//  Created by lkl on 2017/4/10.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "XiaoViewController.h"
#import "XiaoxiTableViewCell.h"
#import "NewsViewController.h"
#import "DataBase.h"
@interface XiaoViewController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation XiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-49) style:UITableViewStylePlain];
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.scrollEnabled=NO;
    
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view addSubview:self.tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XiaoxiTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"XiaoxiTableViewCell" owner:self options:nil] lastObject];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
       
        
    }
   
    if (indexPath.row==0) {
        cell.label1.text=@"提醒消息";
        cell.label2.text=@"收到手表的消息提醒，低电量提醒，围栏提醒。";
         cell.image.image=[UIImage imageNamed:@"提醒消息图标"];
        DataBase * dataBase=[DataBase shareManager];
        if (dataBase.newMessage==YES) {
              cell.redview.hidden=NO;
        }
        
      
    }
//    else{
//        cell.label1.text=@"公告";
//        cell.label2.text=@"系统发送的消息通知";
//         cell.image.image=[UIImage imageNamed:@"公告图标"];
//    }
    
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ScreenHeight * 0.2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        
        XiaoxiTableViewCell * cell=[tableView cellForRowAtIndexPath:indexPath];
        cell.redview.hidden=YES;
        
         DataBase * dataBase=[DataBase shareManager];
        dataBase.newMessage=NO;
        
        NewsViewController * newsVC=[[NewsViewController alloc]init];
        newsVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:newsVC animated:YES];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:YES];

    
    
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    DataBase * dataBase=[DataBase shareManager];
    if ( dataBase.newMessage==NO) {
        XiaoxiTableViewCell * cell= self.tableView.visibleCells[0];
        cell.redview.hidden=YES;
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
