//
//  LineTableModel.m
//  ione
//
//  Created by lkl on 2017/1/17.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "LineTableModel.h"

@implementation LineTableModel
+(instancetype)lineTableModelWithDict:(NSDictionary *)dict{
    LineTableModel * lineTableModel=[[self alloc]init];
    lineTableModel.name=dict[@"name"];
    lineTableModel.lat1=[dict[@"lat1"] doubleValue];
    lineTableModel.lat2=[dict[@"lat2"] doubleValue];
    lineTableModel.lng1=[dict[@"lng1"] doubleValue];
    lineTableModel.lng2=[dict[@"lng2"] doubleValue];
    lineTableModel.radius=[dict[@"radius"] doubleValue];
    lineTableModel.ID=[dict[@"id"] integerValue];
    lineTableModel.address=dict[@"address"];
    lineTableModel.deviceArr=dict[@"devices"];
    return lineTableModel;
}
@end
