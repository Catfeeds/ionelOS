//
//  LineTableModel.h
//  ione
//
//  Created by lkl on 2017/1/17.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineTableModel : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,assign)double lat1;
@property(nonatomic,assign)double lat2;
@property(nonatomic,assign)double lng1;
@property(nonatomic,assign)double lng2;
@property(nonatomic,assign)double radius;
@property(nonatomic,copy)NSString * address;
@property(nonatomic,strong)NSArray * deviceArr;
+(instancetype)lineTableModelWithDict:(NSDictionary *)dict;

@end
