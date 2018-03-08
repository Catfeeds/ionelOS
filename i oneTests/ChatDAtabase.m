//
//  ChatDAtabase.m
//  ione
//
//  Created by lkl on 2016/12/12.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import "ChatDAtabase.h"

static ChatDAtabase * manager=nil;
@implementation ChatDAtabase
-(instancetype)init{
    if (self==[super init]) {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/a.db"];
        
        _db = [[FMDatabase alloc] initWithPath:path];
        BOOL res = [_db open];
        if (!res) {
            NSLog(@"打开数据库失败1");
            return self;
        }
        else{
            res=[_db executeUpdate:@"CREATE TABLE IF NOT EXISTS memememe (id integer primary key autoincrement,time integer,duration integer,url text,isSelf bit,imei text,isTag bit)"];
            if (!res) {
                NSLog(@"创建用户表失败1");
                [_db close];
                return self;
            }
            else{
                NSLog(@"创表成功1");
                
            }
        }
    }
    return self;
    
}
+(ChatDAtabase * )shareManager{
    static dispatch_once_t once;
    //这个Block里面的代码只会被执行一次
    dispatch_once(&once, ^{
        if (manager == nil) {
            manager = [[ChatDAtabase alloc] init];
        }
        
    });
    return manager;
    
    
}
-(void)addMessage:(ChatModel *)model{
    [_db open];
    
    self.newMessage=YES;
    
    BOOL res=[_db executeUpdate:@"insert into memememe (time,duration,url,isSelf,imei,isTag) values(?,?,?,?,?,?)",[NSNumber numberWithInteger: model.time ],[NSNumber numberWithInteger: model.duration ],model.url,[NSNumber numberWithBool:model.isSelf],model.imei,[NSNumber numberWithBool:model.isTag]];
    if (!res) {
        NSLog(@"插入失败");
        return;
    }
     FMResultSet *set = [_db executeQuery:@"select *from memememe  order by id desc limit 1"];//拿到最近一条添加进去的数据
    [set next];//指向第一条数据
     model.ID=[set intForColumn:@"id"];
    
    [_db close];
    
}


- (NSArray *)getAllAlert{
    //打开数据库
   [_db open];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    FMResultSet *set = [_db executeQuery:@"select *from memememe"];
    
    while ([set next]) {
        ChatModel * model = [[ChatModel alloc] init];
        
        model.time=[set intForColumn:@"time"];
        model.duration=[set intForColumn:@"duration"];
        model.url=[set  stringForColumn:@"url"];
        model.isSelf=[set boolForColumn:@"isSelf"];
        model.imei=[set stringForColumn:@"imei"];
        model.ID=[set intForColumn:@"id"];
        model.isTag=[set boolForColumn:@"isTag"];
        NSLog(@"ID%ld",(long)model.ID);
        [arr addObject:model];
    }
    
      [_db close];
    return arr;
  
}


- (void)del:(ChatModel *)model{
    
    //打开数据库
    BOOL res = [_db open];
    
    if (res == NO) {
        NSLog(@"打开失败");
        return;
    }
    
    //删除
    
    res = [_db executeUpdate:@"delete from memememe where id=?",[NSNumber numberWithInteger: model.ID] ];
    NSLog(@"删除的%ld",(long)model.ID);
    if (res == NO) {
        NSLog(@"删除失败");
    }
    else{
        NSLog(@"删除成功");
    }
    [_db close];
}

-(void)deleteAll{
    //打开数据库
    BOOL res = [_db open];
    
    if (res == NO) {
        NSLog(@"打开失败");
        return;
    }
    
    //删除
    
    res = [_db executeUpdate:@"delete from memememe"];
   
    if (res == NO) {
        NSLog(@"删除失败");
    }
    else{
        NSLog(@"删除成功");
    }
    [_db close];

}
-(void)update:(ChatModel *)model{
    BOOL res=[_db open];
    if (res == NO) {
        NSLog(@"打开失败");
        return;
    }
    
    
    //更改
    
    res = [_db executeUpdate:@"update memememe set isTag =1 where id = ?", [NSNumber numberWithInteger: model.ID]];
    
    
    if (res == NO) {
        NSLog(@"修改失败");
    }
    else{
        NSLog(@"修改成功");
    }
    [_db close];
    
}

@end
