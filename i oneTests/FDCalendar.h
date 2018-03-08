//
//  FDCalendar.h
//  FDCalendarDemo
//
//  Created by fergusding on 15/8/20.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol mydelegate<NSObject>
-(void)passDate:(NSDate *)date;
-(void)requestLineData;
@end

@interface FDCalendar : UIView

- (instancetype)initWithCurrentDate:(NSDate *)date;
@property(nonatomic,strong)id<mydelegate>mydelegete;
@end
