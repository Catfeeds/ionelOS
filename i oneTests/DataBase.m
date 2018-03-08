//
//  DataBase.m
//  ione
//
//  Created by zlt on 16/9/29.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import "DataBase.h"
static DataBase * manager=nil;
@implementation DataBase
-(instancetype)init{
    if (self==[super init]) {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/al.db"];
    
        _db = [[FMDatabase alloc] initWithPath:path];
        BOOL res = [_db open];
        if (!res) {
            NSLog(@"打开数据库失败");
            return self;
        }
        else{
       res=[_db executeUpdate:@"CREATE TABLE IF NOT EXISTS lklkid (id integer primary key autoincrement,type1 integer,imei text,fine integer,status integer,power integer,user integer,time integer,result integer,voice integer,msg_message text,isTag bit,device_name text,user_name text)"];
        if (!res) {
            NSLog(@"创建用户表失败");
            
            [_db close];
            return self;
        }
        else{
            NSLog(@"创表成功");
        
        }
    }
    }
    return self;

}
+(DataBase * )shareManager{
    static dispatch_once_t once;
    //这个Block里面的代码只会被执行一次
    dispatch_once(&once, ^{
        if (manager == nil) {
            manager = [[DataBase alloc] init];
        }
        
    });
    return manager;
    

}

-(void)addMessage:(MessageModel *)model{
 [_db open];
    //select Test from Table group by Test having count（test)>1
  // BOOL res1= [_db executeQuery:@"select msg_message from jpushtesttest group by  msg_message having count(msg_message) >1"];
    
        
    self.newMessage=YES;
    
 BOOL res=[_db executeUpdate:@"insert into lklkid (type1,imei,fine,status,power,user,time,result,voice,msg_message,isTag,device_name,user_name) values(?,?,?,?,?,?,?,?,?,?,?,?,?)",[NSNumber numberWithInteger: model.type1 ], model.imei,[NSNumber numberWithInteger: model.fine ],[NSNumber numberWithInteger: model.status ], [NSNumber numberWithInteger: model.power ],[NSNumber numberWithInteger: model.user ],[NSNumber numberWithInteger: model.time],[NSNumber numberWithInteger: model.result ],[NSNumber numberWithInteger:model.voice],model.msg_message,[NSNumber numberWithBool:model.isTag],model.device_name,model.user_name];
    if (!res) {
        NSLog(@"插入失败");
        return;
    }
  
    FMResultSet *set = [_db executeQuery:@"select *from lklkid order by id desc limit 1"];//拿到最近一条添加进去的数据
    [set next];//指向第一条数据
    model.iD=[set intForColumn:@"id"];
    
    
    
    [_db close]; 
}


- (NSArray *)getAllAlert{
    [_db open];
    NSMutableArray *arr = [NSMutableArray array];

   FMResultSet *set = [_db executeQuery:@"select *from lklkid order by time desc"];//降序
    
    while ([set next]) {
        MessageModel * model = [[MessageModel alloc] init];
        
        model.type1=[set intForColumn:@"type1"];
        
        model.imei=[set stringForColumn:@"imei"];
        model.fine=[set intForColumn:@"fine"];
        model.status=[set intForColumn:@"status"];
        model.power=[set intForColumn:@"power"];
        
        model.user=[set intForColumn:@"user"];
        model.time=[set intForColumn:@"time"];
        model.result=[set intForColumn:@"result"];
        model.voice=[set intForColumn:@"voice"];
       model.iD=[set intForColumn:@"id"];
        
        model.msg_message=[set stringForColumn:@"msg_message"];
        model.isTag=[set boolForColumn:@"isTag"];
        model.device_name=[set stringForColumn:@"device_name"];
        model.user_name=[set stringForColumn:@"user_name"];
        [arr addObject:model];
    }
     [_db close];
    return arr;

}

//-(void)deleteCopy{
//    [_db open];
//    
//    
////    BOOL res = [_db executeUpdate:@"delete from jpushtesttest where msg_message in (select msg_message from jpushtesttest group by msg_message having count( * ) >1) and id  not in (select min(id) from  jpushtesttest group by id having count(* )>1)"];
//    BOOL res=[_db executeUpdate:@"select distinct msg_message from jpushtesttest"];
//    if (res ==NO) {
//        NSLog(@"删除重复的数据失败");
//    }
//    else{
//        NSLog(@"删除重复的数据成功");
//    }
//    [_db close];
//}
-(void)update:(MessageModel *)model{
    BOOL res=[_db open];
    if (res == NO) {
        NSLog(@"打开失败");
        return;
    }
    
    
    //更改
    
    res = [_db executeUpdate:@"update lklkid set isTag =1 where id = ?", [NSNumber numberWithInteger: model.iD]];
    
    
    if (res == NO) {
        NSLog(@"修改失败");
    }
    else{
        NSLog(@"修改成功");
    }
    [_db close];

}
- (void)del:(MessageModel *)model{

    //打开数据库
    BOOL res = [_db open];

    if (res == NO) {
        NSLog(@"打开失败");
        return;
    }
    
    //删除
    
    res = [_db executeUpdate:@"delete from lklkid where id=?",[NSNumber numberWithInteger: model.iD] ];
    NSLog(@"删除的%ld",(long)model.iD);
    
    if (res == NO) {
        NSLog(@"删除失败");
    }
    else{
        NSLog(@"删除成功");
    }
    [_db close];
}
-(void)deleteAllData{
    //打开数据库
    BOOL res = [_db open];
    
    if (res == NO) {
        NSLog(@"打开失败");
        return;
    }
    res = [_db executeUpdate:@"delete from lklkid "];
    
    
    if (res == NO) {
        NSLog(@"删除失败");
    }
    else{
        NSLog(@"删除成功");
    }
    [_db close];
 
    
}

    
//    //删除
//    res = [_db executeUpdate:@"delete from jpush where type1=? and imei=? and fine=? and  status=? and power=? and  user=? and time = ? and result=? and voice=?",[NSNumber numberWithInteger: model.type1 ], model.imei,[NSNumber numberWithInteger: model.fine ],[NSNumber numberWithInteger: model.status ], [NSNumber numberWithInteger: model.power ],[NSNumber numberWithInteger: model.user ],[NSNumber numberWithInteger: model.time],[NSNumber numberWithInteger: model.result ],[NSNumber numberWithInteger:model.voice]];
//    
//    if (res == NO) {
//        NSLog(@"删除失败");
//    }
//    else{
//    NSLog(@"删除成功");
//    }
//    [_db close];
//}
@end
