//
//  MyDisturbViewController.m
//  ione
//
//  Created by lkl on 2017/5/2.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "MyDisturbViewController.h"
#import "LKLNetToll.h"
#import "UIViewController+hide.h"

#import "PickerView.h"
@interface MyDisturbViewController ()<ZESegmentedsViewDelegate,clickbuttondelegate,UWDatePickerViewDelegate>
@property(nonatomic,strong)PickerView *pickerView;
@property(nonatomic,strong)UIView * bgView;//pickerview的背景视图
@end

@implementation MyDisturbViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"设置免打扰";
    self.view.backgroundColor=[UIColor whiteColor];
 _lklview=[[Mydisturbview alloc]initMyViewWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight * 0.2)];
    
    _lklview.semtsView.delegate=self;
    _lklview.clickdelegate=self;
    _lklview.repeatStr=_repeat;
    _lklview.lklButton1.label.text=_begin;
    _lklview.lklButton2.label.text=_end;
    

    
    [self.view addSubview:_lklview];
    
    UIBarButtonItem * right=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(tapped)];
    
    self.navigationItem.rightBarButtonItem = right;
    
}
-(void)tapped{
     NSString * str=[NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld%ld",_lklview.a,_lklview.b,_lklview.c,_lklview.d,_lklview.e,_lklview.f,_lklview.g];
    [SVProgressHUD showWithStatus:@"修改中" maskType:SVProgressHUDMaskTypeClear];
    LKLNetToll * net=[LKLNetToll shareInstance];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    NSString * setDeviceURL1=[NSString stringWithFormat:@"%@&token=%@&imei=%@&indexes=%ld&begins=%@&ends=%@&repeats=%@",setDeviceURL,[userDefaults objectForKey:@"userTokentoken"],[userDefaults objectForKey:@"lastImei"],(long)_index,_lklview.lklButton1.label.text,_lklview.lklButton2.label.text,str];
    
    NSLog(@"免打扰%@",setDeviceURL1);
    
    [net GET:setDeviceURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"相应结果%@",responseObject);
        
        if ([responseObject[@"errcode"] integerValue]==0) {
            
            [self viewControllerHideHud];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];


}
#pragma mark___zeviewdelegate
- (void)selectedZESegmentedsViewItemAtIndex:(NSInteger )selectedItemIndex{
    
    switch (selectedItemIndex) {
        case 0:
            NSLog(@"点击了-->周日");
            
           _lklview.a=1;
            break;
        case 1:
            NSLog(@"点击了-->周一");
            
            _lklview.b=1;
            break;
        case 2:
            NSLog(@"点击了-->周二");
            
            _lklview.c=1;
            break;
        case 3:
            NSLog(@"点击了-->周三");
            
            _lklview.d=1;
            break;
        case 4:
            NSLog(@"点击了-->周四");
            
            _lklview.e=1;
            break;
        case 5:
            NSLog(@"点击了-->周五");
            
            _lklview.f=1;
            break;
        case 6:
            NSLog(@"点击了-->周六");
            
            _lklview.g=1;
            break;
        case 1000:
            NSLog(@"取消了-->周日");
            
            _lklview.a=0;
            break;
        case 1001:
            NSLog(@"取消了-->周一");
            
            _lklview.b=0;
            break;
        case 1002:
            NSLog(@"取消了-->周二");
            
            _lklview.c=0;
            break;
        case 1003:
            NSLog(@"取消了-->周三");
            
            _lklview.d=0;
            break;
        case 1004:
            NSLog(@"取消了-->周四");
            
            _lklview.e=0;
            break;
        case 1005:
            NSLog(@"取消了-->周五");
            
            _lklview.f=0;
            break;
        case 1006:
            NSLog(@"取消了-->周六");
            _lklview.g=0;
            break;
            
        default:
            break;
    }
    
}

#pragma mark -----cilickdelegate
-(void)cickbutton:(UIButton *)button
{
    if (button.tag==1) {
        [self setupDateView:DateTypeOfEnd];
    }
    else{
         [self setupDateView:DateTypeOfStart];
    }
}

- (void)setupDateView:(DateType)type {
  _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _bgView.backgroundColor=[UIColor colorWithWhite:0.2 alpha:0.5];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    
    
           _pickerView = [PickerView instancePickerView];
      _pickerView.frame = CGRectMake(0,ScreenHeight, ScreenWidth, ScreenHeight * 0.4);
    
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
            // TODO 日期确定选择
            self.beginDate=date;
            self.lklview.lklButton1.label.text=date;
            NSLog(@"时间%@",date);
            
            break;
            
        case DateTypeOfEnd:
            // TODO 日期取消选择
            self.endDate=date;
            self.lklview.lklButton2.label.text=date;
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
