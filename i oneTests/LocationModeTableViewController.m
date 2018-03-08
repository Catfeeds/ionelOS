//
//  LocationModeTableViewController.m
//  ione
//
//  Created by lkl on 2017/3/29.
//  Copyright © 2017年 lkl. All rights reserved.
//
#import "LKLNetToll.h"
#import "LocationModeTableViewController.h"
#import "LocationModeTableViewCell.h"
#import "UIViewController+hide.h"
#import "MBProgressHUD+Add.h"
@interface LocationModeTableViewController ()
@property(nonatomic,strong)NSArray * firstArr;
@property(nonatomic,strong)NSArray * secondArr;
@property(nonatomic,assign)NSInteger  newIndex;
@end

@implementation LocationModeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"定位模式";
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.firstArr=@[@"安全模式",@"省电模式"];
    self.secondArr=@[@"每1分钟上传一次位置",@"每5分钟上传一次位置"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationModeTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"LocationModeTableViewCell" owner:nil options:nil] lastObject];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
    }
    cell.firstlabel.text=self.firstArr[indexPath.row];
    cell.secondlabel.text=self.secondArr[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return ScreenHeight * 0.15;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   //单选模式
        
     LocationModeTableViewCell * cell1=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_newIndex inSection:0]];
    cell1.imageview.image=nil;
    
    
    LocationModeTableViewCell * cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.imageview.image=[UIImage imageNamed:@"选中"];
    
   _newIndex=indexPath.row;
    
   
    
  static NSInteger time;
    if (indexPath.row==0) {
        time=60;
    }
    else if (indexPath.row==1 ){
    
        time=600;
    }

    
  
    
  
    [SVProgressHUD showWithStatus:@"设置中" maskType:SVProgressHUDMaskTypeClear];
    LKLNetToll * net=[LKLNetToll shareInstance];

    NSString * timeURL1=[NSString stringWithFormat:@"%@token=%@&imei=%@&interval=%ld",timeURL,[userDefaults objectForKey:@"userTokentoken"],[userDefaults objectForKey:@"lastImei"],time];
        NSLog(@"时间%@",timeURL1);
        [net GET:timeURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
              NSLog(@"时间%@",responseObject);
            if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
    
                [self viewControllerHideHud];
                
            }else{
               [self viewControllerHideHud];
                
               [self hideMbprogressMode];
            }
          
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self viewControllerHideHud];
            
            [self hideMbprogressNet];
        }];

}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
