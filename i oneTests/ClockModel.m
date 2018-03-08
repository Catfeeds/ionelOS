//
//  ClockModel.m
//  ione
//
//  Created by lkl on 2017/5/12.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "ClockModel.h"

@implementation ClockModel
+(instancetype)initWithDict:(NSDictionary *)dcit{
   ClockModel * model=[[self alloc]init];
    model.begin=dcit[@"begin"];
    model.index=dcit[@"index"];
    model.repeat=dcit[@"repeat"] ;
    model.about=dcit[@"about"];
    return model;
}
@end
