//
//  LKLNetToll.m
//  ione
//
//  Created by lkl on 2017/4/11.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "LKLNetToll.h"

@implementation LKLNetToll
+(instancetype)shareInstance {
    static LKLNetToll *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL * url=[NSURL URLWithString:@""];
        //设置配置信息
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        instance = [[LKLNetToll alloc]initWithBaseURL:url sessionConfiguration:configuration];
        
        
        //设置响应数据格式化
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"text/javascript",@"application/json",@"application/xml",@"text/plain",nil];
        
      
    });
    
    return instance;
}

@end
