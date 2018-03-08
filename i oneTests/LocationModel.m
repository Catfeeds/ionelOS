//
//  LocationModel.m
//  ione
//
//  Created by lkl on 2017/1/17.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "LocationModel.h"

@implementation LocationModel
+(instancetype)locationModelWithDict:(NSDictionary *)dict{


    LocationModel * locationModel=[[self alloc]init];
    locationModel.lat=[dict[@"lat"] doubleValue];
    locationModel.lng=[dict[@"lng"] doubleValue];
    locationModel.time=[dict[@"time"] integerValue];
    locationModel.address=dict[@"address"];
    locationModel.online=[dict[@"online"] integerValue];
    locationModel.power=[dict[@"power"] integerValue];
    return locationModel;
}



@end
