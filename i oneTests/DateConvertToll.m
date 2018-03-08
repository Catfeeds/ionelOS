//
//  DateConvertToll.m
//  ione
//
//  Created by lkl on 2017/5/5.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "DateConvertToll.h"

@implementation DateConvertToll
+(NSString *)transform:(NSString *)str{
    
    
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    formatter.dateStyle=NSDateFormatterMediumStyle;
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"hh:mm"];
    
    NSDate * datepre=[formatter dateFromString:str];
    
    
    
    NSString *  timeSp = [NSString stringWithFormat:@"%ld", (long)[datepre timeIntervalSince1970]];
   // NSInteger q=[timeSp integerValue] ;//时间到时间戳
    
    return timeSp;

}
@end
