//
//  MessageModel.h
//  ione
//
//  Created by zlt on 16/9/29.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property(nonatomic,copy)NSString * alert;
@property(nonatomic,assign)NSInteger type1;
@property(nonatomic,copy)NSString * imei;
@property(nonatomic,assign)NSInteger fine;
@property(nonatomic,assign)NSInteger status;
@property(nonatomic,assign)NSInteger power;
@property(nonatomic,assign)NSInteger user;
@property(nonatomic ,assign)NSInteger result;
@property(nonatomic,assign)NSInteger voice;
@property(nonatomic,assign)NSInteger time;

@property(nonatomic,copy)NSString *  msg_message;
@property(nonatomic,assign)BOOL isTag;

@property(nonatomic,assign)NSInteger iD;
@property(nonatomic,copy)NSString * device_name;
@property(nonatomic,copy)NSString * user_name;
+(instancetype)messageModelWithDict:(NSDictionary *)dict;
+(instancetype)newsModelWithDict:(NSDictionary *)dict;
@end
