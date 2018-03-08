//
//  GetUserManagerModel.h
//  ione
//
//  Created by lkl on 2017/5/4.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetUserManagerModel : NSObject
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * nick;
@property(nonatomic,assign)NSInteger ID;
+(instancetype)initWithDict:(NSDictionary *)dict;
@end
