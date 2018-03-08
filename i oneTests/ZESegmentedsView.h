//
//  ZESegmentedsView.h
//  
//
//  Created by wzm on 16/4/8.
//  Copyright © 2016年 wzm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZESegmentedsViewDelegate <NSObject>

@required

- (void)selectedZESegmentedsViewItemAtIndex:(NSInteger )selectedItemIndex;

@end


@interface ZESegmentedsView : UIView
@property(nonatomic,strong)UIButton * button;
@property(nonatomic,strong)NSMutableArray * mutableArr;
//代理对象
@property (nonatomic,weak)id<ZESegmentedsViewDelegate> delegate;

@property(nonatomic,copy)NSString * repeatStr;//数据源数组

- (instancetype)initWithFrame:(CGRect)frame
               segmentedCount:(NSInteger)segmentedCount
              segmentedTitles:(NSArray *)titleArr;

@end
