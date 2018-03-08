//
//  MianViewController.m
//  i one
//
//  Created by zlt on 16/7/13.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import "MianViewController.h"

#import "NewsViewController.h"
#import "FoundViewController.h"

#import "LklLocationViewController.h"
#import "MeViewController.h"

#import "XiaoViewController.h"
@interface MianViewController()

@end
@implementation MianViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self loadTabBar];
   
    self.tabBar.barTintColor=[UIColor whiteColor];
}
-(void)loadTabBar{

    NSArray * viewControllers=self.viewControllers;
    for (UINavigationController * navigationVc in viewControllers) {

           if ([navigationVc.topViewController isKindOfClass:[LklLocationViewController class]]) {

                UIImage * homenormalImage = [[UIImage imageNamed:@"定位未选中"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                UIImage * homeselectImage = [[UIImage imageNamed:@"定位选中"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
                navigationVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:Localized(@"定位") image:homenormalImage selectedImage: homeselectImage];
                

               
        }            else if ([navigationVc.topViewController isKindOfClass:[XiaoViewController class]]){
            
 
            UIImage * homenormalImage = [[UIImage imageNamed:@"消息未选中"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
           UIImage * homeselectImage = [[UIImage imageNamed:@"消息选中"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            navigationVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:Localized(@"消息") image:homenormalImage selectedImage: homeselectImage];
        }
                        else if ([navigationVc.topViewController isKindOfClass:[FoundViewController class]]){
                          
                            
                            UIImage * homenormalImage = [[UIImage imageNamed:@"发现未选中"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                            UIImage * homeselectImage = [[UIImage imageNamed:@"发现选中"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                            navigationVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:Localized(@"发现") image:homenormalImage selectedImage: homeselectImage];
  
            }
                        else if ([navigationVc.topViewController isKindOfClass:[MeViewController class]]){
                            
    
                            
                            UIImage * homenormalImage = [[UIImage imageNamed:@"我未选中"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                            UIImage * homeselectImage = [[UIImage imageNamed:@"我选中"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                            
                            navigationVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:Localized(@"我的") image:homenormalImage selectedImage: homeselectImage];
                        }
    }

    self.tabBar.translucent = NO;//默认是透明的，设为不透明
    self.tabBar.tintColor = [UIColor colorWithRed:106.0/ 255.0 green:107.0 / 255.0 blue:107.0 / 255.0 alpha:1];
    
}
@end
