//
//  ClockModel.h
//  ione
//
//  Created by lkl on 2017/5/12.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClockModel : NSObject
@property(nonatomic,copy)NSString * begin;
@property(nonatomic,copy)NSString * index;
@property(nonatomic,copy)NSString * repeat;
@property(nonatomic,copy)NSString * about;
+(instancetype)initWithDict:(NSDictionary *)dcit;
@end
