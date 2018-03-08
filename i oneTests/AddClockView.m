//
//  AddClockView.m
//  ione
//
//  Created by lkl on 2017/5/12.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "AddClockView.h"

@implementation AddClockView

-(instancetype)initMyViewWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        self.semtsView=[[ZESegmentedsView alloc]initWithFrame:CGRectMake(10,ScreenHeight * 0.1 +15, ScreenWidth-20 , ScreenHeight * 0.1 -15) segmentedCount:7 segmentedTitles:@[@"日",@"一",@"二",@"三",@"四",@"五",@"六"]];
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
        _lklButton1.label.text=@"闹钟时间";
        _lklButton1.layer.borderWidth=0.5;
        _lklButton1.layer.cornerRadius=5.0;
        _lklButton1.layer.masksToBounds=YES;
        [_lklButton1 addTarget:self action:@selector(tapped1:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview: _lklButton1];
        
        self.textField=[[UITextField alloc]initWithFrame:CGRectMake(10,ScreenHeight * 0.1 +15 + ScreenHeight * 0.1 -15 + 20, ScreenWidth-20, 35)];
        self.textField.layer.cornerRadius=5.0;
        self.textField.layer.borderColor=[[UIColor blackColor] CGColor];
        self.textField.layer.borderWidth=0.5;
        self.textField.placeholder=@"显示在手表屏幕上的文字";
        self.textField.delegate=self;
        self.textField.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.textField];
    }
    return self;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
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
            
            self.a=1;
            break;
        case 1:
            NSLog(@"点击了-->周二");
            
            self.b=1;
            break;
        case 2:
            NSLog(@"点击了-->周三");
            
            self.c=1;
            break;
        case 3:
            NSLog(@"点击了-->周四");
            
            self.d=1;
            break;
        case 4:
            NSLog(@"点击了-->周五");
            
            self.e=1;
            break;
        case 5:
            NSLog(@"点击了-->周六");
            
            self.f=1;
            break;
        case 6:
            NSLog(@"点击了-->周日");
            
            self.g=1;
            break;
        case 1000:
            NSLog(@"取消了-->周一");
            
            self.a=0;
            break;
        case 1001:
            NSLog(@"取消了-->周二");
            
            self.b=0;
            break;
        case 1002:
            NSLog(@"取消了-->周三");
            
            self.c=0;
            break;
        case 1003:
            NSLog(@"取消了-->周四");
            
            self.d=0;
            break;
        case 1004:
            NSLog(@"取消了-->周五");
            
            self.e=0;
            break;
        case 1005:
            NSLog(@"取消了-->周六");
            
            self.f=0;
            break;
        case 1006:
            NSLog(@"取消了-->周日");
            
            self.g=0;
            break;
            
        default:
            break;
    }
    
}


@end
