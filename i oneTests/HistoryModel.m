//
//  historyModel.m
//  ione
//
//  Created by zlt on 16/8/1.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import "HistoryModel.h"
#import "TransformToMarsTool.h"
@implementation HistoryModel
+(instancetype)HistoryModelWithDict:(NSDictionary *)dict{
    HistoryModel * historyModel=[[self alloc]init];
    //NSLog(@"字典1%@",dict);
    double lat=[dict[@"lat"] doubleValue];
    double lng=[dict[@"lng"] doubleValue];
    CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake(lat, lng);
    
// CLLocationCoordinate2D zz=   [TransformToMarsTool transform:coordinate];
    historyModel.lat =coordinate.latitude ;
    historyModel.lng=coordinate.longitude;
//    historyModel.lat = dict[@"lat"];
//    historyModel.lng=dict[@"lng"];
    
    return historyModel;

}
@end
