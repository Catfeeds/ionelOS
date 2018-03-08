//
//  LklDisturbViewController.m
//  ione
//
//  Created by lkl on 2017/5/2.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "LklDisturbViewController.h"
#import "LklView.h"
#import "LKLNetToll.h"
#import "UIViewController+hide.h"
#import "DateConvertToll.h"
@interface LklDisturbViewController ()<clickbuttondelegatee,UWDatePickerViewDelegate>
@property(nonatomic,strong)LklView * lklview;
@property(nonatomic,strong)PickerView *pickerView;
@property(nonatomic,strong)UIView * bgView;
@end

@implementation LklDisturbViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
self.title=@"添加免打扰";
    self.view.backgroundColor=[UIColor whiteColor];
   _lklview=[[LklView alloc]initMyViewWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight * 0.2)];
    _lklview.LklViewDelegate=self;
    [self.view addSubview:_lklview];
    
    UIBarButtonItem * right=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(tapped)];
    
    self.navigationItem.rightBarButtonItem = right;
}
-(void)tapped{
        
    [SVProgressHUD showWithStatus:@"保存中" maskType:SVProgressHUDMaskTypeClear];
    
    LKLNetToll * net=[LKLNetToll shareInstance];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    
    NSString * strr=[NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld%ld",_lklview.a,_lklview.b,_lklview.c,_lklview.d,_lklview.e,_lklview.f,_lklview.g];
    NSString * setDeviceURL1=[NSString stringWithFormat:@"%@&token=%@&imei=%@&indexe=&begin=%@&end=%@&repeat=%@",addDeviceURL,[userDefaults objectForKey:@"userTokentoken"],[userDefaults objectForKey:@"lastImei"], _lklview.lklButton1.label.text, _lklview.lklButton2.label.text,strr];
    
    NSString * qwer=[setDeviceURL1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"免打扰%@",setDeviceURL1);
    
    [net GET:qwer parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"相应结果%@",responseObject);
        if ([responseObject[@"errcode"] integerValue]==0) {
            [self viewControllerHideHud];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if([responseObject[@"errcode"] integerValue]==-99){
            [self viewControllerHideHud];
            [self hideMbprogressrequestfour];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}

-(void)cickbutton1:(UIButton *)button
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
