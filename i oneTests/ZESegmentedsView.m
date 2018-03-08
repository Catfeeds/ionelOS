//
//  ZESegmentedsView.m
//  
//
//  Created by wzm on 16/4/8.
//  Copyright © 2016年 wzm. All rights reserved.
//

#import "ZESegmentedsView.h"

@implementation ZESegmentedsView

- (instancetype)initWithFrame:(CGRect)frame
               segmentedCount:(NSInteger)segmentedCount
              segmentedTitles:(NSArray *)titleArr {
//    

    self.mutableArr=[NSMutableArray array];
    CGFloat semtViewWidth  = frame.size.width;
    NSInteger semtViewHeight = frame.size.height;
    
    if (self == [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, semtViewWidth, semtViewHeight)]) {
        CGFloat itemsWidth = semtViewWidth/segmentedCount;
        NSInteger itemsHeight = semtViewHeight;
        
        int j;
        
        for (int i = 0; i < segmentedCount; i++) {
            
            //NSLog(@"添加了%d个btn",i);
            self.button = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat x = i * itemsWidth;
            CGFloat y = 0;
            
            self.button.frame = CGRectMake(x, y, itemsWidth, itemsHeight);
            self.button.backgroundColor = [UIColor clearColor];
            self.button.tag = 1000 + i;
            self.button.layer.masksToBounds = YES;
            
            
            
            
            
            [self.button setTitle:titleArr[i] forState:UIControlStateNormal];
            [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
            [self.mutableArr addObject:self.button];
            [self addSubview:self.button];
            
            j = i;
            
//            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake( x+ itemsWidth, y, 1, itemsHeight)];
//            lineView.backgroundColor = [UIColor blackColor];
//                
//            [self addSubview:lineView];
            [self.button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 0.50f;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES; 
    return self;
}


#pragma mark - 按钮点击事件


- (void)clickItem:(UIButton *)btn {

    //NSLog(@"点击了btn");
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        
        btn.backgroundColor=[UIColor colorWithRed:152.0/ 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1];
       
       
        
        
        if (_delegate && [_delegate respondsToSelector:@selector(selectedZESegmentedsViewItemAtIndex:)]) {
            
            [_delegate selectedZESegmentedsViewItemAtIndex:btn.tag - 1000];
            
        }

        
    }else{
    
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        if (_delegate && [_delegate respondsToSelector:@selector(selectedZESegmentedsViewItemAtIndex:)]) {
            
            [_delegate selectedZESegmentedsViewItemAtIndex:btn.tag];
            
        }

        
        
    }
    
    


}

-(void)setRepeatStr:(NSString *)repeatStr{
    _repeatStr=repeatStr;
    
    NSLog(@"str=%@",_repeatStr);
    for (int i=0; i<_repeatStr.length; i++) {
        
        if (_repeatStr.length !=0) {
            NSString * mn=[_repeatStr substringWithRange:NSMakeRange(0, 1)];
            if ([mn isEqualToString:@"1"]) {
                UIButton * button0=self.mutableArr[0];
                button0.backgroundColor=[UIColor redColor];
                button0.selected=YES;
            }
            NSString * mn1=[_repeatStr substringWithRange:NSMakeRange(1, 1)];
            if ([mn1 isEqualToString:@"1"]) {
                UIButton * button1=self.mutableArr[1];
                button1.backgroundColor=[UIColor redColor];
                button1.selected=YES;
            }
            NSString * mn2=[_repeatStr substringWithRange:NSMakeRange(2, 1)];
            if ([mn2 isEqualToString:@"1"]) {
                UIButton * button2=self.mutableArr[2];
                button2.backgroundColor=[UIColor redColor];
                button2.selected=YES;
                
            }
            NSString * mn3=[_repeatStr substringWithRange:NSMakeRange(3, 1)];
            if ([mn3 isEqualToString:@"1"]) {
                UIButton * button3=self.mutableArr[3];
                button3.backgroundColor=[UIColor redColor];
                button3.selected=YES;
            }
            NSString * mn4=[_repeatStr substringWithRange:NSMakeRange(4, 1)];
            if ([mn4 isEqualToString:@"1"]) {
                UIButton * button4=self.mutableArr[4];
                button4.backgroundColor=[UIColor redColor];
                button4.selected=YES;
            }
            NSString * mn5=[_repeatStr substringWithRange:NSMakeRange(5, 1)];
            if ([mn5 isEqualToString:@"1"]) {
                UIButton * button5=self.mutableArr[5];
                button5.backgroundColor=[UIColor redColor];
                button5.selected=YES;
            }
            NSString * mn6=[_repeatStr substringWithRange:NSMakeRange(6, 1)];
            if ([mn6 isEqualToString:@"1"]) {
                UIButton * button6=self.mutableArr[6];
                button6.backgroundColor=[UIColor redColor];
                button6.selected=YES;
            }
            
        }
    }
 

}

@end
