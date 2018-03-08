//
//  WeiLanSettingViewController.h
//  ione
//
//  Created by lkl on 2017/4/17.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BaseViewController.h"
#import "LineTableModel.h"

@interface WeiLanSettingViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *nameText;

@property (weak, nonatomic) IBOutlet UILabel *addressLable;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property(nonatomic,strong)LineTableModel * model;

@property(nonatomic,strong)NSArray * namearr;
@property(nonatomic,strong)NSArray * imeiarr;
@property(nonatomic,assign)CLLocationDegrees lat;
@property(nonatomic,assign)CLLocationDegrees lng;
@end
