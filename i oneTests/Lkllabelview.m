//
//  Lkllabelview.m
//  ione
//
//  Created by lkl on 2017/5/2.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "Lkllabelview.h"

@implementation Lkllabelview
- (instancetype)initWithFrame:(CGRect)frame
               segmentedCount:(NSInteger)segmentedCount
              segmentedTitles:(NSArray *)titleArr {
self.mutableArr=[NSMutableArray array];
CGFloat semtViewWidth  = frame.size.width;
NSInteger semtViewHeight = frame.size.height;

if (self == [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, semtViewWidth, semtViewHeight)]) {
    CGFloat itemsWidth = semtViewWidth/segmentedCount;
    NSInteger itemsHeight = semtViewHeight;
    
    
    
    for (int i = 0; i < segmentedCount; i++) {

        CGFloat x = i * itemsWidth;
        CGFloat y = 0;
        self.label=[[UILabel alloc]initWithFrame:CGRectMake(x, y, itemsWidth, itemsHeight)];
        
        self.label.backgroundColor = [UIColor clearColor];
        
        self.label.layer.masksToBounds = YES;
        
        self.label.textAlignment=NSTextAlignmentCenter;
        self.label.text=titleArr[i];
        
        self.label.textColor=[UIColor blackColor];
  
        
        [self.mutableArr addObject:self.label];
        [self addSubview:self.label];
        
        
        
    }
}

self.layer.borderColor = [UIColor blackColor].CGColor;
self.layer.borderWidth = 0.5f;
self.layer.cornerRadius = 5;
self.layer.masksToBounds = YES;
return self;
}
-(void)setRepeatStr:(NSString *)repeatStr{
    _repeatStr=repeatStr;
    
    NSLog(@"str=%@",_repeatStr);
    for (int i=0; i<_repeatStr.length; i++) {
        
        if (_repeatStr.length !=0) {
            NSString * mn=[_repeatStr substringWithRange:NSMakeRange(0, 1)];
            if ([mn isEqualToString:@"1"]) {
                UILabel * button0=self.mutableArr[0];
                button0.backgroundColor=[UIColor colorWithRed:152.0/ 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1];
                
            }
            NSString * mn1=[_repeatStr substringWithRange:NSMakeRange(1, 1)];
            if ([mn1 isEqualToString:@"1"]) {
                UILabel * button1=self.mutableArr[1];
                button1.backgroundColor=[UIColor colorWithRed:152.0/ 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1];
                
            }
            NSString * mn2=[_repeatStr substringWithRange:NSMakeRange(2, 1)];
            if ([mn2 isEqualToString:@"1"]) {
                UILabel * button2=self.mutableArr[2];
                button2.backgroundColor=[UIColor colorWithRed:152.0/ 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1];
                
                
            }
            NSString * mn3=[_repeatStr substringWithRange:NSMakeRange(3, 1)];
            if ([mn3 isEqualToString:@"1"]) {
                UILabel * button3=self.mutableArr[3];
                button3.backgroundColor=[UIColor colorWithRed:152.0/ 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1];
                
            }
            NSString * mn4=[_repeatStr substringWithRange:NSMakeRange(4, 1)];
            if ([mn4 isEqualToString:@"1"]) {
                UILabel * button4=self.mutableArr[4];
                button4.backgroundColor=[UIColor colorWithRed:152.0/ 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1];
                
            }
            NSString * mn5=[_repeatStr substringWithRange:NSMakeRange(5, 1)];
            if ([mn5 isEqualToString:@"1"]) {
                UILabel * button5=self.mutableArr[5];
                button5.backgroundColor=[UIColor colorWithRed:152.0/ 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1];
                
            }
            NSString * mn6=[_repeatStr substringWithRange:NSMakeRange(6, 1)];
            if ([mn6 isEqualToString:@"1"]) {
                UILabel * button6=self.mutableArr[6];
                button6.backgroundColor=[UIColor colorWithRed:152.0/ 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1];
                
            }
            
        }
    }
    
    
}


@end
