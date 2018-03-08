//
//  LishiViewController.m
//  ione
//
//  Created by lkl on 2017/4/17.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "LishiViewController.h"

#import "FDCalendar.h"
#import "LKLNetToll.h"
#import "UIViewController+hide.h"
#import <MapKit/MapKit.h>
#import "HistoryModel.h"
#import "MBProgressHUD+Add.h"
@interface LishiViewController ()<MKMapViewDelegate,mydelegate>
@property (weak, nonatomic) IBOutlet UIButton *todayButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextbutton;
@property (weak, nonatomic) IBOutlet UISlider *mySlider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(nonatomic,strong)NSMutableArray * dataArr;//数据源
@property(nonatomic,strong)FDCalendar * calendar;//日历
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic,strong) NSDate *confromTimesp;
@property(nonatomic,strong)NSMutableArray * slideArr;
@property(nonatomic,strong)MKPolyline * polyline;
@end

@implementation LishiViewController
-(NSMutableArray * )dataArr{
    if (_dataArr==nil) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)slideArr{
    if (_slideArr==nil) {
        _slideArr=[NSMutableArray array];
    }
    return _slideArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"历史轨迹";
    
    
    [self.mySlider setThumbImage:[UIImage imageNamed:@"猫"] forState:UIControlStateNormal];
    
    //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
    [self.mySlider setThumbImage:[UIImage imageNamed:@"猫"] forState:UIControlStateHighlighted];
    
    
    NSDate * date=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    [self.todayButton setTitle:dateString forState:UIControlStateNormal];
    [self.todayButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    _calendar = [[FDCalendar alloc] initWithCurrentDate:[NSDate date]];
    _calendar.mydelegete=self;
    
    
    CGFloat tableViewY = CGRectGetMaxY(_calendar.frame);
    CGRect frame=CGRectMake(0, 64+40, ScreenWidth, tableViewY);
    
    _calendar.frame = frame;
    _calendar.hidden=YES;
    [self.view addSubview:_calendar];

   
    
    self.previousButton.layer.cornerRadius=5.0;
    self.previousButton.layer.masksToBounds=YES;
    self.previousButton.layer.borderWidth=0.5;
    self.previousButton.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    
    self.nextbutton.layer.cornerRadius=5.0;
    self.nextbutton.layer.masksToBounds=YES;
    
    self.nextbutton.layer.borderWidth=0.5;
    
    self.nextbutton.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    formatter.dateStyle=NSDateFormatterMediumStyle;
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    
    NSDate * date1=[formatter dateFromString:self.todayButton.titleLabel.text];
    
    NSString * end=[NSString stringWithFormat:@"%ld",(long)[date1 timeIntervalSince1970]];
    
    NSInteger  a=[end integerValue]  ;
    
    NSString * bigin=[NSString stringWithFormat:@"%ld",(long)a];
    
    NSInteger b=a + 86400;
    NSString * end1 =[NSString stringWithFormat:@"%ld",(long)b];
    
    [self loadLineWithString:bigin WithString:end1];
}
- (IBAction)todayButtonTapped:(id)sender {
    UIButton * button=sender;
    button.tag=!button.tag;
    NSLog(@"tag%ld",button.tag);

    if (button.tag!=0) {
           _calendar.hidden=NO;
        
    }
    else if(button.tag==0){
          _calendar.hidden=YES;
     
    }
    
}
- (IBAction)slide:(id)sender {
    self.mySlider=sender;
    NSLog(@"多少%f",self.mySlider.value);
    
    [self.slideArr addObject:[NSNumber numberWithInteger:self.mySlider.value]];
    
    NSString * ttt=   [self getMMSSFromSS:[NSString stringWithFormat:@"%@",_slideArr.lastObject]];
    
    self.timeLabel.text=ttt;
    
    
    
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    formatter.dateStyle=NSDateFormatterMediumStyle;
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    
    NSDate * datepre=[formatter dateFromString:self.todayButton.currentTitle];
    
    NSLog(@"标题1=%@",self.todayButton.currentTitle);


    
    NSString *  timeSp = [NSString stringWithFormat:@"%ld", (long)[datepre timeIntervalSince1970]];
    NSInteger next=[timeSp integerValue] ;//时间到时间戳
 
    
    NSString * bigin=[NSString stringWithFormat:@"%ld",(long)next];
    
    NSInteger b=next + self.mySlider.value  ;
    
    NSString * end1 =[NSString stringWithFormat:@"%ld",(long)b];
    
    [self loadLineWithString:bigin WithString:end1 ];
}


//传入 秒  得到 xx:xx:xx
-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_hour,str_minute];
    
    return format_time;
    
}
//绘制路线
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 5.f;
        polylineRenderer.strokeColor  = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.6];
        
        polylineRenderer.lineJoin = kCGLineJoinRound;
        polylineRenderer.lineCap  = kCGLineCapRound;
        
        return polylineRenderer;
    }
    
    return nil;
}
-(void)loadLineWithString:(NSString *)str1 WithString :(NSString *)str2{
    if (self.polyline) {
        [self.mapView removeOverlay:self.polyline];
        self.polyline=nil;
    }
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
 
    NSString * histrory=[NSString stringWithFormat:@"%@token=%@&imei=%@&begin=%@&end=%@&coordtype=gcj02",historyURL,[userDefaults objectForKey:@"userTokentoken"],[userDefaults objectForKey:@"lastImei"],str1,str2];
    
    NSString * history1=    [histrory stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"lishi%@",history1);
    LKLNetToll * netToll=[LKLNetToll shareInstance];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    [netToll GET:history1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"历史数据%@",responseObject);
        
        if ([responseObject[@"errcode"] integerValue]==0) {
            [self viewControllerHideHud];
            self.dataArr=[NSMutableArray array];
            NSDictionary * dict=[NSDictionary dictionary];
            
            dict=responseObject[@"data"];
            if (dict.count==0) {
                
                   [self hideMbprogress];
            }
            else{
                for (NSDictionary * dictt in responseObject[@"data"]) {
                    HistoryModel * model=[HistoryModel HistoryModelWithDict:dictt];
                    
                    [self.dataArr addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    CLLocationCoordinate2D geodesicCood[self.dataArr.count];
                    
                    for (int i=0; i<self.dataArr.count; i++) {
                        HistoryModel *model=self.dataArr[i];
                        double lat=  model.lat;
                        double lng=model.lng;
                        geodesicCood[i].latitude=lat;
                        geodesicCood[i].longitude=lng;
                        
                    }
                    //构造折线对象
                
                   
                           self.polyline = [MKPolyline polylineWithCoordinates:geodesicCood count:self.dataArr.count];
                  
//                    HistoryModel * model=self.dataArr.firstObject;
//                    NSLog(@"model%f,%f",model.lat,model.lng);
                    
                    
                    if (self.polyline==nil) {
                           [self hideMbprogress];
                    }
                    else{
                        
                        [_mapView addOverlay:self.polyline];
                        HistoryModel *model=   self.dataArr.firstObject;
                        
                        CLLocationCoordinate2D www=CLLocationCoordinate2DMake(model.lat, model.lng);
                            MKCoordinateSpan span=MKCoordinateSpanMake(0.01,0.01);
                            MKCoordinateRegion region=MKCoordinateRegionMake(www, span);
                            _mapView.region =region;
                        
                    }
                    
                });
            }
            
            
        }
        
        //返回其他的结果
        else {
            [self viewControllerHideHud];
            
            [self hideMbprogress];
        
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误%@",error);
        [self viewControllerHideHud];
        
        [self hideMbprogress];
    }];

}
- (IBAction)previoustapped:(id)sender {
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    formatter.dateStyle=NSDateFormatterMediumStyle;
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    NSDate * datepre=[formatter dateFromString:self.todayButton.currentTitle];
    
    
    
    NSString *  timeSp = [NSString stringWithFormat:@"%ld", (long)[datepre timeIntervalSince1970]];
    NSInteger previous=[timeSp integerValue] -86400;//时间到时间戳
    
    
    
    _confromTimesp = [NSDate dateWithTimeIntervalSince1970:previous];//时间戳到时间
    
    NSString *confromTimespStr = [formatter stringFromDate:_confromTimesp];
    
    
    [self.todayButton setTitle:confromTimespStr forState:UIControlStateNormal];

    NSLog(@"标题1=%@",self.todayButton.currentTitle);
    
    
    NSString * end=[NSString stringWithFormat:@"%ld",(long)[_confromTimesp timeIntervalSince1970]];
    
    NSInteger  a=[end integerValue] ;
    
    NSString * bigin=[NSString stringWithFormat:@"%ld",(long)a];
    
    NSInteger b=a +86400  ;
    NSString * end1 =[NSString stringWithFormat:@"%ld",(long)b];
    
    [self loadLineWithString:bigin WithString:end1 ];

    
    
}
- (IBAction)nexttapped:(id)sender {

    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    formatter.dateStyle=NSDateFormatterMediumStyle;
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    
    NSDate * datepre=[formatter dateFromString:self.todayButton.currentTitle];
    
    
  
  NSString *  timeSp = [NSString stringWithFormat:@"%ld", (long)[datepre timeIntervalSince1970]];
    NSInteger next=[timeSp integerValue] +86400;//时间到时间戳
    
    
    
    _confromTimesp = [NSDate dateWithTimeIntervalSince1970:next];//时间戳到时间
    
    NSString *confromTimespStr = [formatter stringFromDate:_confromTimesp];
    
    
    [self.todayButton setTitle:confromTimespStr forState:UIControlStateNormal];


    
    NSLog(@"标题1=%@",self.todayButton.currentTitle);
    
    
    NSString * end=[NSString stringWithFormat:@"%ld",(long)[_confromTimesp timeIntervalSince1970]];
    
    NSInteger  a=[end integerValue] ;
    
    NSString * bigin=[NSString stringWithFormat:@"%ld",(long)a];
    
    NSInteger b=a +86400  ;
    NSString * end1 =[NSString stringWithFormat:@"%ld",(long)b];
    
    [self loadLineWithString:bigin WithString:end1 ];

}
#pragma mark ___fdcalender 代理
-(void)passDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    [self.todayButton setTitle:dateString forState:UIControlStateNormal];
    
}
#pragma mark ___fdcalender 代理
-(void)requestLineData{
    
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    formatter.dateStyle=NSDateFormatterMediumStyle;
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    
    NSDate * datepre=[formatter dateFromString:self.todayButton.currentTitle];
    
    
    
    NSString *  timeSp = [NSString stringWithFormat:@"%ld", (long)[datepre timeIntervalSince1970]];
    
    NSInteger next=[timeSp integerValue] ;//时间到时间戳
 
    NSString * bigin=[NSString stringWithFormat:@"%ld",(long)next];
    
    NSInteger b=next +86400  ;
    NSString * end1 =[NSString stringWithFormat:@"%ld",(long)b];
    
    [self loadLineWithString:bigin WithString:end1];

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
