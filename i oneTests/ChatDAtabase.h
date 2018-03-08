//
//  ChatDAtabase.h
//  ione
//
//  Created by lkl on 2016/12/12.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "ChatModel.h"

@interface ChatDAtabase : NSObject

@property(nonatomic,strong)FMDatabase * db;
@property(nonatomic,assign)BOOL newMessage;
+(ChatDAtabase *)shareManager;
-(void)addMessage:(ChatModel *)model;
- (NSArray *)getAllAlert;
-(void)del:(ChatModel *)model with:(NSInteger)integer;
-(void)del:(ChatModel *)model;
-(void)deleteAll;
-(void)update:(ChatModel *)model;
@end
