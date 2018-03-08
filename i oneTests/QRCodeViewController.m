//
//  QRCodeViewController.m
//  QRCode
//
//  Created by Darren on 16/6/13.
//  Copyright © 2016年 darren. All rights reserved.
//

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define IOS8 ([[UIDevice currentDevice].systemVersion intValue] >= 8 ? YES : NO)
#import "MBProgressHUD+Add.h"
#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "NameVCViewController.h"
#import "VerViewController.h"
@interface QRCodeViewController ()<UITabBarDelegate,AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
@property(nonatomic,copy)NSString * tokenStr;
/**边框*/
@property (nonatomic,weak) UIImageView *QRImageView;
/**扫描*/
@property (nonatomic,weak) UIImageView *scanImageView;
/**最底层的view*/
@property (nonatomic,weak) UIView *bottomView;

@property (nonatomic,strong) AVCaptureDevice *device;
@property (nonatomic,strong) AVCaptureDeviceInput *input;
@property (nonatomic,strong) AVCaptureMetadataOutput *output;
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *preview;

@property (strong, nonatomic) CIDetector *detector;

@property(nonatomic,strong)UIAlertView * alertView;
@property(nonatomic,copy)NSString * nameStr;
@property(nonatomic,strong)NameVCViewController * nameVC;
@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
//    _nameVC=[[NameVCViewController alloc]init];
    
    [self setupNav];
    
    [self setupContentView];
    
    [self setupBottomView];
    
    [self startScan];

    
}
#pragma mark - 开始扫描
- (void)startScan
{
    // 判断有没有相机
    //判断是否可以打开相机，模拟器此功能无法使用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    
    //如果没获得权限
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"亲,请先到系统“隐私”中打开相机权限哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    //获取摄像设备
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    //创建输出流
    self.output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理 在主线程里刷新
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //初始化链接对象
    self.session = [[AVCaptureSession alloc] init];
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    //设置扫码支持的编码格式
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,
                                        AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    //扫描框
    self.output.rectOfInterest =  CGRectMake ((ScreenH-self.bottomView.frame.size.height)*0.5/ScreenH,(ScreenW-self.bottomView.frame.size.width)*0.5/ScreenW,self.bottomView.frame.size.height/ScreenH,self.bottomView.frame.size.width/ScreenW);
    NSLog(@"%@",NSStringFromCGRect(self.output.rectOfInterest));
    //开始捕获
    [self.session startRunning];
}
//相机
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count == 0) {
        NSLog(@"%@", metadataObjects);
        return;
    }
    
    if (metadataObjects.count > 0) {
        
        [self.scanImageView.layer removeAllAnimations];
        
        //停止扫描
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
        //扫描得到的文本 可以拿到扫描后的文本做其他操作哦
        NSLog(@"%@", metadataObject.stringValue);
        if (metadataObject.stringValue.length==0) {
            [MBProgressHUD showSuccess:@"扫描失败" toView:self.view];
        }
        else{
        if ([self.toBoundDelegate respondsToSelector:@selector(fromImeiToAdddevice:)]) {
            
            [self.toBoundDelegate fromImeiToAdddevice:metadataObject.stringValue];
        }
        }
//        self.tokenStr=[userDefaults objectForKey:@"userToken"];
//        
//        
//        AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
//        manager1.requestSerializer = [AFHTTPRequestSerializer serializer];
//        manager1.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
//        
//        NSString * getinfoURL1=[NSString stringWithFormat:@"%@token=%@&imei=%@",getinfoURL,self.tokenStr,metadataObject.stringValue];
//        NSLog(@"设备信息%@",getinfoURL1);
//        
//        
//        [manager1 GET:getinfoURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//            NSLog(@"信息%@",responseObject);
//            NSString * errcodeStrt=[responseObject[@"errcode"] stringValue];
//            if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
//                NSDictionary *  dict=responseObject[@"data"];
//                
//                _nameStr=dict[@"name"];
//   
//            }
//            else if ([errcodeStrt isEqualToString:@"-2"]){
//            [self.navigationController popViewControllerAnimated:YES];
//            }
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            NSLog(@"错误%@",error);
//            
//          
//            
//        }];

        
//        NSString * bindURL1=[NSString stringWithFormat:@"%@token1=%@&token2=8c4e323f771e226e1a89c72ee6efedaf&imei=%@",bindURL,self.tokenStr,metadataObject.stringValue];
//        
//        NSLog(@"url=%@",bindURL1);
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
//        NSString * bindurl1  =[bindURL1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        [manager GET:bindurl1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//            
//            NSLog(@"bangding的响应结果%@",responseObject);
//            NSString * errcodeStr=[responseObject[@"errcode"] stringValue];
//
//            if ([errcodeStr isEqualToString:@"-9"]) {
//                
//                VerViewController * verVC=[[VerViewController alloc]initWithNibName:@"VerViewController" bundle:nil];
//                verVC.imei=metadataObject.stringValue;
//                [self.navigationController presentViewController:verVC animated:YES completion:nil];
//                
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//
//            else if ([responseObject[@"errmsg"] isEqualToString:@"success"]){
//                _nameVC=[[NameVCViewController alloc]init];
//
//                _nameVC.str=metadataObject.stringValue;
//                
//            [self.navigationController pushViewController:_nameVC animated:YES];
//                
//            }
//            else if ([errcodeStr isEqualToString:@"-6"]){
//            
//                [SVProgressHUD showErrorWithStatus:@"扫描失败"];
//            
//            }
//          
//          
//            
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            NSLog(@"error=%@",error);
//        }];
        

        [self.navigationController popViewControllerAnimated:YES];

    }
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//   
//        [self startQRAnimation];
//        [self.session startRunning];
//
//
//}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    [self startQRAnimation];
    [self.session startRunning];
}

#pragma mark - 设置导航栏
- (void)setupNav
{
     self.navigationItem.title = @"扫描二维码";

    //self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
   // [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]}];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftItem)];
    self.navigationItem.leftBarButtonItem = leftBtn;
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem)];
//    self.navigationItem.rightBarButtonItem = rightBtn;
    
  
}

- (void)clickLeftItem

{
    [self.navigationController popViewControllerAnimated:YES];
   // [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)clickRightItem
{
    
    self.detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) { //判断设备是否支持相册
        
        if (IOS8) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未开启访问相册权限，现在去开启" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 4;
            [alert show];
        }
        else{
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        return;
    }
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.mediaTypes = [UIImagePickerController         availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    mediaUI.allowsEditing = NO;
    mediaUI.delegate = self;
    [self presentViewController:mediaUI animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    
    
 UIImage *  image = [info objectForKey:UIImagePickerControllerOriginalImage];

    
    //取出选中的图片 502151010017596
    
    NSData *imageData = UIImagePNGRepresentation(image);
    CIImage *ciImage = [CIImage imageWithData:imageData];
    
    NSArray *features = [self.detector featuresInImage:ciImage];
    if (features.count >=1) {
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            _scannedResult = feature.messageString;

            self.tokenStr=[userDefaults objectForKey:@"userToken"];
            
            AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
            manager1.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager1.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

            NSString * getinfoURL1=[NSString stringWithFormat:@"%@token=%@&imei=%@",getinfoURL,self.tokenStr,_scannedResult];
            NSLog(@"设备信息%@",getinfoURL1);
            
            [manager1 GET:getinfoURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"信息响应%@",responseObject);
                if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
                    NSDictionary *  dict=responseObject[@"data"];
                    
                    _nameStr=dict[@"name"];
                    
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"错误%@",error);
            }];
            
            
            
            NSString * bindURL1=[NSString stringWithFormat:@"%@token1=%@&token2=8c4e323f771e226e1a89c72ee6efedaf&imei=%@",bindURL,self.tokenStr,_scannedResult];
            NSLog(@"url=%@",bindURL1);
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
          
            NSString * bindurl1  =[bindURL1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [manager GET:bindurl1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                
                NSLog(@"绑定的响应结果%@",responseObject);
                if ([responseObject[@"errmsg"] isEqualToString:@"device already bonded!"]) {
                    
//                   dispatch_async(dispatch_get_main_queue(), ^{
//                       _nameVC.textField.text=_nameStr;
//                   });
//                    
//                }
//              
//
//                
//
//              
//                _nameVC.str=_scannedResult;
//                
//                [self.navigationController pushViewController:_nameVC animated:YES];
//               
//                
//                [self.toBoundDelegate toBoundDelegate:self.scannedResult];
                    VerViewController * verVC=[[VerViewController alloc]initWithNibName:@"VerViewController" bundle:nil];
                    verVC.imei=_scannedResult;
                    [self.navigationController presentViewController:verVC animated:YES completion:nil];
                    
                    
                }
                
                else if ([responseObject[@"errmsg"] isEqualToString:@"success"]){
                    _nameVC=[[NameVCViewController alloc]init];
                    _nameVC.str=_scannedResult;
                    
                    [self.navigationController pushViewController:_nameVC animated:YES];
                    
                }

                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"error=%@",error);
            }];

        }];
        
    }
    else{
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该图片没有包含二维码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            
            //开始捕获
            [self.session startRunning];
        }];
    }
}




#pragma mark - 创建UI
- (void)setupContentView
{
    // 最底层的view
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake((ScreenW-200)*0.5, (ScreenH-200)*0.5, 200, 200)];
    bottomView.center = self.view.center;
    [self.view addSubview:bottomView];
    bottomView.layer.borderColor = [UIColor whiteColor].CGColor;
    bottomView.layer.borderWidth = 1;
    self.bottomView = bottomView;
    
    // 提示
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, ScreenW, 20)];
    lable.font = [UIFont systemFontOfSize:14];
    lable.text = @"将对应二维码放入扫描框内即可扫描";
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lable];
    
    // 边框
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:bottomView.bounds];
    imageView.image = [UIImage imageNamed:@"qrcode_border"];
    [bottomView addSubview:imageView];
    self.QRImageView = imageView;
    
    // 扫描效果
    UIImageView *scanView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bottomView.frame.size.width, 0)];
    scanView.image = [UIImage imageNamed:@"qrcode_scanline_qrcode"];
    [bottomView addSubview:scanView];
    self.scanImageView = scanView;
    
    [self startQRAnimation];
    
    // 灯泡
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenW-50)*0.5, ScreenH-180, 50, 50)];
    [btn setBackgroundImage:[UIImage imageNamed:@"l"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"l_s"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(clickLight:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)clickLight:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self turnTorchOn:YES];
    } else {
        [self turnTorchOn:NO];
    }
}

#pragma mark - 开关灯
- (void)turnTorchOn:(bool)on
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}
#pragma mark - 创建底部的空间
- (void)setupBottomView
{
    UITabBar *tabbar = [[UITabBar alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-49, [UIScreen mainScreen].bounds.size.width, 49)];
    tabbar.barTintColor = [UIColor blackColor];
    tabbar.delegate = self;
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"二维码" image:[UIImage imageNamed:@"qrcode_tabbar_icon_qrcode"] selectedImage:[UIImage imageNamed:@"qrcode_tabbar_icon_qrcode_highlighted"]];
//    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"条形码" image:[UIImage imageNamed:@"qrcode_tabbar_icon_barcode"] selectedImage:[UIImage imageNamed:@"qrcode_tabbar_icon_barcode_highlighted"]];
    tabbar.items = [NSArray arrayWithObjects:item1, nil];
    [tabbar setSelectedItem:item1];
    [self.view addSubview:tabbar];
}
#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([item.title isEqualToString:@"条形码"]) {
        //设置扫码支持的编码格式
        self.output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code];
        self.bottomView.frame = CGRectMake((ScreenW-200)*0.5, 0.5*(ScreenH-100),200, 100);
        
        [self startQRAnimation];
    } else if ([item.title isEqualToString:@"二维码"]) {
        //设置扫码支持的编码格式
        self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        self.bottomView.frame = CGRectMake(0, 0, 200, 200);
        self.bottomView.center=CGPointMake(ScreenW/2,(ScreenH-200)*0.5 );
        [self startQRAnimation];
    }
}

#pragma mark - 开始二维码动画
- (void)startQRAnimation
{
    [self.scanImageView.layer removeAllAnimations];

    self.QRImageView.frame = self.bottomView.bounds;
    self.bottomView.center = self.view.center;
    
    CGRect frame = self.scanImageView.frame;
    frame.size.height = 0;
    self.scanImageView.frame = frame;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        CGRect frame = self.scanImageView.frame;
        frame.size.height = self.bottomView.frame.size.height;
        self.scanImageView.frame = frame;
    } completion:nil];
}
#pragma  mark - 获取帐号信息

//-(void)requestData{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
//    self.tokenURL=[userDefaults objectForKey:@"userToken"];
//    NSString * getinfoURL1=[NSString stringWithFormat:@"%@token=%@&imei=%@",getinfoURL,self.tokenURL,];
//    NSLog(@"设备信息%@",getinfoURL1);
//    
//    [manager GET:getinfoURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"信息响应%@",responseObject);
//        if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
//            NSDictionary *  dict=responseObject[@"data"];
//            
//            _nameStr=dict[@"name"];
//            
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"错误%@",error);
//    }];
//    
//}

@end
