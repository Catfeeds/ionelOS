//
//  myAticle.m
//  ione
//
//  Created by lkl on 2017/4/24.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "myAticle.h"

@implementation myAticle
+(instancetype)myArticleModelWithDict:(NSDictionary *)dict{
    myAticle * model=[[self alloc]init];
    model.content=dict[@"article_content"];
    model.time=dict[@"article_critime"];
    model.index=dict[@"article_id"];
    model.imageStr=dict[@"article_img_src"];
    model.title=dict[@"article_title"];
    return model;
}
@end
