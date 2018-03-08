//
//  DeviceInfoViewController.m
//  ione
//
//  Created by lkl on 2017/3/28.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "DeviceInfoViewController.h"
#import "InfoTableViewCell.h"

@interface DeviceInfoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray * titleArr;
@property(nonatomic,strong)NSMutableArray *infoArr;
@end

@implementation DeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"手表信息";
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.infoArr=[NSMutableArray array];
    
    self.titleArr=@[@"昵称",@"生日",@"身高",@"体重"];
    
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *CellIdentifier = @"cell" ;
    InfoTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if  (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InfoTableViewCell"  owner:nil options:nil] firstObject];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
    }
   
    if (indexPath.row==0) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.titleLabel.text=self.titleArr[indexPath.row];
    
    return cell;
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
