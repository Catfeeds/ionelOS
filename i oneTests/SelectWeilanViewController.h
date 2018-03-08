//
//  SelectWeilanViewController.h
//  ione
//
//  Created by lkl on 2017/4/21.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "VerViewController.h"
#import "LineTableModel.h"
#import <MapKit/MapKit.h>
@interface SelectWeilanViewController : VerViewController
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UITextField *nametext;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property(nonatomic,strong)LineTableModel * model;
@property (weak, nonatomic) IBOutlet UISlider *myslider;

@property (weak, nonatomic) IBOutlet UILabel *myLabel;


@property(nonatomic,strong)NSArray * namearr;
@property(nonatomic,strong)NSArray * imeiarr;
@end
