//
//  DeviceChooseViewController.h
//  ione
//
//  Created by lkl on 2017/4/17.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol selectNameToDelegate <NSObject>
-(void)passSelectedArr:(NSMutableArray *)arr WithIndexArr:(NSMutableArray *)indexarr;
@end
@interface DeviceChooseViewController : UIViewController
@property(nonatomic,strong)NSMutableArray * selectedArr;//选择的数组
@property(nonatomic,strong)id<selectNameToDelegate>myDelegete;
@property(nonatomic,strong)NSArray * namearr;
@property(nonatomic,strong)NSArray * imeiarr;
@end
