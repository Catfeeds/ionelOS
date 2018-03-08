//
//  GyViewController.m
//  ione
//
//  Created by zlt on 16/9/8.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import "GyViewController.h"

@interface GyViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *label1;

@property (strong, nonatomic) IBOutlet UILabel *label2;
@end

@implementation GyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"关于我们";
    // Do any additional setup after loading the view from its nib.
    self.label1.text=Localized(@"app版本:2.0.2");
    self.label2.text= Localized(@"贵州贝思特智能科技有限公司版权所有");
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
