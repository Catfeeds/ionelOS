//
//  BaseNavigationViewController.m
//  项目三
//
//  Created by lx on 16/4/14.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor=[UIColor colorWithRed:152.0/ 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1];
   
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
