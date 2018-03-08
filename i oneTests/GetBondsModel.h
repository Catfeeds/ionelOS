//
//  GetBondsMOdel.h
//  ione
//
//  Created by lkl on 2017/1/17.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetBondsModel : NSObject
@property(nonatomic,copy)NSString * imei;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * phone;

+(instancetype)getBondsModelWithDict:(NSDictionary *)dict;
@end
