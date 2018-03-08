//
//  GetUserManagerModel.m
//  ione
//
//  Created by lkl on 2017/5/4.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "GetUserManagerModel.h"

@implementation GetUserManagerModel
+(instancetype)initWithDict:(NSDictionary *)dict{
    GetUserManagerModel * model=[[self alloc]init];
    model.name=dict[@"name"];
    model.nick=dict[@"nick"];
    model.ID=[dict[@"id"] integerValue];
    return model;
}
@end
