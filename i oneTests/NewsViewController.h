//
//  NewsViewController.h
//  i one
//
//  Created by zlt on 16/7/20.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MessageModel.h"
#import "DataBase.h"
#import "FMDatabaseQueue.h"
@interface NewsViewController : BaseViewController
@property(nonatomic,copy)NSString * aps;
@property(nonatomic,strong)NSMutableArray * alertArr;
@property(nonatomic,strong)DataBase * dataBase;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)AppDelegate * appDelegate;
@end
