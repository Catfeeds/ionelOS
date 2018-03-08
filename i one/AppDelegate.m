
//
//  AppDelegate.m
//  i one
//
//  Created by zlt on 16/7/13.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD+MJ.h"
#import "AppDelegate.h"
#import "LoginModel.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#import "LaunchView.h"
#import "AFNetworking.h"

#import "MessageModel.h"
#import "ChatViewController.h"
#import <Bugly/Bugly.h>

#import "UMMobClick/MobClick.h"
#import "NewsViewController.h"
#import "MianViewController.h"
#import "BaseNavigationViewController.h"
#import "ChatModel.h"
#import "VoiceConverter.h"
#import "ConnectionViewController.h"
#import "BaseNavigationViewController.h"
#import "XiaoViewController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#import "LKLNetToll.h"
#import "LklLocationViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ClassCollectionViewCell.h"
#import "XiaoxiTableViewCell.h"
#import "XiaoViewController.h"

#import "MyFileManager.h"
#endif
@interface AppDelegate ()<JPUSHRegisterDelegate>
@property(nonatomic,strong)MessageModel * model;
@property(nonnull,strong)MessageModel * model1;
@property(nonatomic,strong)NSMutableArray * arr;
@property(nonatomic,assign)NSInteger index;

@property(nonatomic,strong)ChatModel * chatModel;
@property(nonatomic,strong)NSMutableArray * modelArr;
@end

@implementation AppDelegate
@synthesize isLogin, loginModel;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.imeiArr=[NSArray array];
   
    
    self.username=[userDefaults objectForKey:@"USERname"];
        
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    UMConfigInstance.appKey = @"58c6373b45297d0e2e000239";
    
    
    [MobClick startWithConfigure:UMConfigInstance];
    
    
    [Bugly startWithAppId:@"com.zlt.app.ione"];
    
   self.modelArr=[NSMutableArray array];
    _chatDatabase=[ChatDAtabase shareManager];
//    //确定当前系统语言状态
   [self getCurrentLanguage];
//    
//    //判断是否是第一次启动
//    if(![userDefaults boolForKey:@"firstStart"]){
//        [userDefaults setBool:YES forKey:@"firstStart"];
//        //设置本地语言
//        if ([self isChineseLanguage]) {
//            NSString *languageStr = @"zh-Hans";
//            [userDefaults setObject:languageStr forKey:AppLanguage];
//        }else{
//            NSString *languageStr = @"en";
//            [userDefaults setObject:languageStr forKey:AppLanguage];
//        }
//    }
//    if (![userDefaults objectForKey:@"appLanguage"]) {
//        NSArray *languages = [NSLocale preferredLanguages];
//        NSString *language = [languages objectAtIndex:0];
//        if ([language hasPrefix:@"zh-Hans"]) {//开头匹配
//            [userDefaults setObject:@"zh-Hans" forKey:@"appLanguage"];
//        }else{
//            [userDefaults setObject:@"en" forKey:@"appLanguage"];
//        }
//    }
    
     //启动图时长设置
    [NSThread sleepForTimeInterval:5.0];
    
    [_window makeKeyAndVisible];
    
   
   LoginViewController * loginVC=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
     BaseNavigationViewController * naviVC=[[BaseNavigationViewController alloc]initWithRootViewController:loginVC];
    
    if ([userDefaults objectForKey:@"userTokentoken"]) {
        
    }
    else{
        
    self.window.rootViewController=naviVC;
    }
     _dataBase=[DataBase shareManager];
    
      NSLog(@"lkllkl%@",_dataBase);
    NSLog(@"memememe%@",_chatDatabase);
    NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (remoteNotification) {
        [UIApplication sharedApplication].applicationIconBadgeNumber =  0;
        
//        _model=[[MessageModel alloc]init];
//        _model.alert=remoteNotification[@"aps"][@"alert"];
//        
//        _dataBase=[DataBase shareManager];
//        
//        [_dataBase addMessage:_model];
//        NSLog(@"lkllkl%@",_dataBase);
      //  [self goToMssageViewControllerWith:remoteNotification];
        
    }
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        
         
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    }
    
    //Required
 else   if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    //Required
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    
    NSString * advertisingID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingID];
    
    
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);

            //创建请求工具对象
            LKLNetToll *newWorkTool = [LKLNetToll shareInstance];
            
            //设置网络请求标识
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
           
            NSString * tokenURL=[userDefaults objectForKey:@"userTokentoken"];
            NSString * jpushURL=[NSString stringWithFormat:@"%@token=%@&jpushid=%@", RelJpushURL,tokenURL,registrationID];
            NSLog(@"%@",jpushURL);
            [newWorkTool GET:jpushURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
               
                NSLog(@"成功了%@",responseObject);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"失败%@",error);
            }];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
   
    
    
    
    return YES;
}

//#pragma mark --- 获取系统语言
- (NSString *)getCurrentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage hasPrefix:@"zh-Hans"]) {//开头匹配
        [userDefaults setObject:@"zh-Hans" forKey:@"appLanguage"];
    }else{
        [userDefaults setObject:@"en" forKey:@"appLanguage"];
    }

    return currentLanguage;
}
//#pragma mark --- 判断当前系统语言为中文
//- (BOOL)isChineseLanguage
//{
//    BOOL isChinese = NO;
//    if ([[self getCurrentLanguage] rangeOfString:@"zh-Hans"].length > 0) {
//        isChinese = YES;
//        NSLog(@"当前中文");
//    }
//    return isChinese;
//}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    NSLog(@"66666%@",deviceToken);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"11111111");

}

- (void)didReceiveVoiceEvent:(NSDictionary *)event
{
    
    ChatModel * chattModel=[[ChatModel alloc]init];
    chattModel.time=[event[@"time"] integerValue];
    chattModel.duration=[event[@"duration"] integerValue];
    chattModel.imei=event[@"imei"] ;
    
    NSString *amrFile = [MyFileManager newFileWithExtension:@"amr"];
    NSString *wavFile = [MyFileManager newFileWithExtension:@"wav"];
    NSURL *url = [NSURL URLWithString:event[@"url"]];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
    
    [MyFileManager writeFile:amrFile data:data];
    
    if ( [VoiceConverter ConvertAmrToWav:[MyFileManager pathForFile:amrFile]
                             wavSavePath:[MyFileManager pathForFile:wavFile]]) {
        chattModel.url=wavFile ;
    }
    
    
    chattModel.isSelf=0;
    
    [_chatDatabase addMessage:chattModel];
    
    [MyFileManager deleteFile:amrFile];
}

//没有问题了

 //ios7前台收到消息或者在后台收到通知点击通知栏走的方法，在前台没有通知栏的消息，在后台才会收到通知栏的消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if ([userDefaults objectForKey:@"userTokentoken"]) {

    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"消息%@",userInfo);
        
  
        
        //在前台和后台都要走的代码
        UITabBarController * mainVC=(UITabBarController *)self.window.rootViewController;
        
        BaseNavigationViewController * naviVC=mainVC.viewControllers[1];
        
        [naviVC.tabBarItem setBadgeValue:@""];
        // application.applicationIconBadgeNumber=0;
        

        
   //   应用在前台
    if (application.applicationState == UIApplicationStateActive ) {
        NSLog(@"acitve or background");
        
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:userInfo[@"imei"] message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往", nil];
        [alertView show];
        
//        UILocalNotification * local=[[UILocalNotification alloc]init];
//        local.alertTitle=@"消息";
//        local.userInfo=userInfo;
//   local.alertBody=@"hahaha";
//        [[UIApplication sharedApplication] presentLocalNotificationNow:local];
        
         AppDelegate * app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if ([userInfo[@"type"] integerValue]==5) {
           alertView.tag=0;
            [self didReceiveVoiceEvent:userInfo];
           
        }
        else{
        
            alertView.tag=1;
            
        }
        
        // 前台所有的消息都会走
         _index=  alertView.firstOtherButtonIndex;
        
        _model1=[MessageModel newsModelWithDict:userInfo];
        
        _arr1=[NSMutableArray array];
        
        [_arr1 addObject:_model1.msg_message];
        
        if ([userInfo[@"type"] integerValue] !=5) {
            
            
            [_dataBase addMessage:_model1];
        }
       
        
        NSString * tokenURL=[userDefaults objectForKey:@"userTokentoken"];
        NSString * events=@"";
        
        for (int i=0; i<_arr1.count; i++) {
            if (i==self.arr1.count-1) {
                events=[events stringByAppendingFormat :@"%@",_arr1[i]];
            }
            else{
                events=[events stringByAppendingFormat:@"%@,",_arr1[i]];
            }
        }
        
        NSString * deleteURL1=[NSString stringWithFormat:@"%@token=%@&events=%@",deleteURL,tokenURL,events];
        NSLog(@"删除消息%@",deleteURL1);
        //创建请求工具对象
        LKLNetToll *newWorkTool = [LKLNetToll shareInstance];
        
        //设置网络请求标识
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [newWorkTool GET:deleteURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"222%@",responseObject);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
   }
 // 前台为止
        
        
        
        
        
     //后台 不用获取数据了，程序回到前台，还会调用接口，获取所有的数据
    else {
        
        
        
        if ([userInfo[@"type"] integerValue]==5 ) {

            
            
            UITabBarController * mainVC1=(UITabBarController *)self.window.rootViewController;
            
            BaseNavigationViewController * naviVC=mainVC1.viewControllers[0];
            
            mainVC1.selectedViewController=naviVC;
           
            
            
            LklLocationViewController * lklocationVC=(LklLocationViewController *)naviVC.topViewController;
          
            
            
        
            ChatViewController * chatVC=[[ChatViewController alloc]init];
            
            chatVC.imei=userInfo[@"imei"];
            
            
            chatVC.hidesBottomBarWhenPushed=YES;
            [lklocationVC.navigationController pushViewController:chatVC animated:YES];
            
        }
        //在后台收到的除了语音的所有消息
        else{

            UITabBarController * mainVC=(UITabBarController *)self.window.rootViewController;
           
             BaseNavigationViewController * naviVC=mainVC.viewControllers[1];
            
            mainVC.selectedViewController=naviVC;
            
            if ([naviVC.visibleViewController isKindOfClass:[NewsViewController class]]) {
                return;//为了防止当前就是chat的页面，在push到消息页面，这样页面就有叠加了
            }
            XiaoViewController  * xiaoxiVC= (XiaoViewController *) naviVC.topViewController;
            
            
            NewsViewController * newsVC=[[NewsViewController alloc]init];
            
//            newsVC.alertArr=(NSMutableArray *)[_dataBase getAllAlert];
//            
//            [newsVC.tableView reloadData];在程序会到前台的时候，还会获取所有的数据，所以这里不用在获取数据了
            
            newsVC.hidesBottomBarWhenPushed=YES;
            [xiaoxiVC.navigationController pushViewController:newsVC animated:YES];
            
 
        }

        
    }
   
}

}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //非语音 dianjiqueding
    if (alertView.tag==1 && buttonIndex==_index) {
        

        UITabBarController * mainVC=(UITabBarController *)self.window.rootViewController;
        
        BaseNavigationViewController * naviVC=mainVC.viewControllers[1];
        
        mainVC.selectedViewController=naviVC;
        
        //如果不是语音点击多多次，会出现多个消息页面
        if ([naviVC.topViewController isKindOfClass:[NewsViewController class]]) {
            NewsViewController * newsVC=(NewsViewController *)naviVC.topViewController;
            
            newsVC.alertArr=(NSMutableArray *)[_dataBase getAllAlert];
            
            [newsVC.tableView reloadData];
            
            return;
        }
        
        XiaoViewController  * xiaoxiVC= (XiaoViewController *) naviVC.topViewController;
        
        NewsViewController * newsVC=[[NewsViewController alloc]init];
        
        newsVC.alertArr=(NSMutableArray *)[_dataBase getAllAlert];
        
        [newsVC.tableView reloadData];
        newsVC.hidesBottomBarWhenPushed=YES;
        [xiaoxiVC.navigationController pushViewController:newsVC animated:YES];
    }
    //点击取消按钮，为了有小红点  是语音
    else if (buttonIndex!=_index && alertView.tag==0){
         UITabBarController * mainVC=(UITabBarController *)self.window.rootViewController;
       
        BaseNavigationViewController * navicVC=  mainVC.viewControllers[0];
      
        if (![navicVC.visibleViewController isKindOfClass:[ChatViewController class]]) {
            

            LklLocationViewController *lklLocationVC=(LklLocationViewController *)navicVC.topViewController;
            //判断语音小红点
            if (_chatDatabase.newMessage==YES) {
                
                ClassCollectionViewCell * cell=(ClassCollectionViewCell *) lklLocationVC.collectionView.visibleCells[2];
                cell.redView.hidden=NO;
                
            }
        }
        
        
    }
    //点击取消，不是语音，为了小红点
    else if (buttonIndex!=_index && alertView.tag==1){
        UITabBarController * mainVC=(UITabBarController *)self.window.rootViewController;
         BaseNavigationViewController * navicVC=  mainVC.viewControllers[1];
        
        if (![navicVC.visibleViewController isKindOfClass:[NewsViewController class]]) {
            
   
            XiaoViewController *xiaoxiVC=(XiaoViewController *)navicVC.topViewController;
            //判断语音小红点
            if (_dataBase.newMessage==YES) {
                
                XiaoxiTableViewCell * cell=(XiaoxiTableViewCell *)[xiaoxiVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                
                cell.redview.hidden=NO;
                cell.redview.backgroundColor=[UIColor redColor];
                
            }
        }
        

    
    }
    //语音    dianji yuyin ,queding
    else if (alertView.tag==0 && buttonIndex==_index){
        
        UITabBarController * mainVC=(UITabBarController *)self.window.rootViewController;
        
   
        
        
        ChatViewController * chatVC=[[ChatViewController alloc]init];
        chatVC.imei=alertView.title;
        
        
        BaseNavigationViewController *vc = mainVC.selectedViewController;
        
//       出现当前不是聊天的页面，创建一个新的聊天页面，在获取所有数据。
        if (![vc.visibleViewController isKindOfClass:[ChatViewController class]]) {
            
            BaseNavigationViewController * navicVC=  mainVC.viewControllers[0];
            mainVC.selectedViewController=navicVC;
            LklLocationViewController *lklLocationVC=(LklLocationViewController *)navicVC.topViewController;
            //判断已经有语音小红点，再次点击前往语音的话，让小红点消失
            if (_chatDatabase.newMessage==YES) {
                ClassCollectionViewCell * cell=(ClassCollectionViewCell *) lklLocationVC.collectionView.visibleCells[2];
                cell.redView.hidden=YES;
            }
            chatVC.hidesBottomBarWhenPushed=YES;
            
            chatVC.messageArray=[_chatDatabase getAllAlert];
            
            
            chatVC.dataArr=[NSMutableArray array];
            for (ChatModel * model in chatVC.messageArray) {
                if ([model.imei isEqualToString: alertView.title]) {
                    [chatVC.dataArr addObject:model];
                }
                
            }
            [chatVC.tableView reloadData];

            [lklLocationVC.navigationController pushViewController:chatVC animated:YES];
        }

        else if([vc.visibleViewController isKindOfClass:[ChatViewController class]]){
            ChatViewController * chat=(ChatViewController *)vc.visibleViewController;
            
        chat.messageArray=[_chatDatabase getAllAlert];
            
            
            chat.dataArr=[NSMutableArray array];
            for (ChatModel * model in chat.messageArray) {
                if ([model.imei isEqualToString: alertView.title]) {
                    [chat.dataArr addObject:model];
                }

            }
            [chat.tableView reloadData];
        }
        
    }
    
    
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
   
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#pragma mark- JPUSHRegisterDelegate


// iOS 10 Support 程序在前台收到消息,不点通知栏，在通知栏就会有消息的存在

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    
   
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    
    sound=[UNNotificationSound defaultSound];
    
   sound  = [UNNotificationSound soundNamed:@""];
    
    
    if ([userDefaults objectForKey:@"userTokentoken"]) {
        
    
      AppDelegate * app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary * userInfo = notification.request.content.userInfo;
        NSLog(@"ios10前台接受的消息%@",userInfo);
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、
    
        

        
       
        
        
    ChatModel * chattModel=[[ChatModel alloc]init];
        
        if ([userInfo[@"type"] integerValue] ==5 ) {
            [self didReceiveVoiceEvent:userInfo];
 
    }
        
     NSString * ID=userInfo[@"_j_msgid"];
    if ([userInfo[@"type"] integerValue] !=5) {

        _dataBase=[DataBase shareManager];
        _model=[MessageModel newsModelWithDict:userInfo];

        
            [_dataBase addMessage:_model];
        
        UITabBarController * mainVC=(UITabBarController *)self.window.rootViewController;
        
        BaseNavigationViewController * naviVC=mainVC.viewControllers[1];
        
        [naviVC.tabBarItem setBadgeValue:@""];
    }

        //创建请求工具对象
        LKLNetToll *newWorkTool = [LKLNetToll shareInstance];
        
        //设置网络请求标识
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;;
    
        NSString * tokenURL=[userDefaults objectForKey:@"userTokentoken"];
        NSString * deleteURL1=[NSString stringWithFormat:@"%@token=%@&events=%@",deleteURL,tokenURL,ID];
        [newWorkTool GET:deleteURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"222%@",responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
        }];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            //好像是不能清除通知中心的所有的消息
//            NSArray* scheduledNotifications = [NSArray arrayWithArray:[UIApplication sharedApplication].scheduledLocalNotifications];
//            [UIApplication sharedApplication].scheduledLocalNotifications = scheduledNotifications;
            
            
            UITabBarController * mainVC=(UITabBarController *)self.window.rootViewController;
            
            BaseNavigationViewController * naviVC0=mainVC.viewControllers[0];
            //不可能回出现当前不是聊天的页面，因为会在通知栏会有消息的提示。
            if ([naviVC0.visibleViewController isKindOfClass:[ChatViewController class]]) {
                
                ChatViewController * chatVC=(ChatViewController *)naviVC0.visibleViewController;
                
                chatVC.messageArray=[_chatDatabase getAllAlert];
                
               
                if ([userInfo[@"type"] integerValue] ==5 ){
               
                                     
                    [chatVC.dataArr addObject: chattModel];
                
                }

                [chatVC.tableView reloadData];
            }

          
            
            DataBase * database=[DataBase shareManager];

   
           
            BaseNavigationViewController * naviVC1=mainVC.viewControllers[1];
            
            if ([naviVC1.visibleViewController isKindOfClass:[NewsViewController class]]) {
                NewsViewController * newsVC= (NewsViewController *) naviVC1.visibleViewController;
                
 
                newsVC.alertArr=(NSMutableArray *)[database getAllAlert];
                
                [newsVC.tableView reloadData];
            }
            //在前台
            
            if (![naviVC0.visibleViewController isKindOfClass:[ChatViewController class]]) {
                
                BaseNavigationViewController * navicVC=  mainVC.viewControllers[0];
               // mainVC.selectedViewController=navicVC;
                LklLocationViewController *lklLocationVC=(LklLocationViewController *)navicVC.topViewController;
              
                //判断已经有语音小红点，再次点击前往语音的话，让小红点消失
                if (_chatDatabase.newMessage==YES && [userInfo[@"type"] integerValue] ==5) {
                    ClassCollectionViewCell * cell=(ClassCollectionViewCell *) lklLocationVC.collectionView.visibleCells[2];
                    cell.redView.hidden=NO;
                }

            }
            if (![naviVC1.visibleViewController isKindOfClass:[NewsViewController class]]) {
                
           XiaoViewController   *xiaoxiVC=(XiaoViewController *)naviVC1.topViewController;
                
                //没有加载消息的页面，此时的表视图是空的，所以在消息页面创建的时候，要重新写在cellfor这个方法里面
                if (_dataBase.newMessage==YES && [userInfo[@"type"] integerValue] !=5) {
                    XiaoxiTableViewCell * cell=(XiaoxiTableViewCell *)[ xiaoxiVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    cell.redview.hidden=NO;
                    cell.redview.backgroundColor=[UIColor redColor];
                }
                
            }

        });
    
    //点击后，通知栏里面消息都消失
    UIApplication * application=[UIApplication sharedApplication];
    
   application.applicationIconBadgeNumber=0;
        
      //  [application cancelAllLocalNotifications];
        
        
        //清除通知中心的所有的消息
//        NSArray* scheduledNotifications = [NSArray arrayWithArray:application.scheduledLocalNotifications];
//        application.scheduledLocalNotifications = scheduledNotifications;

    }
}

// iOS 10 Support 点击通知栏消息走的方法

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    
    
    
    UIApplication * application=[UIApplication sharedApplication];
    
    application.applicationIconBadgeNumber=0;
    
      [application cancelAllLocalNotifications];
    
//    NSArray* scheduledNotifications = [NSArray arrayWithArray:application.scheduledLocalNotifications];
//    application.scheduledLocalNotifications = scheduledNotifications;
    
    NSLog(@"消息%@",userInfo);
  
    
    if ([userInfo[@"type"] integerValue]==5 ) {
 
        
        UITabBarController * mainVC=(UITabBarController *)self.window.rootViewController;
        BaseNavigationViewController * navicVC=  mainVC.viewControllers[0];
         mainVC.selectedViewController=navicVC;
        
        
        if ([navicVC.visibleViewController isKindOfClass:[ChatViewController class]]) {
            return;//为了防止当前就是chat的页面，在push到消息页面，这样页面就有叠加了
        }
         LklLocationViewController *lklLocationVC=(LklLocationViewController *)navicVC.topViewController;
        
//        ClassCollectionViewCell * cell=(ClassCollectionViewCell *) lklLocationVC.collectionView.visibleCells[2];
//        cell.redView.hidden=YES;
//       
//        _chatDatabase.newMessage=NO;
        
        ChatViewController * chatVC=[[ChatViewController alloc]init];

        chatVC.imei=userInfo[@"imei"];
        chatVC.hidesBottomBarWhenPushed=YES;
         [lklLocationVC.navigationController pushViewController:chatVC animated:YES];
        
  
        }

    
   
    else{
        
       
        UITabBarController * mainVC=(UITabBarController *)self.window.rootViewController;
        
        BaseNavigationViewController * naviVC=mainVC.viewControllers[1];
        
        mainVC.selectedViewController=naviVC;
        
        
        if ([naviVC.visibleViewController isKindOfClass:[NewsViewController class]]) {
            return;//为了防止当前就是消息的页面，在push到消息页面，这样页面就有叠加了
        }
        
        
        XiaoViewController  * xiaoxiVC= (XiaoViewController *) naviVC.topViewController;
        
        NewsViewController * newsVC=[[NewsViewController alloc]init];
        
       //回到后台还会重新添加数据，所以不用获取所有的数据了
        
        newsVC.hidesBottomBarWhenPushed=YES;
        [xiaoxiVC.navigationController pushViewController:newsVC animated:YES];
        
    }

    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
    
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
// [[UIApplication sharedApplication] setApplicationIconBadgeNumber:_arr.count];
    }

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  //  [application setApplicationIconBadgeNumber:_arr.count - 1];
    
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([userDefaults objectForKey:@"userTokentoken"]) {
        
     AppDelegate * app=(AppDelegate *)[[UIApplication sharedApplication] delegate];

   _arr1=[NSMutableArray array];
    ChatModel *     chattModel=[[ChatModel alloc]init];
        //创建请求工具对象
        LKLNetToll *newWorkTool1 = [LKLNetToll shareInstance];
        
        
        //设置网络请求标识
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
    NSString * tokenURL=[userDefaults objectForKey:@"userTokentoken"];
    NSString * newsURL1=[NSString stringWithFormat:@"%@token=%@",newsURL,tokenURL];
    NSLog(@"获取消息%@",newsURL1);
    [newWorkTool1 GET:newsURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"111%@",responseObject);

 
        for (NSDictionary * dict in responseObject[@"data"]) {
            //便利语音消息
            if ([dict[@"event_extra"][@"type"] integerValue] ==5 ) {
         
                chattModel.time=[dict[@"event_extra"][@"time"]integerValue];
                chattModel.duration=[dict[@"event_extra"][@"duration"] integerValue];
                chattModel.imei=dict[@"event_extra"][@"imei"] ;
  
                   NSString * time=[app getCurrentTimeLong];
                NSString * str=[NSString stringWithFormat:@"%@selfRecord.amr",time];
                
               NSString * playName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:str];
                
                
                NSString * playName1=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:time];
                
                  NSString *convertedPath = [app GetPathByFileName: playName1 ofType:@"wav"];
                
                NSString *path = dict[@"event_extra"][@"url"]; //下载文件地址
                if ([path isKindOfClass:[NSNull class]]) {
                    return ;
                }
                NSURL *url1 = [NSURL URLWithString:path];
                NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url1];
                NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
 
                [self save:data time :time];
                
                if ( [VoiceConverter ConvertAmrToWav: playName wavSavePath:convertedPath]) {
                         _chatModel.url=convertedPath;
                }
                chattModel.isSelf=0;
                chattModel.isTag=0;
                [_chatDatabase addMessage:chattModel];
  
            }
           
        }

        //遍历所有的除了语音消息
        for (NSDictionary * dict in responseObject[@"data"]) {
            NSString * ID=dict[@"msg_id"];
            [_arr1 addObject:ID];
            
            if ([dict[@"event_extra"][@"type"] integerValue] !=5 ){
                _model=[MessageModel messageModelWithDict:dict];

                [_dataBase addMessage:_model];
            
            }
          
            
  
        }
        //从网络删除所有的消息
         NSString * events=@"";
        
        for (int i=0; i<_arr1.count; i++) {
            if (i==self.arr1.count-1) {
                events=[events stringByAppendingFormat :@"%@",_arr1[i]];
            }
            else{
                events=[events stringByAppendingFormat:@"%@,",_arr1[i]];
            }
        }

        NSString * deleteURL1=[NSString stringWithFormat:@"%@token=%@",deleteURL,tokenURL];
        NSLog(@"删除消息%@",deleteURL1);
     NSString *   strUrl = [deleteURL1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *url = [NSURL URLWithString:strUrl];
        
        
        NSMutableURLRequest *requester = [[NSMutableURLRequest alloc] initWithURL:url];
        
       
        requester.HTTPMethod = @"POST";
        
       
            NSString *param = [NSString stringWithFormat:@"events=%@",events];
            requester.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
  
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        
        [NSURLConnection sendAsynchronousRequest:requester queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            
            NSLog(@"response : %@",response);
            
            if (connectionError || data == nil) {
     
            }else {

                NSLog(@"data : %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            }
    
            
        }];
     
  
        
        //刷新界面

         dispatch_async(dispatch_get_main_queue(), ^{
             

             MianViewController * mainVC=(MianViewController *)self.window.rootViewController;
             
             BaseNavigationViewController * naviVC0=mainVC.viewControllers[0];
             if ([naviVC0.visibleViewController isKindOfClass:[ChatViewController class]]) {
                 ChatViewController * chatVC=(ChatViewController *)naviVC0.visibleViewController;
                 
                 chatVC.messageArray=[_chatDatabase getAllAlert];

                 for (NSDictionary * dictqwer in responseObject[@"data"]) {
                     if ([dictqwer[@"event_extra"][@"type"] integerValue] ==5 ) {
                         
                         [chatVC.dataArr addObject:chattModel];
                          [chatVC.tableView reloadData];
                     }
                 }
             }
             
             else if (![naviVC0.visibleViewController isKindOfClass:[ChatViewController class]]){//判断首页语音的小红点
                 BaseNavigationViewController * navicVC=  mainVC.viewControllers[0];
               
                 LklLocationViewController *lklLocationVC=(LklLocationViewController *)navicVC.topViewController;
                 if (_chatDatabase.newMessage==YES) {
                     ClassCollectionViewCell * cell=(ClassCollectionViewCell *)               lklLocationVC.collectionView.visibleCells[2];
                     cell.redView.hidden=NO;
                 }
  
             
             }

             
             
             
             [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
             
             
             BaseNavigationViewController * naviVC1=mainVC.viewControllers[1];
             
             NewsViewController * newsVC= (NewsViewController *) naviVC1.topViewController;
             
             if (_dataBase.newMessage==YES ) {

                 newsVC.navigationController.tabBarItem.badgeValue=@"";
             }
           else if (_dataBase.newMessage==NO)
           {
                newsVC.navigationController.tabBarItem.badgeValue=nil;
           }
             
             
              DataBase * database=[DataBase shareManager];
             
             if ([naviVC1.visibleViewController isKindOfClass:[NewsViewController class]]) {
                 NewsViewController * newsVC=(NewsViewController *)naviVC1.topViewController;

                 newsVC.alertArr=(NSMutableArray *)[database getAllAlert];
                 
                 [newsVC.tableView reloadData];
             }
             
             else if (![naviVC1.visibleViewController isKindOfClass:[NewsViewController class]]){//判断非语音的小红点 点击语音的时候，消息界面需要有小红点，就会跳到不适消息的界面
                 
                 
                 XiaoViewController * xiaoxiVC=(XiaoViewController *)naviVC1.topViewController;
                 if (_dataBase.newMessage==YES) {
                     XiaoxiTableViewCell * cell=(XiaoxiTableViewCell *)[xiaoxiVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                     
                     cell.redview.hidden=NO;
                     cell.redview.backgroundColor=[UIColor redColor];
                 }
                 
                 
             }
          
         });
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
}
- (void)save:(NSData *)data time:(NSString *)time

{
    
    
    NSString * str=[NSString stringWithFormat:@"%@selfRecord.amr",time];
    NSString * playName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:str];

//    
    NSFileManager *fm = [NSFileManager defaultManager];
//    

    
     [fm createFileAtPath:playName contents:data attributes:nil];
}
#pragma mark - 生成文件路径
- (NSString*)GetPathByFileName:(NSString *)_fileName ofType:(NSString *)_type{
//    NSString* fileDirectory = [[_fileName stringByAppendingPathExtension:_type]
//                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* fileDirectory = [_fileName stringByAppendingPathExtension:_type];
    

    return fileDirectory;
}
- (NSString *)getCurrentTimeLong
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    //为字符型
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    return [timeString substringToIndex:13];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}


@end
