//
//  ChatViewController.h
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/5.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatDAtabase.h"
@interface ChatViewController : UIViewController
@property(nonatomic,copy)NSString * url;
@property(nonatomic,copy)NSString * imei;
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong)ChatDAtabase * chatDatabase;
@property (nonatomic, strong) NSArray* messageArray;
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,copy)NSString * name;
@end
