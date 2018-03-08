//
//  DataBase.h
//  ione
//
//  Created by zlt on 16/9/29.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "MessageModel.h"
@interface DataBase : NSObject
@property(nonatomic,strong)FMDatabase * db;

@property(nonatomic,assign)BOOL newMessage;
+(DataBase *)shareManager;
-(void)addMessage:(MessageModel *)model;
- (NSArray *)getAllAlert;
-(void)del:(MessageModel *)model;
-(void)deleteCopy;
-(void)update:(MessageModel *)model;
-(void)deleteAllData;
@end
