//
//  lklbutton.m
//  ione
//
//  Created by lkl on 2017/4/24.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "lklbutton.h"

@implementation lklbutton

-(instancetype)initWithMyButtonframe:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        _label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width * 2 /3, frame.size.height)];
        _label.textAlignment=NSTextAlignmentCenter;
        _label.font=[UIFont systemFontOfSize:15.0];
        [self addSubview:_label];
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width -20, frame.size.height/2 -10, 20, 20)];
        
        image.image=[UIImage imageNamed:@"下翻"];
        [self addSubview:image];
        self.backgroundColor=[UIColor whiteColor];
        self.layer.borderWidth=1.0;
        self.layer.borderColor=[UIColor blackColor].CGColor;
       
    }

    return self;
}

@end
