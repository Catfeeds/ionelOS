//
//  WeiLanSettingViewController.m
//  ione
//
//  Created by lkl on 2017/4/17.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "WeiLanSettingViewController.h"
#import "DeviceChooseViewController.h"
#import "LKLNetToll.h"
#import "TransformToMarsTool.h"
#import "UIViewController+hide.h"
@interface WeiLanSettingViewController ()<selectNameToDelegate,CLLocationManagerDelegate,MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property(nonatomic,strong)NSArray * deviceNameArr;//传过来的手表的名字数组
@property(nonatomic,strong)MKCircle * circle;//手指按的位置的圆
@property(nonatomic,strong)MKCircle * circle1;//手机定位着的位置de圆
@property(nonatomic,strong)NSString * tokenURL;
@property(nonatomic,strong)NSArray * imeiArr;//传过来收不傲的imei数组
@property(nonatomic,copy)NSString * imeiStr;//选择的设备号

@property(nonatomic,strong)MKCircleView * circleView;//圆形图层

@property(nonatomic,assign)CGPoint p1;//手指的按的位置
@property(nonatomic,assign)CGPoint p2;

@property(nonatomic,assign)CLLocationCoordinate2D p1coordinate;//手指按的位置
@property(nonatomic,assign)CLLocationCoordinate2D p2coordinate;//手机定位着的位置
@property(nonatomic,strong)CLLocationManager * locationManager;
@property(nonatomic,strong)CLGeocoder * clGecoder;
@property (weak, nonatomic) IBOutlet UISlider *mySlider;
@property(nonatomic,strong)NSArray * locationArr;
@end

@implementation WeiLanSettingViewController
-(NSArray *)locationArr{
    if (_locationArr==nil) {
        _locationArr=[NSArray array];
    }
    return _locationArr;

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
-(NSArray *)deviceNameArr{
    if (_deviceNameArr==nil) {
      self.deviceNameArr=[NSArray array];
    }
    return _deviceNameArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加安全区域";
    
    // Do any additional setup after loading the view from its nib.
    UILongPressGestureRecognizer * longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration=0.3;
    [_mapView addGestureRecognizer:longPress];
    
    
    _mapView.zoomEnabled = YES;
    _mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow; // 追踪用户位置.
   
     [self getUserLocation];
    
    
    self.clGecoder=[[CLGeocoder alloc]init];
    
    self.nameText.layer.borderWidth=0.5;
    self.nameText.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    self.nameText.layer.masksToBounds=YES;
     self.nameText.layer.cornerRadius=5.0;
    
    self.addressLable.layer.borderWidth=0.5;
    self.addressLable.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    self.addressLable.layer.masksToBounds=YES;
    self.addressLable.layer.cornerRadius=5.0;
    
    self.deviceLabel.layer.borderWidth=0.5;
    self.deviceLabel.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    self.deviceLabel.layer.masksToBounds=YES;
    self.deviceLabel.layer.cornerRadius=5.0;
  
    [self.mySlider setThumbImage:[UIImage imageNamed:@"猫"] forState:UIControlStateNormal];
    
    //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
    [self.mySlider setThumbImage:[UIImage imageNamed:@"猫"] forState:UIControlStateHighlighted];
    
}
//反地理编码
-(void)revertWithlocationLat :(CLLocationDegrees)a withlng :(CLLocationDegrees)b{
    
    CLLocation * location=[[CLLocation alloc]initWithLatitude:a longitude:b];
    [self.clGecoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSLog(@"111%@",placemarks.lastObject.locality);
        
        
        self.addressLable.text=[NSString stringWithFormat:@"%@%@",placemarks.lastObject.locality,placemarks.lastObject.name];
    }];

}
- (IBAction)buttonTapped:(id)sender {
    DeviceChooseViewController * Vc=[[DeviceChooseViewController alloc]init];
    Vc.myDelegete=self;
    
    Vc.imeiarr=self.imeiarr;
    
    Vc.namearr=self.namearr;
    
    [self.navigationController pushViewController:Vc animated:YES];
}

- (void)getUserLocation
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.distanceFilter = 50.0f;
    if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0))
    {
        [_locationManager requestAlwaysAuthorization];
        
    }else {
        [self showAlerViewWithTitle:@"提示" Message:@"定位服务当前可能尚未打开，请设置打开!"];
    }
    
    //更新位置
    [_locationManager startUpdatingLocation];
    
    
    
    
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status==kCLAuthorizationStatusNotDetermined) {
        NSLog(@"等待");
    }else if (status ==kCLAuthorizationStatusAuthorizedAlways || status== kCLAuthorizationStatusAuthorizedWhenInUse){
        
        NSLog(@"授权成功");
        [manager startUpdatingLocation ];
    }else{
        
        NSLog(@"授权失败");
    }
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //停止位置更新
    [manager stopUpdatingLocation];
    if (!_circle1) {
        self.locationArr=locations;
        CLLocation * location=locations.lastObject;
        
        _p2coordinate=  location.coordinate;
        
        CLLocationCoordinate2D qwer=[TransformToMarsTool transform:_p2coordinate];
        _circle1=[MKCircle circleWithCenterCoordinate:qwer radius:500.0];
        
        [_mapView addOverlay:_circle1];
        
         [self revertWithlocationLat:qwer.latitude withlng :qwer.longitude ];
    }
    
    
    
  
    
}
#pragma mark---画圆的圆形设置
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKCircle class]])
    {
        _circleView = [[MKCircleView alloc] initWithCircle:overlay];
        
        _circleView.lineWidth = 5.f;
        _circleView.strokeColor = [UIColor redColor];
        _circleView.fillColor =[UIColor colorWithRed:0 green:1 blue:0 alpha:0.5];
        
        return _circleView;
    }
    
    return nil;
}
#pragma mark ---滑杆滑动
- (IBAction)slidertapped:(id)sender {
    UISlider * slider=sender;
    NSLog(@"多少%f",slider.value);
    NSInteger a=ceilf(slider.value * 1.0 );
    self.tagLabel.text=[NSString stringWithFormat:@"%ldm",(long)a];
    
    
    if (_p1coordinate.latitude) {
        if (_circle) {
            [self.mapView removeOverlay:_circle];
        }
        _circle=[MKCircle circleWithCenterCoordinate:_p1coordinate radius: slider.value];
        if (_circle1) {
            [self.mapView removeOverlay:_circle1];
            _circle1=nil;
        }
        
        [self.mapView addOverlay:_circle];
    }
    else{
        if (_circle1) {
            [self.mapView removeOverlay:_circle1];
        }
        
        CLLocationCoordinate2D qwer=[TransformToMarsTool transform:_p2coordinate];//定位点的围栏
        
        _circle1=[MKCircle circleWithCenterCoordinate:qwer radius: slider.value];
        [self.mapView addOverlay:_circle1];
        
    }

    
}
#pragma mark 保存围栏
- (IBAction)savetapped:(id)sender {
    [SVProgressHUD showWithStatus:@"上传中" maskType:SVProgressHUDMaskTypeClear];
    
        if (self.deviceLabel.text.length==0) {
            
            [SVProgressHUD showErrorWithStatus:@"选择设备" maskType:SVProgressHUDMaskTypeClear];
            return;
        }
    if (self.nameText.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入围栏名字" maskType:SVProgressHUDMaskTypeClear];
        return;
    }
        else{
           
            CGRect rect;
            CLLocationCoordinate2D center;
            CLLocationDistance radius;
            if (_circle1) {
                MKMapRect ct1=_circle1.boundingMapRect;
                MKCoordinateRegion region=MKCoordinateRegionForMapRect(ct1);
                rect= [self.mapView convertRegion:region toRectToView:self.view];
                
                
                center=   _circle1.coordinate;
                radius=_circle1.radius;
            }
            
            else{
                
                MKMapRect ct=_circle.boundingMapRect;
                
                
                MKCoordinateRegion region=MKCoordinateRegionForMapRect(ct);
                rect= [self.mapView convertRegion:region toRectToView:self.view];
                center=_circle.coordinate;
                
                radius=_circle.radius;
            }
            
            
            NSString *  nameURL1=_nameText.text;
            NSString * typed=@"circle";

            
            //火星转gps
             LKLNetToll * netToll=[LKLNetToll shareInstance];
            //设置网络请求标识
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            self.tokenURL=[userDefaults objectForKey:@"userTokentoken"];
            NSString * convertC2d=[NSString stringWithFormat:@"%@from=gcj02&to=wgs84&lat=%f&lng=%f",convertCoordinate,center.latitude,center.longitude];
            
            [netToll GET:convertC2d parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"res=%@",responseObject);
                
                if ([responseObject[@"errcode"] integerValue]==0) {
                    
                    NSString * addFineURL1=[NSString stringWithFormat:@"%@token=%@&imei=%@&name=%@&type=%@&lng1=%f&lat1=%f&lng2=0&lat2=0&radius=%f&address=%@",addFineURL,self.tokenURL,_imeiStr,nameURL1,typed,[responseObject[@"data"][@"lng"] doubleValue],[responseObject[@"data"][@"lat"] doubleValue],radius,self.addressLable.text];
                    NSLog(@"添加围栏%@",addFineURL1);
                    
                    
                    NSString * urlString = [addFineURL1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    [netToll GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                        NSLog(@"添加%@",responseObject);
                        if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
                            [self viewControllerHideHud];
                            [self.navigationController popViewControllerAnimated:YES];
                            
                        }
                        
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                       [self viewControllerHideHud];
                        [SVProgressHUD showErrorWithStatus:@"上传失败" maskType:SVProgressHUDMaskTypeClear];
                    }];
                    
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];

            
            
        }

}
#pragma  mark----取消定位者的圆点
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

    
    return annoView;
    
   
  
    
}
#pragma mark ----长按屏幕获取weilan区域
-(void)longPress:(UIGestureRecognizer *)gesturerecongnizer{
    
    if (gesturerecongnizer.state == UIGestureRecognizerStateEnded) {
        
        return;
        
    } else if (gesturerecongnizer.state == UIGestureRecognizerStateBegan) {
        if (_circle1) {
            [self.mapView removeOverlay:_circle1];
            _circle1=nil;
        }
        if (_circle) {
            [self.mapView removeOverlay:_circle];
            _circle=nil;
        }
        _p1=[gesturerecongnizer locationInView:self.view];
        _p1coordinate=[self.mapView convertPoint:_p1 toCoordinateFromView:self.view];
        
        
        _circle=[MKCircle circleWithCenterCoordinate:_p1coordinate radius:500.0];//按住点的围栏
        
        [_mapView addOverlay:_circle];
        self.mySlider.value=500.0;
        self.tagLabel.text=@"500m";
        [self revertWithlocationLat:_p1coordinate.latitude withlng:_p1coordinate.longitude];
    }
}

#pragma mark ---代理传值
-(void)passSelectedArr:(NSMutableArray *)arr WithIndexArr:(NSMutableArray *)indexarr{
    
    self.deviceNameArr=arr;

    self.imeiArr=[NSArray array];
    self.imeiArr=indexarr;
    
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    
    NSString * deviceNAmestr=@"";
    
    if (self.deviceNameArr) {
        
    
    for (int i=0;i<self.deviceNameArr.count; i++ ) {
        if (i==0) {
            deviceNAmestr=[deviceNAmestr stringByAppendingFormat:@"%@",self.deviceNameArr[i]];
            
        }
        else{
            deviceNAmestr=[deviceNAmestr stringByAppendingFormat:@",%@",self.deviceNameArr[i]];
            
        }
        
    }
         self.deviceLabel.text=deviceNAmestr;
    }
  
    _imeiStr=@"";
    
    if (self.imeiarr) {
        
        
        for (int i=0;i<self.imeiarr.count; i++ ) {
            if (i==0) {
                _imeiStr=[_imeiStr stringByAppendingFormat:@"%@",self.imeiarr[i]];
                
            }
            else{
                _imeiStr=[_imeiStr stringByAppendingFormat:@",%@",self.imeiarr[i]];
                
            }
            
        }
        
    }
    
}
//手机
- (IBAction)deviceLoc:(id)sender {
    if (!_circle1) {
        
        [_mapView removeOverlay:_circle];
        _circle=nil;
        CLLocation * location=self.locationArr.lastObject;
        
        _p2coordinate=  location.coordinate;
        
        CLLocationCoordinate2D qwer=[TransformToMarsTool transform:_p2coordinate];
        _circle1=[MKCircle circleWithCenterCoordinate:qwer radius:500.0];
        
        [_mapView addOverlay:_circle1];
        self.mySlider.value=500.0;
        [self revertWithlocationLat:qwer.latitude withlng :qwer.longitude ];
    }
    if (_circle1) {
        
        [_mapView removeOverlay:_circle];
        _circle=nil;
        
        [_mapView removeOverlay:_circle1];
        _circle1=nil;
        
        CLLocation * location=self.locationArr.lastObject;
        
        _p2coordinate=  location.coordinate;
        
        CLLocationCoordinate2D qwer=[TransformToMarsTool transform:_p2coordinate];
        _circle1=[MKCircle circleWithCenterCoordinate:qwer radius:500.0];
        
        [_mapView addOverlay:_circle1];
        self.tagLabel.text=@"500m";
        [self revertWithlocationLat:qwer.latitude withlng :qwer.longitude ];
    }

    
}

//手表
- (IBAction)myLoc:(id)sender {
    if (!_circle1) {
        
        [_mapView removeOverlay:_circle];
        _circle=nil;
        
        
        _p2coordinate= CLLocationCoordinate2DMake(self.lat, self.lng);
        
        
        NSLog(@"wode%f",self.lat);
        
        _circle1=[MKCircle circleWithCenterCoordinate:_p2coordinate radius:500.0];
        
        [_mapView addOverlay:_circle1];
        
        [self revertWithlocationLat:_p2coordinate.latitude withlng :_p2coordinate.longitude ];
    }
    
    if (_circle1) {
        
        [_mapView removeOverlay:_circle];
        _circle=nil;
        
        [_mapView removeOverlay:_circle1];
        _circle1=nil;
        
        _p2coordinate= CLLocationCoordinate2DMake(self.lat, self.lng);
        
        
        NSLog(@"wode%f",self.lat);
        
        _circle1=[MKCircle circleWithCenterCoordinate:_p2coordinate radius:500.0];
        
        [_mapView addOverlay:_circle1];
        
        [self revertWithlocationLat:_p2coordinate.latitude withlng :_p2coordinate.longitude ];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
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
