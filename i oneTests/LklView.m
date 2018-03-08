//
//  LklView.m
//  ione
//
//  Created by lkl on 2017/4/28.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "LklView.h"


@implementation LklView

-(instancetype)initMyViewWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        self.semtsView=[[ZESegmentedsView alloc]initWithFrame:CGRectMake(10,ScreenHeight * 0.1 +10, ScreenWidth-20 , ScreenHeight * 0.1 -15) segmentedCount:7 segmentedTitles:@[@"日",@"一",@"二",@"三",@"四",@"五",@"六"]];
        self.a=0;
        self.b=0;
        self.c=0;
        self.d=0;
        self.e=0;
        self.f=0;
        self.g=0;
        self.semtsView.delegate=self;
        
        [self addSubview:self.semtsView];

     
        
        _lklButton1=[[lklbutton alloc]initWithMyButtonframe:CGRectMake(10, 20, ScreenWidth/3, ScreenHeight * 0.1 -25)];
        _lklButton1.label.text=@"初始时间";
         _lklButton1.layer.borderWidth=0.5;
        _lklButton1.layer.cornerRadius=5.0;
        _lklButton1.layer.masksToBounds=YES;
            [_lklButton1 addTarget:self action:@selector(tapped1:) forControlEvents:UIControlEventTouchUpInside];
        _lklButton1.tag=0;
        [self addSubview: _lklButton1];
        
        _lklButton2=[[lklbutton alloc]initWithMyButtonframe:CGRectMake(ScreenWidth -10-ScreenWidth/3, 20, ScreenWidth/3, ScreenHeight * 0.1 -25)];
        _lklButton2.label.text=@"终止时间";
        _lklButton2.tag=1;
         _lklButton2.layer.borderWidth=0.5;
        _lklButton2.layer.cornerRadius=5.0;
        _lklButton2.layer.masksToBounds=YES;
         [_lklButton2 addTarget:self action:@selector(tapped1:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_lklButton2];
      
        UIView * line=[[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2-5, 20 +self.lklButton1.frame.size.height/2, 10, 1)];
        line.backgroundColor=[UIColor blackColor];
        [self addSubview:line];
       
    }
    return self;

}

-(void)tapped1:(UIButton *)button{
    
    if ([self.LklViewDelegate respondsToSelector:@selector(cickbutton1:)]) {
        [self.LklViewDelegate cickbutton1:button];
    }
    
    
}

- (void)selectedZESegmentedsViewItemAtIndex:(NSInteger )selectedItemIndex{

    switch (selectedItemIndex) {
        case 0:
            NSLog(@"点击了-->周一");
            // _showLB.text = @"点击了-->周一";
            self.a=1;
            break;
        case 1:
            NSLog(@"点击了-->周二");
            //  _showLB.text = @"点击了-->周二";
            self.b=1;
            break;
        case 2:
            NSLog(@"点击了-->周三");
            //  _showLB.text = @"点击了-->周三";
            self.c=1;
            break;
        case 3:
            NSLog(@"点击了-->周四");
            //_showLB.text = @"点击了-->周四";
            self.d=1;
            break;
        case 4:
            NSLog(@"点击了-->周五");
            // _showLB.text = @"点击了-->周五";
            self.e=1;
            break;
        case 5:
            NSLog(@"点击了-->周六");
            // _showLB.text = @"点击了-->周六";
            self.f=1;
            break;
        case 6:
            NSLog(@"点击了-->周日");
            //_showLB.text = @"点击了-->周日";
            self.g=1;
            break;
        case 1000:
            NSLog(@"取消了-->周一");
            //_showLB.text = @"点击了-->周一";
            self.a=0;
            break;
        case 1001:
            NSLog(@"取消了-->周二");
            //_showLB.text = @"取消了-->周二";
            self.b=0;
            break;
        case 1002:
            NSLog(@"取消了-->周三");
            //  _showLB.text = @"取消了-->周三";
            self.c=0;
            break;
        case 1003:
            NSLog(@"取消了-->周四");
            //   _showLB.text = @"取消了-->周四";
            self.d=0;
            break;
        case 1004:
            NSLog(@"取消了-->周五");
            // _showLB.text = @"取消了-->周五";
            self.e=0;
            break;
        case 1005:
            NSLog(@"取消了-->周六");
            // _showLB.text = @"取消了-->周六";
            self.f=0;
            break;
        case 1006:
            NSLog(@"取消了-->周日");
            // _showLB.text = @"取消了-->周日";
            self.g=0;
            break;
            
        default:
            break;
    }
    
}

@end
