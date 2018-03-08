//
//  LklLocationViewController.m
//  ione
//
//  Created by lkl on 2017/3/28.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "LklLocationViewController.h"

#import "UIViewController+hide.h"

#import "ClassCollectionViewCell.h"
#import "ManagerViewController.h"
#import "MBProgressHUD+Add.h"
#import "GetBondsModel.h"
#import "AddDeviceViewController.h"
#import "ListTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationModel.h"
#import "TakePhoneViewController.h"
#import "MapAnnotation.h"
#import "FangzousanViewController.h"

#import "LuyinViewController.h"
#import "LishiViewController.h"
#import "WeilanViewController.h"
#import "MBProgressHUD+Add.h"

#import "ChatViewController.h"
#import "AppDelegate.h"
#import "LKLNetToll.h"
#import "DataBase.h"
@interface LklLocationViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
@property(nonatomic,strong)UICollectionViewFlowLayout * flowLayOut;
@property(nonatomic,strong)NSArray * titileArr;
@property(nonatomic,copy)NSString * tokenURL;
@property(nonatomic,strong)NSMutableArray * imeiArr;
@property(nonatomic,strong)NSMutableArray * nameArr;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)CLLocationManager * locationManager;
@property(nonatomic,assign)CLLocationDegrees  lat;
@property(nonatomic,assign)CLLocationDegrees lng;
@property(nonatomic,strong)NSDictionary * dict;//定位字典
@property(nonatomic,assign)NSInteger indexCell;
@property(nonatomic,copy)NSString * lastImei;//最后点击单元格
@property(nonatomic,strong)NSMutableArray * arr1;//设备好总的数组
@property(nonatomic,strong)NSMutableArray * phoneArr;
@property(nonatomic,strong)UIButton * addTableViewButton;

@property(nonatomic,strong)AppDelegate * appdelegate;
@property(nonatomic,strong)MKPointAnnotation * annotation;

@end

@implementation LklLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=@"定位";
    self.titileArr=[NSArray array];
    self.dict=[NSDictionary dictionary];
    self.titileArr=@[@"打电话",@"录音",@"微聊",@"防走散",@"管理"];
    
   [self loadUI];

   }


-(void)requestDataWithString:(NSString *)str{
   [SVProgressHUD showWithStatus:@"定位中" maskType:SVProgressHUDMaskTypeClear];
    

    
    str=[userDefaults objectForKey:@"lastImei"];


    //创建请求工具对象
    LKLNetToll *newWorkTool = [LKLNetToll shareInstance];
    
    //设置网络请求标识
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    

    self.tokenURL=[userDefaults objectForKey:@"userTokentoken"];
    
    NSString * locationURL1=[NSString stringWithFormat:@"%@token=%@&imei=%@&coordtype=gcj02",locationURL,self.tokenURL,str];
    NSLog(@"定位%@",locationURL1);
    
    [newWorkTool GET:locationURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"定位结果%@",responseObject);
        
        if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {

            //        CLLocationCoordinate2D www=CLLocationCoordinate2DMake(22.33, 114.07);
            //        MKCoordinateSpan span=MKCoordinateSpanMake(0.5,0.5);
            //        MKCoordinateRegion region=MKCoordinateRegionMake(www, span);
            //        _mapView.region =region;
            
          //  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [self viewControllerHideHud];
            
           
            self.dict=responseObject[@"data"];
            
            
            
            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                LocationModel * locationModel=[LocationModel locationModelWithDict:self.dict];
              
                _lat=locationModel.lat;
                
                _lng=locationModel.lng;
                
                
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.lat,self.lng);
                NSLog(@"wode%f",self.lat);
//                MapAnnotation * annotation=[[MapAnnotation alloc]init];
//                annotation.icon=@"我的1";
                
                //if (_annotation) {
                    
                    //[self.mapView removeAnnotation:_annotation];//为了防止再次进入该页面时，由多个定位大头针
                //}
                
                if( !_annotation ){
                    _annotation=[[MKPointAnnotation alloc]init];
                    [self.mapView addAnnotation:_annotation];
                }
                
                _annotation.coordinate = coordinate;
                
               
               
    
                 if (self.arr1.count==0){ //为了防止崩溃
                
                    return ;
                }
                
                
          NSInteger     index=[self.arr1 indexOfObject:str];
                
                _annotation.title = self.nameArr[index];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                
                NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self.dict[@"time"] doubleValue]];
                NSLog(@"1296035591 = %@",confromTimesp);
                NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
                NSLog(@"confromTimespStr =  %@",confromTimespStr);
                
                
                NSString * fhstr=[NSString stringWithFormat:@"时间:%@",confromTimespStr];
                
                _annotation.subtitle=fhstr;
                
                
                //[self.mapView addAnnotation:_annotation];
                
                
                self.addressLabel.text=[NSString stringWithFormat:@"%@",self.dict[@"address"]];
                self.timeLabel.text=confromTimespStr;
                
//                    NSDictionary *dic = @{
//                                          NSFontAttributeName : [UIFont systemFontOfSize:15]
//                                          };
//                
//                    CGRect rect = [self.addressLabel.text boundingRectWithSize:CGSizeMake(ScreenWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
//                
//                    CGRect frame=self.addressLabel.frame;
//                
//                    frame.size.height=rect.size.height;
//                    frame.origin.x=0;
//                    frame.origin.y=64+ScreenHeight * 0.7;
//                    frame.size.width=ScreenWidth;
//                    self.addressLabel.frame=frame ;
//                
//                    CGRect rect1=CGRectMake(0, 0, ScreenWidth, (ScreenHeight-64-49-ScreenHeight*0.7) - frame.size.height);
//                
//                    CGRect frame1=self.timeLabel.frame;
//                    
//                    frame1.size.height=rect1.size.height ;
//                    
//                    frame1.origin.y=ScreenHeight * 0.7 + frame.size.height + 64;
//                    frame1.size.width=ScreenWidth;
//                    frame1.origin.x=0;
//                    
//                    self.timeLabel.frame=frame1;
                
             
                
                
                if ([self.dict[@"online"] integerValue] ==0 ) {
                    
                self.navigationItem.title= self.navigationItem.title=[NSString stringWithFormat:@"%@(离线)",self.nameArr[index]];
                    [self.navigationController.navigationBar setTitleTextAttributes:
                     
           @{NSFontAttributeName:[UIFont systemFontOfSize:19],
    
           NSForegroundColorAttributeName:[UIColor blackColor]}];
                    
                }
                if ([self.dict[@"online"] integerValue] ==1) {
                    self.navigationItem.title=self.nameArr[index];
                    [self.navigationController.navigationBar setTitleTextAttributes:
                     
                     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
                       
                       NSForegroundColorAttributeName:[UIColor blackColor]}];
                }
                
                
                
                if ([self.dict[@"power"] integerValue]<=20 && [self.dict[@"power"] integerValue]>=0) {
                    self.elctimageView.image=[UIImage imageNamed:@"20%"];
                }
                else if ([self.dict[@"power"] integerValue]<=40 && [self.dict[@"power"] integerValue]>=20){
                self.elctimageView.image=[UIImage imageNamed:@"40%"];
                
                }
                else if ([self.dict[@"power"] integerValue]<=60 && [self.dict[@"power"] integerValue]>=40){
                    self.elctimageView.image=[UIImage imageNamed:@"60%"];
                    
                }
                else if ([self.dict[@"power"] integerValue]<=80 && [self.dict[@"power"] integerValue]>=60){
                    self.elctimageView.image=[UIImage imageNamed:@"80%"];
                    
                }
                else{
                
                 self.elctimageView.image=[UIImage imageNamed:@"100%"];
                }
                
                
                [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000)];
            });
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

-(void)requestDataWithString1:(NSString *)str{
     [SVProgressHUD showWithStatus:@"定位中" maskType:SVProgressHUDMaskTypeClear];
    //创建请求工具对象
    LKLNetToll *newWorkTool = [LKLNetToll shareInstance];
    
    //设置网络请求标识
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    self.tokenURL=[userDefaults objectForKey:@"userTokentoken"];
    NSString * locationURL1=[NSString stringWithFormat:@"%@token=%@&imei=%@&coordtype=gcj02",locationURL,self.tokenURL,str];
    NSLog(@"定位%@",locationURL1);
    [newWorkTool GET:locationURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"定位结果%@",responseObject);

        if ([responseObject[@"errmsg"] isEqualToString:@"success"]){
            [self viewControllerHideHud];
            self.dict=responseObject[@"data"];
            
            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                LocationModel * locationModel=[LocationModel locationModelWithDict:self.dict];
                _lat=locationModel.lat;
                
                _lng=locationModel.lng;
                
                
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.lat,self.lng);
                // CLLocationCoordinate2D zz=[TransformToMarsTool transform:coordinate];
                
                //if (_annotation) {
                    
                //    [self.mapView removeAnnotation:_annotation];//为了防止再次进入该页面时，由多个定位大头针
                //    _annotation = nil;
               // }

                
                if( !_annotation ){
                    _annotation=[[MKPointAnnotation alloc]init];
                    [self.mapView addAnnotation:_annotation];
                }
                _annotation.coordinate = coordinate;
                
             
                
                if (self.arr1.count==0){ //为了防止崩溃
                    
                    return ;
                }
                
           NSInteger     index=[self.arr1 indexOfObject:str];
            
                _annotation.title=self.nameArr[index];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                
                NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self.dict[@"time"] doubleValue]];
                NSLog(@"1296035591 = %@",confromTimesp);
                NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
                NSLog(@"confromTimespStr =  %@",confromTimespStr);
                
                
                NSString * fhstr=[NSString stringWithFormat:@"时间:%@",confromTimespStr];
                
                _annotation.subtitle=fhstr;

                //[self.mapView addAnnotation:annotation];
                if ([self.dict[@"online"] integerValue] ==0 ) {
//                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
//                    titleLabel.backgroundColor = [UIColor colorWithRed:152.0/ 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1];
//                    titleLabel.font = [UIFont boldSystemFontOfSize:20];
//                    
//                    titleLabel.textAlignment = NSTextAlignmentCenter;
//                    titleLabel.text = @"离线";
//                    titleLabel.tag=1000;
//                    self.navigationItem.titleView = titleLabel;
                    
                    
                    self.navigationItem.title=[NSString stringWithFormat:@"%@(离线)",self.nameArr[index]];
                    [self.navigationController.navigationBar setTitleTextAttributes:
                     
                     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
                       
                       NSForegroundColorAttributeName:[UIColor blackColor]}];
                    
                    
                }
                if ([self.dict[@"online"] integerValue] ==1) {
//                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
//                    titleLabel.backgroundColor = [UIColor colorWithRed:152.0/ 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1];
//                    titleLabel.font = [UIFont boldSystemFontOfSize:20];
//                    
//                    titleLabel.textAlignment = NSTextAlignmentCenter;
//                    titleLabel.text = @"在线";
//                    titleLabel.tag=1001;
//                    self.navigationItem.titleView = titleLabel;
                    
                    self.navigationItem.title=self.nameArr[index];
                    [self.navigationController.navigationBar setTitleTextAttributes:
                     
                     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
                       
                       NSForegroundColorAttributeName:[UIColor blackColor]}];
                }

                
                self.addressLabel.text=[NSString stringWithFormat:@"%@",self.dict[@"address"]];
                self.timeLabel.text=confromTimespStr;
                if ([self.dict[@"power"] integerValue]<=20 && [self.dict[@"power"] integerValue]>=0) {
                    self.elctimageView.image=[UIImage imageNamed:@"20%"];
                }
                else if ([self.dict[@"power"] integerValue]<=40 && [self.dict[@"power"] integerValue]>=20){
                    self.elctimageView.image=[UIImage imageNamed:@"40%"];
                    
                }
                else if ([self.dict[@"power"] integerValue]<=60 && [self.dict[@"power"] integerValue]>=40){
                    self.elctimageView.image=[UIImage imageNamed:@"60%"];
                    
                }
                else if ([self.dict[@"power"] integerValue]<=80 && [self.dict[@"power"] integerValue]>=60){
                    self.elctimageView.image=[UIImage imageNamed:@"80%"];
                    
                }
                else{
                    
                    self.elctimageView.image=[UIImage imageNamed:@"100%"];
                }

                [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000)];
            });
            
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


//自定义标注针

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    
    static NSString *ID=@"annoView";
    MKAnnotationView *annoView=[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView==nil) {
        annoView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:ID];
        //点击大头针出现信息（自定义view的大头针默认点击不弹出）
        annoView.canShowCallout=YES;
        
    }
    //再传递一次annotation模型（赋值）
    annoView.annotation=annotation;
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        annoView.image=nil;
    }
    else{
  
    annoView.image=[UIImage imageNamed:@"大头针.jpg"];
         NSLog(@"图片的大小%f", annoView.image.size.height);
        annoView.centerOffset=CGPointMake(0, -annoView.image.size.height/2);
    }
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
    label.textAlignment=NSTextAlignmentCenter;
    annoView.detailCalloutAccessoryView = label;
    
    return annoView;
}



- (void)getUserLocation
{

    if ( _locationManager==nil)
        _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //  _locationManager.distanceFilter = 50.0f;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [_locationManager requestWhenInUseAuthorization];
    }
    if(![CLLocationManager locationServicesEnabled]){
        NSLog(@"请开启定位:设置 > 隐私 > 位置 > 定位服务");
    }
    if([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        //[_locationManager requestAlwaysAuthorization]; // 永久授权
        [_locationManager requestWhenInUseAuthorization]; //使用中授权
    }else {
        [self showAlerViewWithTitle:@"提示" Message:@"定位服务当前可能尚未打开，请设置打开！"];
    }

    [_locationManager startUpdatingLocation];
}

-(void)loadUI{
    self.mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight * 0.6)];
    self.mapView.delegate=self;
    _mapView.mapType = MKMapTypeStandard;
    
    self.mapView.delegate=self;
    
    _mapView.zoomEnabled = YES;
    
    _mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow; // 追踪用户位置.
    
    _mapView.scrollEnabled = YES;
    
    [self.view addSubview:self.mapView];

    
    self.flowLayOut=[[UICollectionViewFlowLayout alloc]init];
    self.flowLayOut.minimumLineSpacing=0;
    self.flowLayOut.minimumInteritemSpacing=0;
    
    
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0,64 + ScreenHeight * 0.6, ScreenWidth,ScreenHeight * 0.1) collectionViewLayout:self.flowLayOut];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.backgroundColor=[UIColor colorWithRed:152.0/ 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1];
     [self.collectionView registerNib:[UINib nibWithNibName:@"ClassCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"classCell"];
    [self.view addSubview:self.collectionView];
    
   
   
    
 // self.timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 64 + ScreenHeight * 0.7 +(ScreenHeight-64-49-ScreenHeight*0.7)/2 , ScreenWidth,  (ScreenHeight-64-49-ScreenHeight*0.7)/2)];
    
   self.timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,ScreenHeight- 49 -(ScreenWidth *4/75), ScreenWidth, ScreenWidth *4/75)];
    
    self.timeLabel.font=[UIFont systemFontOfSize:15.0];
    self.timeLabel.text=@"";
    self.timeLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:self.timeLabel];
   

    
   self.addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,64 + ScreenHeight *0.7 , ScreenWidth, ScreenHeight-64-ScreenHeight*0.7-49-ScreenWidth *4/75)];
    self.addressLabel.font=[UIFont systemFontOfSize:15.0];
    self.addressLabel.text=@"";
    
    self.addressLabel.numberOfLines=0;
    
    self.addressLabel.textAlignment=NSTextAlignmentCenter;
    
    
    
    [self.view addSubview:self.addressLabel];
    self.historyButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.historyButton.frame=CGRectMake(ScreenWidth -45 , 10 ,35, 35);
    [self.historyButton setImage:[UIImage imageNamed:@"历史轨迹"] forState:UIControlStateNormal];
    [self.historyButton addTarget:self action:@selector(historyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:self.historyButton];
    
    self.elumButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.elumButton.frame=CGRectMake(ScreenWidth -45, 15 +30 +5, 35, 35);
    [self.elumButton setImage:[UIImage imageNamed:@"安全"] forState:UIControlStateNormal];
    [self.elumButton addTarget:self action:@selector(elumButtontapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:self.elumButton];
    
    self.elctimageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
    self.elctimageView.image=[UIImage imageNamed:@"电量"];
    [self.mapView addSubview:self.elctimageView];
}
-(void)historyButton:(UIButton *)button{
    
    if(self.arr1.count==0){
         [MBProgressHUD showSuccess:@"请绑定设备" toView:self.view];
      
    }
    else{
        if(![userDefaults objectForKey:@"imeiArr"] && self.arr1){
            
            [MBProgressHUD showSuccess:@"请选择设备" toView:self.view];
        }
        else{
    LishiViewController * VC=[[LishiViewController alloc]init];
        VC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:VC animated:YES];
        }
    }
}

-(void)elumButtontapped:(UIButton *)button{
    
    if(self.arr1.count==0){
         [MBProgressHUD showSuccess:@"请绑定设备" toView:self.view];
       
    }
    else{
        if(![userDefaults objectForKey:@"imeiArr"] && self.arr1){
            
            [MBProgressHUD showSuccess:@"请选择设备" toView:self.view];
        }else{
    WeilanViewController * VC=[[WeilanViewController alloc]init];
        VC.imeiarr=self.arr1;
        VC.namearr=self.nameArr;
        VC.lat=self.lat;
        VC.lng=self.lng;
        VC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:VC animated:YES];
    }
    }
}


#pragma  mark ---点击➕号
-(void)loginAction:(UIButton *)sender{
    NSLog(@"最开始的tag%ld",sender.tag);
   
    sender.tag =!sender.tag;
    
   NSLog(@"按钮的tag%ld",sender.tag);
    if (sender.tag !=0) {
        
        
        NSLog(@"所有手表的列表%@",self.arr1);
        
        
        if(self.arr1.count==0){
            AddDeviceViewController * adddevice=[[AddDeviceViewController alloc]initWithNibName:@"AddDeviceViewController" bundle:nil];
            adddevice.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:adddevice animated:YES];
 
            
        }
        else{
              [self loadtableViewWith:self.arr1];
        
        }
    }
    else if (sender.tag==0){
        [self.tableView removeFromSuperview];
        self.tableView=nil;
        
        [self.addTableViewButton removeFromSuperview];
        self.addTableViewButton=nil;
    }
    
    
    
}



#pragma  mark ---创建表视图和按钮
-(void)loadtableViewWith:(NSArray *)arr{
    if (self.tableView) {
        [self.tableView removeFromSuperview];
        self.tableView=nil;
    }
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth/2, 64, ScreenWidth/2, arr.count * 40 ) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    // [self.tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"listCell"];
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.scrollEnabled=NO;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view addSubview: self.tableView];
    
    self.addTableViewButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.addTableViewButton .frame=CGRectMake(ScreenWidth/2, arr.count * 40 +64, ScreenWidth/2, 40);
    self.addTableViewButton.backgroundColor=[UIColor colorWithRed:152.0/ 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1];
    [self.addTableViewButton setTitle:@"➕" forState:UIControlStateNormal];
    [self.addTableViewButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [self .view addSubview:self.addTableViewButton];
}
-(void)click:(UIButton *)button{
    [self.addTableViewButton removeFromSuperview];
    self.addTableViewButton=nil;
    [self.tableView removeFromSuperview];
    self.tableView=nil;
    
    AddDeviceViewController * addVC=[[AddDeviceViewController alloc]initWithNibName:@"AddDeviceViewController" bundle:nil];
     addVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:addVC animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return  self.arr1.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString * imeiStr=    [userDefaults objectForKey:@"lastImei"];
    
    if ([userDefaults objectForKey:@"indexCellCell"] && [self.arr1[indexPath.row] isEqualToString:imeiStr]  ) {
//        ListTableViewCell *    cellindex=[tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
              ListTableViewCell *    cellindex=[tableView dequeueReusableCellWithIdentifier:@"listCell"];
        if (cellindex==nil) {
              cellindex=[[[NSBundle mainBundle] loadNibNamed:@"ListTableViewCell" owner:self options:nil] lastObject];
            cellindex.backgroundColor=[UIColor lightGrayColor];
            cellindex.selectedImage.image=[UIImage imageNamed:@"设备1"];
            cellindex.label.textColor=[UIColor colorWithRed:152.0/ 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1];
            cellindex.selectionStyle=UITableViewCellSelectionStyleNone;
            cellindex.label.textAlignment=NSTextAlignmentCenter;
   
            if ([cellindex respondsToSelector:@selector(setLayoutMargins:)]) {
                [cellindex setLayoutMargins:UIEdgeInsetsZero];
            }
            if ([cellindex respondsToSelector:@selector(setSeparatorInset:)]){
                [cellindex setSeparatorInset:UIEdgeInsetsZero];
            }
            
            
            if ([self.nameArr[indexPath.row] isKindOfClass:[NSNull class]]) {
                cellindex.label.text=@"";
            }
            else{
                cellindex.label.text=self.nameArr[indexPath.row];
            }
        
        }
        
        return cellindex;
    }
    
    else{
        
        ListTableViewCell  *   cell=[tableView dequeueReusableCellWithIdentifier:@"listCell"];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"ListTableViewCell" owner:self options:nil] lastObject];
            cell.backgroundColor=[UIColor lightGrayColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.label.textAlignment=NSTextAlignmentCenter;
            
          
            cell.selectedImage.image=[UIImage imageNamed:@"设备0"];
            cell.label.textColor=[UIColor blackColor];
            
            
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
        }
        if ([self.nameArr[indexPath.row] isKindOfClass:[NSNull class]]) {
            cell.label.text=@"";
        }
        else{
            cell.label.text=self.nameArr[indexPath.row];
        }
        return cell;
    }
    }
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    return self.tableView.frame.size.height/self.arr1.count;

}

#pragma  mark ---点击屏幕

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
UIButton * button= (UIButton *)self.navigationItem.rightBarButtonItem;
    
   button.tag=0;
    
    NSLog(@"tag=%ld",button.tag);
    if (self.tableView) {
        [self.tableView removeFromSuperview];
        self.tableView=nil;
        [self.addTableViewButton removeFromSuperview];
        self.addTableViewButton=nil;
    }
   
    

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
        if ([userDefaults objectForKey:@"indexCellCell"]) {
            NSInteger index=[[userDefaults objectForKey:@"indexCellCell"] integerValue];
            ListTableViewCell * cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            cell.backgroundColor=[UIColor lightGrayColor];
            cell.label.textColor=[UIColor blackColor];
            cell.selectedImage.image=[UIImage imageNamed:@"设备0"];
        }
        
        ListTableViewCell * cell=[tableView cellForRowAtIndexPath:indexPath];
        
        
        self.indexCell=indexPath.row;
        
        
        NSNumber * number=[NSNumber numberWithInteger:self.indexCell];
        
        [userDefaults setObject:number forKey:@"indexCellCell"];
        
       cell.selectedImage.image=[UIImage imageNamed:@"设备1"];
      cell.label.textColor=[UIColor colorWithRed:152.0/ 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1];
    
      //  cell.backgroundColor=[UIColor colorWithRed:144.0/ 255.0 green:203.0 / 255.0 blue:19.0 / 255.0 alpha:1];
    
    
        self.lastImei=self.arr1[indexPath.row];
        
        self.imeiArr=[NSMutableArray array];
        
        [self.imeiArr addObject:self.lastImei];
        
        [userDefaults setObject:self.imeiArr forKey:@"imeiArr"];
        [userDefaults synchronize];
        
        [userDefaults setObject:self.lastImei forKey:@"lastImei"];
    
        [userDefaults synchronize];
        
        
        NSLog(@"imei%@",self.lastImei);
        [self requestDataWithString:(NSString *)self.lastImei];

    
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.titileArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ClassCollectionViewCell * cell2=[collectionView dequeueReusableCellWithReuseIdentifier:@"classCell" forIndexPath:indexPath];
    
    cell2.textLabel.text=self.titileArr[indexPath.item];
    if (indexPath.item==0) {
        cell2.textLabel.textColor=[UIColor colorWithRed:125.0/255.0 green:175/255.0 blue:126/255.0 alpha:1];
    }
    else if (indexPath.item==1){
     cell2.textLabel.textColor=[UIColor colorWithRed:105.0/255.0 green:138/255.0 blue:235/255.0 alpha:1];
    }else if (indexPath.item==2){
       
    cell2.textLabel.textColor=[UIColor colorWithRed:232.0/255.0 green:101/255.0 blue:157/255.0 alpha:1];
        
    }else if (indexPath.item==3){
     cell2.textLabel.textColor=[UIColor colorWithRed:75.0/255.0 green:156/255.0 blue:255/255.0 alpha:1];
    
    }else {
    
    cell2.textLabel.textColor=[UIColor colorWithRed:255.0/255.0 green:151/255.0 blue:68/255.0 alpha:1];
    }
    
        
    cell2.imageView.image=[UIImage imageNamed:self.titileArr[indexPath.item]];
    
    
    
    return cell2;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return CGSizeMake(ScreenWidth /5 ,ScreenHeight * 0.1);
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.addTableViewButton && self.tableView) {
        [self.addTableViewButton removeFromSuperview];
        [self.tableView removeFromSuperview];
        self.tableView=nil;
        self.addTableViewButton=nil;
    }
    
    if (self.arr1.count==0) {
         [MBProgressHUD showSuccess:@"请绑定设备" toView:self.view];
    }
    else if (self.arr1.count!=0){
    if(![userDefaults objectForKey:@"imeiArr"] && self.arr1){
      
        [MBProgressHUD showSuccess:@"请选择设备" toView:self.view];
    }
 
    
    
    else{
    if (indexPath.row==4) {
       
        
        ManagerViewController * mangegerVC=[[ManagerViewController alloc]initWithNibName:@"ManagerViewController" bundle:nil];
        
        mangegerVC.hidesBottomBarWhenPushed=YES;
        mangegerVC.nameArr=self.nameArr;
        mangegerVC.imeiArr=self.arr1;
        mangegerVC.phoneArr=self.phoneArr;
        [self.navigationController pushViewController:mangegerVC animated:YES];
    }
    else if (indexPath.row==0){
//        TakePhoneViewController * VC=[[TakePhoneViewController alloc]initWithNibName:@"TakePhoneViewController" bundle:nil];
//         VC.hidesBottomBarWhenPushed=YES;;
//        [self.navigationController pushViewController:VC animated:YES];
       
         NSInteger index=[[userDefaults objectForKey:@"indexCellCell"] integerValue];
        NSString *allString = [NSString stringWithFormat:@"tel:%@",self.phoneArr[index]];
        
        NSString * allString1=[allString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString1]];

        
        
        
    }
    else if (indexPath.row==2){
        ClassCollectionViewCell * cell=(ClassCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.redView.hidden=YES;
        //避免程序回到后台，又回出现小红点
        ChatDAtabase * chatdata=[ChatDAtabase shareManager];
        chatdata.newMessage=NO;
        
        ChatViewController * VC=[[ChatViewController alloc]init];
         VC.hidesBottomBarWhenPushed=YES;
        
        if ([userDefaults objectForKey:@"indexCellCell"]) {
            
      
         NSInteger index=[[userDefaults objectForKey:@"indexCellCell"] integerValue];
        VC.name=self.nameArr[index];
        VC.imei=[userDefaults objectForKey:@"lastImei"];
                 }
        [self.navigationController pushViewController:VC animated:YES];
        
        
        
        
    }
    else if (indexPath.row==3){
        FangzousanViewController * VC=[[FangzousanViewController alloc]init];
        VC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    else{
        NSString * title=self.navigationItem.title;
        NSInteger index=[[userDefaults objectForKey:@"indexCellCell"] integerValue];
        
        if (self.arr1.count !=0) {
         NSString * str1=self.nameArr[index];
        
        
        if (![title isEqualToString: str1]) {
            [MBProgressHUD showSuccess:@"设备不在线" toView:self.view];
        }

        
        else if ([title isEqualToString: str1]){
            
            //创建请求工具对象
            LKLNetToll *newWorkTool = [LKLNetToll shareInstance];
            
            //设置网络请求标识
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

            self.tokenURL=[userDefaults objectForKey:@"userTokentoken"];
            NSString * number=[userDefaults objectForKey:@"USERname"];
            NSString * imeiStr=    [userDefaults objectForKey:@"lastImei"];
            
            NSString * listenURL1=[NSString stringWithFormat:@"%@token=%@&imei=%@&number=%@",listenURL,self.tokenURL,imeiStr,number];
            NSLog(@"监听%@",listenURL1);
            [newWorkTool GET:listenURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"监听响应%@",responseObject);
                
                if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
                    [MBProgressHUD showSuccess:@"发送指令成功" toView:self.view];
                }
                else{
                    [MBProgressHUD showSuccess:@"发送指令失败" toView:self.view];
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                 [MBProgressHUD showSuccess:@"发送指令失败" toView:self.view];
            }];

            
        }
        else{
        
            [MBProgressHUD showSuccess:@"请选择设备" toView:self.view];
        }
        }
    }
    }
    }
    }

#pragma  mark ---请求所有绑定的手表
-(void)requestdata{
    self.arr1=[NSMutableArray array];
    self.nameArr=[NSMutableArray array];
    self.phoneArr=[NSMutableArray array];
        [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
        //创建请求工具对象
        LKLNetToll *newWorkTool = [LKLNetToll shareInstance];
        
        //设置网络请求标识
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        self.tokenURL=[userDefaults objectForKey:@"userTokentoken"];
        NSString * getBondsURL1=[NSString stringWithFormat:@"%@token=%@",getBondsURL,self.tokenURL];
        NSLog(@"设备%@",getBondsURL1);
        [newWorkTool GET:getBondsURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"获取绑定的手表%@",responseObject);
            if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
    
               [self viewControllerHideHud];

                NSArray * arr2=[[NSArray alloc]init];
                arr2= responseObject[@"data"];
                for (NSDictionary * dict in arr2) {
                    GetBondsModel * getBondsModel=[GetBondsModel getBondsModelWithDict:dict];
                    NSString * str1=getBondsModel.imei;
                    
                    NSString * str2=getBondsModel.name;
                    [self.arr1 addObject:str1];
                    [self.nameArr addObject:str2];
                    [self.phoneArr addObject:getBondsModel.phone];
                }
                
                NSString * imei= [userDefaults objectForKey:@"lastImei"];
                if( !imei || [self.arr1 indexOfObject:imei] == -1){
                    //[self.tableView selectRowAtIndexPath: [NSIndexPath indexPathWithIndex:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                    
                    imei = [self.arr1 firstObject];
                    [userDefaults setObject:imei forKey:@"lastImei"];
                    [self requestDataWithString1:imei];
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


-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
//文本自适应高度
    
    
    
//    NSDictionary *dic = @{
//                          NSFontAttributeName : [UIFont systemFontOfSize:13]
//                          };
//    
//    CGRect rect = [self.addressLabel.text boundingRectWithSize:CGSizeMake(ScreenWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
//    
//    CGRect frame=self.addressLabel.frame;
//    
//    frame.size.height=rect.size.height + 10;
//    frame.origin.x=0;
//    frame.origin.y=64+ScreenHeight * 0.7;
//    frame.size.width=ScreenWidth;
//    self.addressLabel.frame=frame ;
//    CGRect rect1=CGRectMake(0, 0, ScreenWidth, (ScreenHeight-64-49-ScreenHeight*0.7) - frame.size.height);
//    
//    CGRect frame1=self.timeLabel.frame;
//    
//    frame1.size.height=rect1.size.height ;
//    
//    frame1.origin.y=ScreenHeight * 0.7 + frame.size.height + 64;
//    frame1.size.width=ScreenWidth;
//    frame1.origin.x=0;
//    
//    self.timeLabel.frame=frame1;
    

}


#pragma  mark ---视图将要显示
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    ChatDAtabase * chat=[ChatDAtabase shareManager];
    if (chat.newMessage==NO) {
  ClassCollectionViewCell * cell=   (ClassCollectionViewCell *)   [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
        cell.redView.hidden=YES;
    }
    
    
    self.appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    UIBarButtonItem * rightButtonItem=[[UIBarButtonItem alloc]initWithTitle:Localized(@"➕") style:UIBarButtonItemStylePlain target:self action:@selector(loginAction:)];
    self.navigationItem.rightBarButtonItem=rightButtonItem;
   
    
    [self requestdata];
    
    if(![userDefaults boolForKey:@"firstStart"]){
        [userDefaults setBool:YES forKey:@"firstStart"];
        NSLog(@"第一次启动");
        
        [self getUserLocation];
        
    }else{
        NSLog(@"不是第一次启动");
        
        NSString * str=[userDefaults objectForKey:@"lastImei"];
        NSLog(@"最后一次点击的imei%@",str);
        if (str==nil) {
            NSMutableArray * arr= [userDefaults objectForKey:@"imeiArr"];
            NSString * imei=arr.lastObject;
            
            if (arr==nil) {
                
                [self getUserLocation];
            }
            else{
                [self requestDataWithString1:imei];
                
                
            }
            
        }
        //str不是空
        else{
            
            [self requestDataWithString:str];
        }
    }

}

@end
