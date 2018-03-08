//
//  SelectWeilanViewController.m
//  ione
//
//  Created by lkl on 2017/4/21.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "SelectWeilanViewController.h"
#import "LKLNetToll.h"
#import "UIViewController+hide.h"
#import "TransformToMarsTool.h"
#import "DeviceChooseViewController.h"
@interface SelectWeilanViewController ()<MKMapViewDelegate,selectNameToDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic,strong)MKCircle * circle1;//默认的围栏

@property(nonatomic,strong)MKCircle * circle;//手指按的位置的圆



@property(nonatomic,strong)MKCircleView * circleView;//圆形图层

@property(nonatomic,assign)CGPoint p1;//手指的按的位置

@property(nonatomic,assign)CLLocationCoordinate2D p1coordinate;//手指按的位置



@property(nonatomic,strong)CLGeocoder * clGecoder;
@property(nonatomic,strong)NSArray * deviceNameArr;
@property(nonatomic,strong)NSArray * imeiArr;


@property(nonatomic,copy)NSString * imeiStr;
@property(nonatomic,strong)  NSString * addFineURL1;
@end

@implementation SelectWeilanViewController
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
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.nametext.layer.borderWidth=0.5;
    self.nametext.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    self.nametext.layer.masksToBounds=YES;
    self.nametext.layer.cornerRadius=5.0;
    
    self.adressLabel.layer.borderWidth=0.5;
    self.adressLabel.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    self.adressLabel.layer.masksToBounds=YES;
    self.adressLabel.layer.cornerRadius=5.0;
    
    self.deviceLabel.layer.borderWidth=0.5;
    self.deviceLabel.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    self.deviceLabel.layer.masksToBounds=YES;
    self.deviceLabel.layer.cornerRadius=5.0;
    self.title=@"安全区域";
    
    self.nametext.text=self.model.name;
    self.adressLabel.text=self.model.address;
    
   
 
 NSString * str=@"";
    for (int i=0; i<self.model.deviceArr.count; i++) {
         NSInteger a=[self.imeiarr indexOfObject:self.model.deviceArr[i]];
        NSString * name=self.namearr[a];
        if (i==self.model.deviceArr.count-1) {
            
             str=[str stringByAppendingFormat:@"%@",name];
        }
        else{
            str=[str stringByAppendingFormat:@"%@,",name];
        }
       
        
        
    }
    
    self.deviceLabel.text=str;
    
    [self.myslider setThumbImage:[UIImage imageNamed:@"猫"] forState:UIControlStateNormal];
    
    //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
    [self.myslider setThumbImage:[UIImage imageNamed:@"猫"] forState:UIControlStateHighlighted];
    self.myslider.value=self.model.radius;
    
    NSInteger a= ceilf(self.myslider.value *1.0);
    self.myLabel.text=[NSString stringWithFormat:@"%ldm",(long)a];
    
    CLLocationCoordinate2D www=CLLocationCoordinate2DMake(self.model.lat1 , self.model.lng1);
    MKCoordinateSpan span=MKCoordinateSpanMake(0.02,0.02);
    MKCoordinateRegion region=MKCoordinateRegionMake(www, span);
    _mapView.region =region;
    
    [self getFine];
    
    
    
    
    UILongPressGestureRecognizer * longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration=0.3;
    [_mapView addGestureRecognizer:longPress];
}

- (IBAction)up:(id)sender {
    
    DeviceChooseViewController * vc=[[DeviceChooseViewController alloc]init];
    vc.myDelegete=self;
    vc.imeiarr=self.imeiarr;
    
    vc.namearr=self.namearr;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)slider:(id)sender {
    
    UISlider * slider=sender;
    NSLog(@"多少%f",slider.value);
    NSInteger a=ceilf(slider.value * 1.0 );
     self.myLabel.text=[NSString stringWithFormat:@"%ldm",(long)a];
    //手纸按的圆
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
    
    //没有手纸按的，默认的位置
    else{
        if (_circle1) {
            [self.mapView removeOverlay:_circle1];
        }
        
  //默认的的围栏
   CLLocationCoordinate2D  q=     CLLocationCoordinate2DMake(self.model.lat1, self.model.lng1);
        
        _circle1=[MKCircle circleWithCenterCoordinate:q radius: slider.value];
        [self.mapView addOverlay:_circle1];
        
    }
    

}
- (IBAction)save:(id)sender {
    [SVProgressHUD showWithStatus:@"修改中" maskType:SVProgressHUDMaskTypeClear];
    
    if (self.deviceLabel.text.length==0) {
        
        [SVProgressHUD showErrorWithStatus:@"选择设备" maskType:SVProgressHUDMaskTypeClear];
        return;
    }
    if (self.nametext.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入围栏名字" maskType:SVProgressHUDMaskTypeClear];
        return;
    }
    else{
        
        
        NSString *  nameURL1=self.nametext.text;
        
        NSString * typed=@"circle";
        
        
        //火星转gps
        LKLNetToll * netToll=[LKLNetToll shareInstance];
        //设置网络请求标识
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
      //存在手纸点的
      
        
        
        
        if (_circle) {
            NSString * convertC2d=[NSString stringWithFormat:@"%@from=gcj02&to=wgs84&lat=%f&lng=%f",convertCoordinate,_p1coordinate.latitude,_p1coordinate.longitude];
            
            [netToll GET:convertC2d parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
             
                
                if (_imeiStr.length!=0) {
         _addFineURL1   =[NSString stringWithFormat:@"%@token=%@&id=%ld&imei=%@&name=%@&type=%@&lng1=%f&lat1=%f&lng2=0&lat2=0&radius=%f&address=%@",updateFine,[userDefaults objectForKey:@"userTokentoken"],(long)self.model.ID,_imeiStr,nameURL1,typed,[responseObject[@"data"][@"lng"] doubleValue],[responseObject[@"data"][@"lat"] doubleValue],_circle.radius,self.adressLabel.text];
                }
                else if (_imeiStr.length==0){
                    
                    NSArray * strArr=   [self.deviceLabel.text componentsSeparatedByString:@","];
                    NSString * str=@"";
                    
                    for (int i=0; i<strArr.count; i++) {
                        NSString * t=strArr[i];
                        NSInteger mm=  [self.namearr indexOfObject:t]  ;
                        NSString * pp=self.imeiarr[mm];
                        if (i==0) {
                            str=[str stringByAppendingFormat:@"%@",pp];
                        }
                        else{
                            str=[str stringByAppendingFormat:@",%@",pp];
                        }
                    }
                    _addFineURL1   =[NSString stringWithFormat:@"%@token=%@&id=%ld&imei=%@&name=%@&type=%@&lng1=%f&lat1=%f&lng2=0&lat2=0&radius=%f&address=%@",updateFine,[userDefaults objectForKey:@"userTokentoken"],(long)self.model.ID,str,nameURL1,typed,[responseObject[@"data"][@"lng"] doubleValue],[responseObject[@"data"][@"lat"] doubleValue],_circle.radius,self.adressLabel.text];
                                    }
 
                NSString * urlString = [_addFineURL1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSLog(@"修改%@",urlString);
                [netToll GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    NSLog(@"修改%@",responseObject);
                    if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
                        [self viewControllerHideHud];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [self viewControllerHideHud];
                    [SVProgressHUD showErrorWithStatus:@"上传失败" maskType:SVProgressHUDMaskTypeClear];
                }];
  
               
                
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
            
            
        }
        else{
            NSString * convertC2d=[NSString stringWithFormat:@"%@from=gcj02&to=wgs84&lat=%f&lng=%f",convertCoordinate,self.model.lat1,_model.lng1];
            [netToll GET:convertC2d parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                if (_imeiStr.length!=0) {
                    _addFineURL1=[NSString stringWithFormat:@"%@token=%@&id=%ld&imei=%@&name=%@&type=%@&lng1=%f&lat1=%f&lng2=0&lat2=0&radius=%f&address=%@",updateFine,[userDefaults objectForKey:@"userTokentoken"],(long)self.model.ID,_imeiStr,nameURL1,typed,[responseObject[@"data"][@"lng"] doubleValue], [responseObject[@"data"][@"lat"] doubleValue] ,_circle1.radius,self.adressLabel.text];
                }
                else if (_imeiStr.length==0){
                    NSArray * strArr=          [self.deviceLabel.text componentsSeparatedByString:@","];
                    NSString * str=@"";
                    
                    for (int i=0; i<strArr.count; i++) {
                        NSString * t=strArr[i];
                        NSInteger mm=  [self.namearr indexOfObject:t]  ;
                        NSString * pp=self.imeiarr[mm];
                        
                        if (i==0) {
                            str=[str stringByAppendingFormat:@"%@",pp];
                        }
                        else{
                            str=[str stringByAppendingFormat:@",%@",pp];
                        }
                    }
                    
                    
                    
                    _addFineURL1=[NSString stringWithFormat:@"%@token=%@&id=%ld&imei=%@&name=%@&type=%@&lng1=%f&lat1=%f&lng2=0&lat2=0&radius=%f&address=%@",updateFine,[userDefaults objectForKey:@"userTokentoken"],(long)self.model.ID,str,nameURL1,typed,[responseObject[@"data"][@"lng"] doubleValue], [responseObject[@"data"][@"lat"] doubleValue] ,_circle1.radius,self.adressLabel.text];
                    
                }
                
                NSString * urlString = [_addFineURL1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSLog(@"修改%@",urlString);
                [netToll GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    NSLog(@"修改%@",responseObject);
                    if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
                        [self viewControllerHideHud];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [self viewControllerHideHud];
                    [SVProgressHUD showErrorWithStatus:@"上传失败" maskType:SVProgressHUDMaskTypeClear];
                }];
 
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
            
        }
       
      
                
            }
            
  
}
-(void)getFine{
    
    CLLocationCoordinate2D center=CLLocationCoordinate2DMake(self.model.lat1,self.model.lng1);
    
    
    
    CLLocationDistance distance = self.model.radius;
    
    _circle1 = [MKCircle circleWithCenterCoordinate:center radius:distance];
    
    [_mapView addOverlay: _circle1];
    
}
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKCircle class]])
    {
        MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:overlay];
        
        circleView.lineWidth = 5.f;
        circleView.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
        circleView.fillColor =[UIColor colorWithRed:0 green:1 blue:0 alpha:0.5];
        
        return circleView;
    }
    return nil;
}



#pragma mark ----长按屏幕获取weilan区域
-(void)longPress:(UIGestureRecognizer *)gesturerecongnizer{
    
    if (gesturerecongnizer.state == UIGestureRecognizerStateEnded) {
        
        return;
        
    } else if (gesturerecongnizer.state == UIGestureRecognizerStateBegan) {
        if (_circle1) {
            [self.mapView removeOverlay:_circle1];
        }
        if (_circle) {
            [self.mapView removeOverlay:_circle];
        }
        _p1=[gesturerecongnizer locationInView:self.view];
        
        _p1coordinate=[self.mapView convertPoint:_p1 toCoordinateFromView:self.view];
        
        self.myslider.value=500.0;
        self.myLabel.text=@"500m";
        
        NSLog(@"p1的经纬度%f,%f",_p1coordinate.latitude,_p1coordinate.longitude);
        _circle=[MKCircle circleWithCenterCoordinate:_p1coordinate radius:500.0];//按住点的围栏
        
        [_mapView addOverlay:_circle];
        
        self.myslider.value=500.0;
        [self revertWithlocationLat:_p1coordinate.latitude withlng:_p1coordinate.longitude];
    }
}

//反地理编码
-(void)revertWithlocationLat :(CLLocationDegrees)a withlng :(CLLocationDegrees)b{
    
    CLLocation * location=[[CLLocation alloc]initWithLatitude:a longitude:b];
    self.clGecoder=[[CLGeocoder alloc]init];
    [self.clGecoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSLog(@"111%@",placemarks.lastObject.locality);
        
        
        self.adressLabel.text=[NSString stringWithFormat:@"%@%@",placemarks.lastObject.locality,placemarks.lastObject.name];
    }];
    
}

#pragma mark ---代理传值
-(void)passSelectedArr:(NSMutableArray *)arr WithIndexArr:(NSMutableArray *)indexarr{
    self.deviceNameArr=[NSArray array];
    self.imeiArr=[NSArray array];
    self.deviceNameArr=arr;
    
   
    self.imeiArr=indexarr;
    
  
    
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
    
    if (self.imeiArr) {
        
        
        for (int i=0;i<self.imeiArr.count; i++ ) {
            
            
            if (i==0) {
                _imeiStr=[_imeiStr stringByAppendingFormat:@"%@",self.imeiArr[i]];
                
            }
            else{
                _imeiStr=[_imeiStr stringByAppendingFormat:@",%@",self.imeiArr[i]];
                
            }
            
        }
        
    }

}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

@end
