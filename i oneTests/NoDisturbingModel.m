//
//  NoDisturbingModel.m
//  ione
//
//  Created by lkl on 2017/1/17.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "NoDisturbingModel.h"

@implementation NoDisturbingModel
+(instancetype)noDisturbingModelWithDict:(NSDictionary *)dict{
    NoDisturbingModel * noDisturbingModel=[[self alloc]init];
    noDisturbingModel.begin=dict[@"begin"];
    noDisturbingModel.end=dict[@"end"];
    noDisturbingModel.repeat=dict[@"repeat"];
    noDisturbingModel.index=dict[@"index"];
    return noDisturbingModel;
}
@end
