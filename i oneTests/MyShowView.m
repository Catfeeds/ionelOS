//
//  MyShowView.m
//  ione
//
//  Created by lkl on 2017/4/10.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "MyShowView.h"

@implementation MyShowView

-(instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)str{

    if (self) {
        self=[super initWithFrame:frame];
        UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,frame.size.width/2, frame.size.height/2)];
        imageView.center=self.center;
        imageView.image=[UIImage imageNamed:@"ic_record_too_short"];
        [self addSubview:imageView];
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0,frame.size.height-30 ,frame.size.width , 30)];
        [self addSubview:label];
        label.text=str;
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor whiteColor];
        self.backgroundColor=[UIColor darkGrayColor];
        self.layer.cornerRadius=10.0;
        self.layer.masksToBounds=YES;
    }
    return self;
}

@end
