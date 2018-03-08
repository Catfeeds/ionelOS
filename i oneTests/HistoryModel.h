//
//  historyModel.h
//  ione
//
//  Created by zlt on 16/8/1.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryModel : NSObject
//           {
//address = "\U5e7f\U4e1c\U7701\U6df1\U5733\U5e02\U9f99\U5c97\U533aS28(\U6c34\U5b98\U9ad8\U901f)";
//bearing = 63;
//lat = "22.66436004638672";
//lng = "114.19884490966797";
//speed = 60;
//time = 1467777601;
//
//@property(nonatomic,strong)NSString * lat;
//@property(nonatomic,strong)NSString * lng;

@property(nonatomic,assign)double lat;
@property(nonatomic,assign)double lng;
+(instancetype)HistoryModelWithDict:(NSDictionary *)dict;
@end
