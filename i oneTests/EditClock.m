//
//  EditClock.m
//  ione
//
//  Created by lkl on 2017/5/12.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "EditClock.h"

@implementation EditClock

-(instancetype)initwitheditframe:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.semtsView=[[ZESegmentedsView alloc]initWithFrame:CGRectMake(0,ScreenHeight * 0.1 +15, ScreenWidth-20 , ScreenHeight * 0.1 -15) segmentedCount:7 segmentedTitles:@[@"日",@"一",@"二",@"三",@"四",@"五",@"六"]];
        self.a=0;
        self.b=0;
        self.c=0;
        self.d=0;
        self.e=0;
        self.f=0;
        self.g=0;
        
        [self addSubview:self.semtsView];
        
        _lklButton1=[[lklbutton alloc]initWithMyButtonframe:CGRectMake(0, 20, ScreenWidth/3, ScreenHeight * 0.1 -25)];
        [_lklButton1 addTarget:self action:@selector(tapped1:) forControlEvents:UIControlEventTouchUpInside];
        
        _lklButton1.layer.borderWidth=0.5;
        _lklButton1.layer.cornerRadius=5.0;
        _lklButton1.layer.masksToBounds=YES;
        [self addSubview: _lklButton1];
       
        self.text=[[UITextField alloc]initWithFrame:CGRectMake(0,ScreenHeight * 0.1 +15 + ScreenHeight * 0.1 -15 + 20, ScreenWidth-20, 35)];
        self.text.layer.cornerRadius=5.0;
        self.text.layer.borderColor=[[UIColor blackColor] CGColor];
        self.text.layer.borderWidth=0.5;
        self.text.delegate=self;
        self.text.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.text];

    }
    return self;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
-(void)tapped1:(UIButton *)button{
    
    if ([self.clickdelegate respondsToSelector:@selector(cickbutton:)]) {
        [self.clickdelegate cickbutton:button];
    }
    
    
}
-(void)setRepeatStr:(NSString *)repeatStr{
    _repeatStr=repeatStr;
    
    NSLog(@"str=%@",_repeatStr);
    for (int i=0; i<_repeatStr.length; i++) {
        
        if (_repeatStr.length !=0) {
            NSString * mn=[_repeatStr substringWithRange:NSMakeRange(0, 1)];
            if ([mn isEqualToString:@"1"]) {
                UIButton * button0=self.semtsView.mutableArr[0];
                button0.backgroundColor=[UIColor colorWithRed:152.0/ 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1];
                button0.selected=YES;
                self.a=1;
            }
            NSString * mn1=[_repeatStr substringWithRange:NSMakeRange(1, 1)];
            if ([mn1 isEqualToString:@"1"]) {
                UIButton * button1=self.semtsView.mutableArr[1];
                button1.backgroundColor=[UIColor colorWithRed:152.0/ 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1];
                button1.selected=YES;
                self.b=1;
            }
            NSString * mn2=[_repeatStr substringWithRange:NSMakeRange(2, 1)];
            if ([mn2 isEqualToString:@"1"]) {
                UIButton * button2=self.semtsView.mutableArr[2];
                button2.backgroundColor=[UIColor colorWithRed:152.0/ 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1];
                button2.selected=YES;
                self.c=1;
            }
            NSString * mn3=[_repeatStr substringWithRange:NSMakeRange(3, 1)];
            if ([mn3 isEqualToString:@"1"]) {
                UIButton * button3=self.semtsView.mutableArr[3];
                button3.backgroundColor=[UIColor colorWithRed:152.0/ 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1];
                button3.selected=YES;
                self.d=1;
            }
            NSString * mn4=[_repeatStr substringWithRange:NSMakeRange(4, 1)];
            if ([mn4 isEqualToString:@"1"]) {
                UIButton * button4=self.semtsView.mutableArr[4];
                button4.backgroundColor=[UIColor colorWithRed:152.0/ 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1];
                button4.selected=YES;
                self.e=1;
            }
            NSString * mn5=[_repeatStr substringWithRange:NSMakeRange(5, 1)];
            if ([mn5 isEqualToString:@"1"]) {
                UIButton * button5=self.semtsView.mutableArr[5];
                button5.backgroundColor=[UIColor colorWithRed:152.0/ 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1];
                button5.selected=YES;
                self.f=1;
            }
            NSString * mn6=[_repeatStr substringWithRange:NSMakeRange(6, 1)];
            if ([mn6 isEqualToString:@"1"]) {
                UIButton * button6=self.semtsView.mutableArr[6];
                button6.backgroundColor=[UIColor colorWithRed:152.0/ 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1];
                button6.selected=YES;
                self.g=1;
            }
            
        }
    }
    
    
}

@end
