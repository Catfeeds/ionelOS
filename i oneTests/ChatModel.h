//
//  ChatModel.h
//  ione
//
//  Created by lkl on 2016/12/12.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModel : NSObject
@property(nonatomic,assign)NSInteger time;
@property(nonatomic,assign)NSInteger duration;//播放时长
@property(nonatomic,copy)NSString * url;
@property(nonatomic,assign)BOOL isSelf;
@property(nonatomic,copy)NSString * imei;
@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,assign)BOOL isTag;
@end
