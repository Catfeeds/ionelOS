//
//  WeilanViewController.h
//  ione
//
//  Created by lkl on 2017/3/30.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <MapKit/MapKit.h>
@interface WeilanViewController : BaseViewController
@property(nonatomic,strong)NSArray * namearr;
@property(nonatomic,strong)NSArray * imeiarr;
@property(nonatomic,assign)CLLocationDegrees lat;
@property(nonatomic,assign)CLLocationDegrees lng;
@end
