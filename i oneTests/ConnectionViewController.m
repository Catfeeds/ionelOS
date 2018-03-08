//
//  ConnectionViewController.m
//  ione
//
//  Created by lkl on 2016/12/9.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import "ConnectionViewController.h"
#import "ChatViewController.h"
#import "GetBondsModel.h"
#import "MBProgressHUD+Add.h"
#import "LKLNetToll.h"
#import "UIViewController+hide.h"
@interface ConnectionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,copy)NSString * tokenURL;
@property(nonatomic,strong)NSMutableArray * arr1;
@property(nonatomic,strong)NSMutableArray * arr2;
@property(nonatomic,strong)NSMutableArray * arr3;
@end

@implementation ConnectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"设备列表 ";
    self.automaticallyAdjustsScrollViewInsets=NO;
    

    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }

    [self.view addSubview:self.tableView];


    [self reloadData];
}

-(void)reloadData{
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    LKLNetToll *net=[LKLNetToll shareInstance];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    NSString * getBondsURL1=[NSString stringWithFormat:@"%@token=%@",getBondsURL,[userDefaults objectForKey:@"userTokentoken"]];
    NSLog(@"设备%@",getBondsURL1);
    [net GET:getBondsURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"响应%@",responseObject);
        if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
            [self viewControllerHideHud];
            
            _arr1=[NSMutableArray array];
            _arr2=[NSMutableArray array];
            self.arr3=[NSMutableArray array];
            NSArray * arr2=[[NSArray alloc]init];
            arr2= responseObject[@"data"];
            for (NSDictionary * dict in arr2) {
                GetBondsModel * getBondsModel=[GetBondsModel getBondsModelWithDict:dict];
                NSString * str1=getBondsModel.imei;
                NSString * str2=getBondsModel.phone;
                NSString * str3=getBondsModel.name;
                [_arr1 addObject:str1];
                [_arr2 addObject:str2];
                [self.arr3 addObject:str3];
            }
            NSLog(@"1%@",_arr1);
            NSLog(@"2%@",_arr2);
            
            [self.tableView reloadData];
            
        }
        
        if (_arr1.count==0) {
            [SVProgressHUD showSuccessWithStatus:@"请绑定设备"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr1.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor=[UIColor colorWithRed:221.0/255.0 green:242.0/255.0 blue:162.0/255.0 alpha:1];
    }
    cell.textLabel.text=self.arr3[indexPath.row];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatViewController * chatVC=[[ChatViewController alloc]init];
    chatVC.imei=self.arr1[indexPath.row];
    [self.navigationController pushViewController:chatVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
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
