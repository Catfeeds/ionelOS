//
//  MessageModel.m
//  ione
//
//  Created by zlt on 16/9/29.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel
+(instancetype)messageModelWithDict:(NSDictionary *)dict{

    MessageModel * messageModel=[[self alloc]init];
    messageModel.alert=dict[@"event_extra"][@"alert"];
    messageModel.type1=[dict[@"event_extra"][@"type"] integerValue];
    
    
    messageModel.imei=dict[@"event_extra"][@"imei"];
    messageModel.fine=[dict[@"event_extra"][@"fine"] integerValue];
    messageModel.status=[dict[@"event_extra"][@"status"] integerValue];
    messageModel.power=[dict[@"event_extra"][@"power"] integerValue];
    
    messageModel.user=[dict[@"event_extra"][@"user"] integerValue];
    messageModel.time=[dict[@"event_extra"][@"time"]integerValue];
    messageModel.result=[dict[@"event_extra"][@"result"]integerValue];
    messageModel.voice=[dict[@"event_extra"][@"voice"] integerValue];
    messageModel.msg_message=dict[@"event_extra"];
    messageModel.device_name=dict[@"event_extra"][@"device_name"];
    messageModel.user_name=dict[@"event_extra"][@"user_name"];
    messageModel.isTag=0;
    return messageModel;
}
+(instancetype)newsModelWithDict:(NSDictionary *)dict{
  MessageModel * messageModel=[[self alloc]init];
    
    messageModel.alert=dict[@"aps"][@"alert"];
    messageModel.type1=[dict[@"type"] integerValue];
    
    
    messageModel.imei=dict[@"imei"];
    messageModel.fine=[dict[@"fine"] integerValue];
    messageModel.status=[dict[@"status"] integerValue];
    messageModel.power=[dict[@"power"] integerValue];
    
    messageModel.user=[dict[@"user"] integerValue];
    messageModel.time=[dict[@"time"]integerValue];
    
    messageModel.msg_message=dict[@"_j_msgid"] ;
    messageModel.voice=[dict[@"voice"] integerValue];
    messageModel.result=[dict[@"result"] integerValue];
    messageModel.isTag=0;
    messageModel.device_name=dict[@"device_name"];
    messageModel.user_name=dict[@"user_name"];
    return messageModel;
}
@end
