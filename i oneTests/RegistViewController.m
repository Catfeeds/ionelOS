

#import "RegistViewController.h"
#import "LoginViewController.h"
#import "LoginModel.h"
#import "RegistModel.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"
#import "RegistModel.h"
#import "CJMD5.h"
#import "MBProgressHUD+Add.h"
#import "LKLNetToll.h"
@interface RegistViewController ()<UITextFieldDelegate>
   


@property (strong, nonatomic) IBOutlet UITextField *telTextField;
@property (strong, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *qrpwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *vcodeBtn;
@property (strong, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UITextField *vcodeTextField;
@property(nonatomic,copy)NSString * tokenStr;

//@property(nonatomic,weak)id<RegisteViewControllerDelegate>delegate;

@end
@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.telTextField.delegate=self;
    self.pwdTextField.delegate=self;
    self.qrpwdTextField.delegate=self;
    self.vcodeTextField.delegate=self;
    self.title=@"注册";
    
}
-(void)viewWillLayoutSubviews{

    //self.vcodeBtn.layer.cornerRadius=10.0;
    
}
- (IBAction)registBtnAction:(id)sender {
    if (self.telTextField.text.length != 11) {
        [MBProgressHUD showSuccess:@"请正确填写手机号" toView:self.view];
        return;
    }
    if (_pwdTextField.text.length == 0) {
        [MBProgressHUD showSuccess:@"请填写密码" toView:self.view];
        return;
    }
    if (_qrpwdTextField.text.length == 0) {
        [MBProgressHUD showSuccess:@"请填写确认密码" toView:self.view];
        return;
    }
    if (![_pwdTextField.text isEqualToString:_qrpwdTextField.text]) {
         [MBProgressHUD showSuccess:@"两次输入的密码不一样" toView:self.view];
        return;
    }
    if (_vcodeTextField.text.length == 0) {
        [MBProgressHUD showSuccess:@"请填写验证码" toView:self.view];
        return;
    }
    [self userregisterv2Request];
   
   }

//发送验证码
- (IBAction)vcodeBtnAvtion:(id)sender {
    
    if (self.telTextField.text.length==11) {
        [MBProgressHUD showSuccess:@"验证码发送中" toView:self.view];
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.vcodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.vcodeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                self.vcodeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.vcodeBtn setTitle:[NSString stringWithFormat:@"%.2ds", seconds] forState:UIControlStateNormal];
                [self.vcodeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                self.vcodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
        
   [self sendvcodeRequest];
    }
    if ([self.telTextField.text length] != 11) {
        [MBProgressHUD showSuccess:@"请正确填写手机号码" toView:self.view];
        return;
    }
    
   
    
}
-(void)openCountdown{
    }
- (void)sendvcodeRequest{
    //创建请求工具对象
    LKLNetToll *newWorkTool = [LKLNetToll shareInstance];
    
    //设置网络请求标识
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    NSString * tokenURL=@"8c4e323f771e226e1a89c72ee6efedaf";
    NSString * getVerrifyURl=[NSString stringWithFormat:@"%@&phone=%@&token=%@",getVerifyCodeURL,self.telTextField.text,tokenURL];
    [newWorkTool GET:getVerrifyURl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"发送验证码%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)userregisterv2Request {
    NSString * userTelURL=self.telTextField.text;
    NSString * userPwdURL=[CJMD5 md5HexDigest:self.pwdTextField.text];
    NSString * tokenURL=@"8c4e323f771e226e1a89c72ee6efedaf";
    NSString * codeURL=@"123";
  NSString * registeURL1=[NSString stringWithFormat:@"%@username=%@&password=%@&token=%@&code=%@",registeURL,userTelURL,userPwdURL,tokenURL,codeURL];
   //切糕的帐号
    NSLog(@"%@",registeURL1);//http://192.168.1.200/zlt/api/register.php?username=18971485213&password=83962637f55b05e7c98c37644db945fc&token=ba276d18d43bc0c9471a98ef1bf174ed&code=123
  
    //创建请求工具对象
    LKLNetToll *newWorkTool = [LKLNetToll shareInstance];
    
    //设置网络请求标识
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [newWorkTool GET:registeURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            self.tokenStr=responseObject[@"data"][@"token"];
            NSLog(@"令牌是%@",self.tokenStr);
            [userDefaults setObject:self.tokenStr forKey:@"userToken"];


            [self.navigationController popViewControllerAnimated:YES];
        }else if ([responseObject[@"errcode"] integerValue]==-5){
        
         [SVProgressHUD showErrorWithStatus:@"该账户已经注册"];
        }
        
        else{
        
         [SVProgressHUD showErrorWithStatus:@"注册失败"];

        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"注册失败"];
       
    }];
       }
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end

