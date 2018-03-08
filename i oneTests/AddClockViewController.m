//
//  AddClockViewController.m
//  ione
//
//  Created by lkl on 2017/5/12.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "AddClockViewController.h"
#import "AddClockView.h"
#import "LKLNetToll.h"
#import "UIViewController+hide.h"
@interface AddClockViewController ()<clickbuttondelegatee,UWDatePickerViewDelegate>
@property(nonatomic,strong)AddClockView * addclockview;
@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,strong)PickerView *pickerView;
@end

@implementation AddClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"添加闹钟";
    
    UIBarButtonItem * right=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(tapped)];
    
    self.navigationItem.rightBarButtonItem = right;
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.addclockview=[[AddClockView alloc]initMyViewWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight * 0.3)];
    self.addclockview.LklViewDelegate=self;
    [self.view addSubview:self.addclockview];
}
-(void)tapped{

    [SVProgressHUD showWithStatus:@"保存中" maskType:SVProgressHUDMaskTypeClear];
    
    LKLNetToll * net=[LKLNetToll shareInstance];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    
    NSString * strr=[NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld%ld",_addclockview.a,_addclockview.b,_addclockview.c,_addclockview.d,_addclockview.e,_addclockview.f,_addclockview.g];

    
    NSString *q=[NSString stringWithFormat:@"%@token=%@&imei=%@&about=%@&begin=%@&repeat=%@",addcolockURL,[userDefaults objectForKey:@"userTokentoken"],[userDefaults objectForKey:@"lastImei"],_addclockview.textField.text,_addclockview.lklButton1.label.text,strr];
    NSString * qwer=[q stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"添加闹钟%@",q);
    
    [net GET:qwer parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"添加闹钟结果%@",responseObject);
        if ([responseObject[@"errcode"] integerValue]==0) {
            [self viewControllerHideHud];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self viewControllerHideHud];
            [self fail];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    

}
-(void)cickbutton1:(UIButton *)button{
[self setupDateView:DateTypeOfStart];

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

    switch (type) {
        case DateTypeOfStart:
            // TODO 日期确定选择
            self.beginDate=date;
            self.addclockview.lklButton1.label.text=date;
            NSLog(@"时间%@",date);
            
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
