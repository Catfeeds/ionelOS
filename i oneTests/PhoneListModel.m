//
//  PhoneListModel.m
//  ione
//
//  Created by lkl on 2017/1/17.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "PhoneListModel.h"

@implementation PhoneListModel
+(instancetype)phoneListModelWithDict:(NSDictionary *)dict{
    PhoneListModel * phoneListModel=[[self alloc]init];
    phoneListModel.name=dict[@"name"];
    phoneListModel.number=dict[@"number"];
    phoneListModel.index=dict[@"index"];
    return phoneListModel;
}
@end
