//
//  myAticle.h
//  ione
//
//  Created by lkl on 2017/4/24.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myAticle : NSObject
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * time;
@property(nonatomic,copy)NSString * index;
@property(nonatomic,copy)NSString * imageStr;
@property(nonatomic,copy)NSString *title;
+(instancetype)myArticleModelWithDict:(NSDictionary *)dict;
@end
