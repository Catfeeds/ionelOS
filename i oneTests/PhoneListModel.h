//
//  PhoneListModel.h
//  ione
//
//  Created by lkl on 2017/1/17.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneListModel : NSObject
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * number;
@property(nonatomic,copy)NSString * index;
+(instancetype)phoneListModelWithDict:(NSDictionary *)dict;
@end
