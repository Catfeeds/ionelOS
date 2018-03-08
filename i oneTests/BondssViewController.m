//
//  BondssViewController.m
//  ione
//
//  Created by lkl on 2017/4/24.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "BondssViewController.h"
#import "LoginViewController.h"

#import "MJRefresh.h"
#import "BondsTableViewCell.h"

#import "GetBondsModel.h"
#import "MBProgressHUD+Add.h"
#import "UIViewController+hide.h"
#import "LKLNetToll.h"
@interface BondssViewController ()<UITableViewDataSource,UITableViewDelegate,LoginDelegate>
@property(nonatomic,strong)NSMutableArray * arr1;//设备变好
@property(nonatomic,strong)NSMutableArray * arr2;//mingzi
@property(nonatomic,strong)NSMutableArray * arr3;//phone
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * arrData;
@end

@implementation BondssViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title=@"设备列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Do any additional setup after loading the view
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view addSubview:_tableView];
    
    
  
    
    
    
    [self requestData];

}
-(void)requestData{
    _arrData=[NSMutableArray array];
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    LKLNetToll * net=[LKLNetToll shareInstance];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    NSString * getBondsURL1=[NSString stringWithFormat:@"%@token=%@",getBondsURL,[userDefaults objectForKey:@"userTokentoken"]];
    
    [net GET:getBondsURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
            [self viewControllerHideHud];
            _arr1=[NSMutableArray array];
            _arr2=[NSMutableArray array];
            _arr3=[NSMutableArray array];
            
            _arrData= responseObject[@"data"];
            
            if(_arrData !=0) {
                
                for (NSDictionary * dict in _arrData) {
                    
                    GetBondsModel * getBondsModel=[GetBondsModel getBondsModelWithDict:dict];
                    NSString * str1= getBondsModel.imei;
                    NSString * str2=getBondsModel.name;
                    NSString * str3=getBondsModel.phone;
                    [_arr1 addObject:str1];
                    [_arr2 addObject:str2];
                    [_arr3 addObject:str3];
                }
                
                [self.tableView reloadData];
            }
            if (_arrData.count==0) {
                [self hideMbprogressBond];
                
            }
        }
        
        
    }
     
     failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         [self viewControllerHideHud];
         
         
         [self hideMbprogressNet];
     }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr1.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * id=@"cell";
    BondsTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:id];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BondsTableViewCell"  owner:nil options:nil] firstObject];
        
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    
    cell.imei.text=self.arr1[indexPath.row];
    NSString * str=self.arr2[indexPath.row];
    if ([str isKindOfClass:[NSNull class]]) {
        cell.name.text=@"null";
    }
    else{
        cell.name.text=str;
    }
    
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ScreenHeight * 0.1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)fanbutton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
