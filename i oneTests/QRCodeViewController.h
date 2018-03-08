//
//  QRCodeViewController.h
//  QRCode
//
//  Created by Darren on 16/6/13.
//  Copyright © 2016年 darren. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol toBoundDelegate <NSObject>
-(void)toBoundDelegate:(NSString *)str;
-(void)fromImeiToAdddevice:(NSString *)str;
@end
@interface QRCodeViewController : UIViewController

@property(nonatomic,copy)NSString * scannedResult;
@property(nonatomic,strong)id <toBoundDelegate>toBoundDelegate;
@end
