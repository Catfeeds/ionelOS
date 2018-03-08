//
//  DeviceChooseViewController.m
//  ione
//
//  Created by lkl on 2017/4/17.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "DeviceChooseViewController.h"
#import "SelectDeviceTableViewCell.h"
@interface DeviceChooseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSArray * nameArr;
@property(nonatomic,strong)NSMutableArray * imeiArr;
@end

@implementation DeviceChooseViewController
-(NSArray *)namearr{
    
    if (_namearr==nil) {
        _namearr=[NSArray array];
    }
    return _namearr;
}
-(NSArray *)imeiarr{
    
    if (_imeiarr==nil) {
        _imeiarr=[NSArray array];
    }
    return _imeiarr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"设备选择";
    
    self.imeiArr=[NSMutableArray array];
    self.selectedArr=[NSMutableArray array];
    
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight -64) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.namearr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectDeviceTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"SelectDeviceTableViewCell" owner:self options:nil] lastObject];
        cell.image.image=[UIImage imageNamed:@"未选中"];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }

    }
    
    cell.namelabel.text=self.namearr[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectDeviceTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.tag=!cell.tag;
    if (cell.tag) {
       cell.image.image=[UIImage imageNamed:@"选中"];
        [self.selectedArr addObject:cell.namelabel.text];
        NSInteger a=[self.namearr indexOfObject:cell.namelabel.text];
     [self.imeiArr addObject:self.imeiarr[a]]      ;
    }
    else{
     cell.image.image=[UIImage imageNamed:@"未选中"];
        [self.selectedArr removeObject:cell.namelabel.text];
        NSInteger a=[self.namearr indexOfObject:cell.namelabel.text];
        [self.imeiArr removeObject:self.imeiarr[a]]      ;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScreenHeight * 0.1;
}
-(void)viewWillDisappear:(BOOL)animated{
    if ([self.myDelegete respondsToSelector:@selector(passSelectedArr: WithIndexArr:)]) {
          [self.myDelegete passSelectedArr:self.selectedArr WithIndexArr:self.imeiArr];
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
