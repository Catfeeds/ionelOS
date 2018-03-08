//
//  SheZhiViewController.m
//  ione
//
//  Created by lkl on 2017/4/11.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "SheZhiViewController.h"
#import "LoginViewController.h"
#import "BaseNavigationViewController.h"
#import "GyViewController.h"
#import "SheZhiTableViewCell.h"
#import "DataBase.h"
#import "ChatDAtabase.h"
#import <AudioToolbox/AudioToolbox.h>
@interface SheZhiViewController ()<UITableViewDelegate,UITableViewDataSource,switchTappedDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SheZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title=@"设置";
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
   [self.tableView    setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}

- (IBAction)logOut:(id)sender {
    [userDefaults removeObjectForKey:@"userTokentoken"];
    [userDefaults removeObjectForKey:@"USERname"];
    [userDefaults removeObjectForKey:@"lastImei"];
    [userDefaults removeObjectForKey:@"indexCellCell"];
    [userDefaults removeObjectForKey:@"imeiArr"];
    [userDefaults removeObjectForKey:@"firstStart"];
    [userDefaults removeObjectForKey:@"isoff"];
    [userDefaults removeObjectForKey:@"nick"];
    [userDefaults removeObjectForKey:@"first"];
    LoginViewController * loginVC=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    BaseNavigationViewController * naviVC=[[BaseNavigationViewController alloc]initWithRootViewController:loginVC];
    
   
    UIWindow * window= [[UIApplication sharedApplication] keyWindow];
        window.rootViewController=naviVC;
 
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }
    else{
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0 && indexPath.row==1) {

    SheZhiTableViewCell * mycell=[tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (mycell==nil) {
        mycell=[[[NSBundle mainBundle]loadNibNamed:@"SheZhiTableViewCell" owner:self options:nil] lastObject];
        mycell.swtichdelegate=self;
        if (![userDefaults boolForKey:@"first"]) {
              [userDefaults setBool:YES forKey:@"first"];
        }
      
        else{
        BOOL m=[userDefaults boolForKey:@"isoff"];
        if(m==NO){
          mycell.mySwitch.on=NO;
        }
        }
    }
   
        mycell.label.text=@"消息提示音";
        return mycell;
    }
    
    
    
    
    else{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        if (indexPath.section==1) {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        
    }
    
    if (indexPath.section==1) {
        cell.textLabel.text=@"关于点优";
    }
    else if (indexPath.section==0 &&indexPath.row==0){
    cell.textLabel.text=@"清除历史消息";
    }
      return cell;
    }
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section==0) {
        return 0;
    }
    return 20;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==1 && indexPath.row==0) {
        GyViewController * vc=[[GyViewController alloc]initWithNibName:@"GyViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section==0 && indexPath.row==0){
        
        UIAlertController * VC=[UIAlertController alertControllerWithTitle:nil message:@"是否删除历史信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            DataBase * dataBase=[DataBase shareManager];
            [dataBase deleteAllData];
            ChatDAtabase * chat=[ChatDAtabase shareManager];
            [chat deleteAll];
            
            
                   }];
        UIAlertAction * action2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         
        }];
        [VC addAction:action1];
        [VC addAction:action2];
        [self presentViewController:VC animated:YES completion:nil];

      
    
    }
}
-(void)switchTapped:(id)sender{
    UISwitch * switchh=sender;
    BOOL a=switchh.on;
    [userDefaults setBool:a forKey:@"isoff"];
    if (switchh.on) {
        
       
        //AudioServicesPlaySystemSound(1007);
    }else{
        
         AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
  
}
@end
