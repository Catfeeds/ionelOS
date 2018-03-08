//
//  WeilanViewController.m
//  ione
//
//  Created by lkl on 2017/3/30.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "WeilanViewController.h"
#import "MBProgressHUD+Add.h"
#import "SVProgressHUD.h"
#import "UIViewController+hide.h"
#import "XiaoxiTableViewCell.h"
#import "WeiLanSettingViewController.h"
#import "LKLNetToll.h"
#import "LineTableModel.h"
#import "SelectWeilanViewController.h"
#import "LKLNetToll.h"
#import "UIViewController+hide.h"
@interface WeilanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray * nameArr;//围栏名称
@property(nonatomic,strong)NSMutableArray * centerLatArr;//中心点经纬度
@property(nonatomic,strong)NSMutableArray * centerLngArr;
@property(nonatomic,strong)NSMutableArray * radiusArr;//围栏半径
@property(nonatomic,strong)NSMutableArray * idArr;
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,strong)CLGeocoder * clGecoder;
@property(nonatomic,copy)NSString * placeStr;//翻遍吗地址
@end

@implementation WeilanViewController
-(NSMutableArray *)nameArr{

    if (_nameArr==nil) {
        _nameArr=[NSMutableArray array];
    }
    return _nameArr;
}
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
-(NSMutableArray *)centerLatArr{

    if (_centerLatArr==nil) {
        _centerLatArr=[NSMutableArray array];
    }
    return _centerLatArr;
}
-(NSMutableArray *)centerLngArr{
    
    if (_centerLngArr==nil) {
        _centerLngArr=[NSMutableArray array];
    }
    return _centerLngArr;
}
-(NSMutableArray *)radiusArr{
    
    if (_radiusArr==nil) {
        _radiusArr=[NSMutableArray array];
    }
    return _radiusArr;
}
-(NSMutableArray *)idArr{
    
    if (_idArr==nil) {
        _idArr=[NSMutableArray array];
    }
    return _idArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=@"安全区域";
    
     
    
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-49) style:UITableViewStylePlain];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    if ([self.tableview
         respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableview setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableview setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:self.tableview];
    
    
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, ScreenHeight-49, ScreenWidth, 49);
    [button addTarget:self action:@selector(buttonTapped1:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"添加安全区域" forState:UIControlStateNormal];
    
    button.backgroundColor=[UIColor redColor];
    [self.view addSubview:button];
    // Do any additional setup after loading the view.
  
    
}
-(void)getFine{
    self.dataArr=[NSMutableArray array];
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    
    LKLNetToll * toll=[LKLNetToll shareInstance];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    NSString * getFineURL1=[NSString stringWithFormat:@"%@&token=%@",getFineURL,[userDefaults objectForKey:@"userTokentoken"]];
    NSLog(@"添加%@",getFineURL1);
    [toll GET:getFineURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        NSLog(@"电子围栏%@",responseObject);
        if ([responseObject[@"errcode"] integerValue]==0) {
            [self viewControllerHideHud];
   
            
            
        for (NSDictionary * dict in responseObject[@"data"]) {
            LineTableModel * lineTableModel=[LineTableModel lineTableModelWithDict:dict];
            
            [self.dataArr addObject:lineTableModel];
     
           
        }
            

        [self.tableview reloadData];
            
        }
        
        
        else{
         [self viewControllerHideHud];
            [self hideMbprogress];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self viewControllerHideHud];
           [self hideMbprogress];
    }];

}
//反地理编码
//-(void)revertWithlocationLat :(CLLocationDegrees)a withlng :(CLLocationDegrees)b{
//CLLocation * location=[[CLLocation alloc]initWithLatitude:a longitude:b];
//    NSLog(@"aaaaa%f",a);
//    self.clGecoder=[[CLGeocoder alloc]init];
//    
//[self.clGecoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//    
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"111%@",placemarks.lastObject.name);
//        self.placeStr=placemarks.lastObject.name;
//        
//    });
//}];
//
//}
-(void)buttonTapped1:(UIButton *)button{
    WeiLanSettingViewController * VC=[[WeiLanSettingViewController alloc]initWithNibName:@"WeiLanSettingViewController" bundle:nil];
    VC.imeiarr=self.imeiarr;
    VC.namearr=self.namearr;
    VC.lat=self.lat;
    VC.lng=self.lng;
    VC.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:VC animated:YES];
    

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XiaoxiTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"XiaoxiTableViewCell" owner:self options:nil] lastObject];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
         cell.image.image=[UIImage imageNamed:@"学校"];
    }

    LineTableModel * model=self.dataArr[indexPath.row];
 
    cell.label1.text=model.name;
    
    cell.label2.text=model.address;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SelectWeilanViewController *VC=[[SelectWeilanViewController alloc]initWithNibName:@"selcet" bundle:nil];
    

    VC.model=self.dataArr[indexPath.row];
    
    VC.hidesBottomBarWhenPushed=YES;
    
    VC.imeiarr=self.imeiarr;
    VC.namearr=self.namearr;
    
    [self.navigationController pushViewController:VC animated:YES];
    
  
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  ScreenHeight * 0.15;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     [self getFine];
    
    
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了删除");
       
        
        LineTableModel * model=self.dataArr[indexPath.row];
        

        LKLNetToll * net=[LKLNetToll shareInstance];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        [SVProgressHUD showWithStatus:@"删除中..." maskType:SVProgressHUDMaskTypeClear];
        
        NSString * delFineURL1=[NSString stringWithFormat:@"%@&token=%@&id=%ld",delFineURL,[userDefaults objectForKey:@"userTokentoken"], model.ID ];
        NSLog(@"111111%@",delFineURL1);
        [net GET:delFineURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"——————————%@",responseObject);
            
            if ([responseObject[@"errcode"] integerValue]==0) {
                [self viewControllerHideHud];
                 [self.tableview reloadData];
            }
           
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            
        }];
        
         [self.dataArr removeObjectAtIndex:indexPath.row];
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
