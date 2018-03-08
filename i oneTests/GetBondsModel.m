//
//  GetBondsMOdel.m
//  ione
//
//  Created by lkl on 2017/1/17.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "GetBondsModel.h"

@implementation GetBondsModel

+(instancetype)getBondsModelWithDict:(NSDictionary *)dict{

    GetBondsModel * getBondsModel=[[self alloc]init];
    getBondsModel.imei=dict[@"imei"];
    getBondsModel.name=dict[@"name"];
    getBondsModel.phone=dict[@"phone"];
    return getBondsModel;
}
@end
