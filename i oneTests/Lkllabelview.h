//
//  Lkllabelview.h
//  ione
//
//  Created by lkl on 2017/5/2.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Lkllabelview : UIView
- (instancetype)initWithFrame:(CGRect)frame
               segmentedCount:(NSInteger)segmentedCount
              segmentedTitles:(NSArray *)titleArr;
@property(nonatomic,strong)NSMutableArray * mutableArr;
@property(nonatomic,strong)UILabel * label;
@property(nonatomic,copy)NSString * repeatStr;//数据源数组
@end
