//
//  NoDisturbingModel.h
//  ione
//
//  Created by lkl on 2017/1/17.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoDisturbingModel : NSObject
@property(nonatomic,copy)NSString * begin;
@property(nonatomic,copy)NSString * end;
@property(nonatomic,copy)NSString * repeat;
@property(nonatomic,copy)NSString * index;
+(instancetype)noDisturbingModelWithDict:(NSDictionary *)dict;
@end
