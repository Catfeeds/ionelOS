//
//  TakePhoneViewController.m
//  ione
//
//  Created by lkl on 2017/3/30.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "TakePhoneViewController.h"

@interface TakePhoneViewController ()<UITextFieldDelegate>

@end

@implementation TakePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"打电话";
    self.phoneButton.layer.cornerRadius=10.0;
    self.phoneButton.layer.masksToBounds=YES;
    
    self.phonetext.text=[userDefaults objectForKey:@"USERname"];
   
}
- (IBAction)phoneButtontapped:(id)sender {
    
    NSString *allString = [NSString stringWithFormat:@"tel:%@",self.phonetext.text];
    
    NSString * allString1=[allString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString1]];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
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
