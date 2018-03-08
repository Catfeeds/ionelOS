//
//  EditClockViewController.m
//  ione
//
//  Created by lkl on 2017/5/12.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "EditClockViewController.h"
#import "EditClock.h"
#import "LKLNetToll.h"
#import "UIViewController+hide.h"
@interface EditClockViewController ()<ZESegmentedsViewDelegate,clickbuttondelegate,UWDatePickerViewDelegate>
@property(nonatomic,strong)PickerView *pickerView;
@property(nonatomic,strong)UIView * bgView;//pickerview的背景视图
@property(nonatomic,strong)EditClock *EditClockview;
@end

@implementation EditClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=@"修改闹钟";
    self.view.backgroundColor=[UIColor whiteColor];
    _EditClockview=[[EditClock alloc]initwitheditframe:CGRectMake(10, 64, ScreenWidth-20, ScreenHeight * 0.3)];
    _EditClockview.semtsView.delegate=self;
    _EditClockview.clickdelegate=self;
    _EditClockview.lklButton1.label.text=self.model.begin;
    _EditClockview.repeatStr=self.model.repeat;
    _EditClockview.text.text=self.model.about;
    [self.view addSubview:_EditClockview];
    UIBarButtonItem * right=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(tapped)];
    
    self.navigationItem.rightBarButtonItem = right;
}

-(void)tapped{
    NSString * str=[NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld%ld",_EditClockview.a,_EditClockview.b,_EditClockview.c,_EditClockview.d,_EditClockview.e,_EditClockview.f,_EditClockview.g];
    [SVProgressHUD showWithStatus:@"修改中" maskType:SVProgressHUDMaskTypeClear];
    LKLNetToll * net=[LKLNetToll shareInstance];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    NSString * setDeviceURL1=[NSString stringWithFormat:@"%@&token=%@&imei=%@&index=%@&begin=%@&about=%@&repeat=%@",clockEditURL,[userDefaults objectForKey:@"userTokentoken"],[userDefaults objectForKey:@"lastImei"],self.model.index,_EditClockview.lklButton1.label.text,_EditClockview.text.text,str];
    
    NSString * url=[setDeviceURL1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [net GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"结果%@",responseObject);
        
        if ([responseObject[@"errcode"] integerValue]==0) {
            
            [self viewControllerHideHud];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        else{
        [self viewControllerHideHud];
            [self fail];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
}

#pragma mark___zeviewdelegate
- (void)selectedZESegmentedsViewItemAtIndex:(NSInteger )selectedItemIndex{
    
    switch (selectedItemIndex) {
        case 0:
            NSLog(@"点击了-->周日");
            
            _EditClockview.a=1;
            break;
        case 1:
            NSLog(@"点击了-->周一");
            
            _EditClockview.b=1;
            break;
        case 2:
            NSLog(@"点击了-->周二");
            
            _EditClockview.c=1;
            break;
        case 3:
            NSLog(@"点击了-->周三");
            
            _EditClockview.d=1;
            break;
        case 4:
            NSLog(@"点击了-->周四");
            
            _EditClockview.e=1;
            break;
        case 5:
            NSLog(@"点击了-->周五");
            
            _EditClockview.f=1;
            break;
        case 6:
            NSLog(@"点击了-->周六");
            
            _EditClockview.g=1;
            break;
        case 1000:
            NSLog(@"取消了-->周日");
            
            _EditClockview.a=0;
            break;
        case 1001:
            NSLog(@"取消了-->周一");
            
            _EditClockview.b=0;
            break;
        case 1002:
            NSLog(@"取消了-->周二");
            
            _EditClockview.c=0;
            break;
        case 1003:
            NSLog(@"取消了-->周三");
            
            _EditClockview.d=0;
            break;
        case 1004:
            NSLog(@"取消了-->周四");
            
            _EditClockview.e=0;
            break;
        case 1005:
            NSLog(@"取消了-->周五");
            
            _EditClockview.f=0;
            break;
        case 1006:
            NSLog(@"取消了-->周六");
            _EditClockview.g=0;
            break;
            
        default:
            break;
    }
    
}

#pragma mark -----cilickdelegate
-(void)cickbutton:(UIButton *)button
{
  
        [self setupDateView:DateTypeOfStart];
    
}

- (void)setupDateView:(DateType)type {
    _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _bgView.backgroundColor=[UIColor colorWithWhite:0.2 alpha:0.5];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    
    
    _pickerView = [PickerView instancePickerView];
    _pickerView.frame = CGRectMake(0,ScreenHeight, ScreenWidth, ScreenHeight * 0.4);
    
    
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    formatter.dateStyle=NSDateFormatterMediumStyle;
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm"];
    
    NSDate * datepre=[formatter dateFromString:self.model.begin];
    NSLog(@"date=%@",datepre);
    
    _pickerView.datePickerView.date=datepre;
    
    
    _pickerView.delegate = self;
    _pickerView.type = type;
    
    [self.bgView addSubview:_pickerView];
    
    [UIView animateWithDuration:0.3 animations:^{
        _pickerView.transform=CGAffineTransformMakeTranslation(0, -ScreenHeight * 0.4);
        
    }];
    
    
    
    
}


-(void)removedatepicker{
    [self.bgView removeFromSuperview];
}
- (void)getSelectDate:(NSString *)date type:(DateType)type {
    
    
    //    self.date=date;
    
    switch (type) {
        case DateTypeOfStart:
            
            
            _EditClockview.lklButton1.label.text=date;
            NSLog(@"时间%@",date);
            
            break;
    
        default:
            break;
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
