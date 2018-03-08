//
//  Mydisturbview.h
//  ione
//
//  Created by lkl on 2017/5/2.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lklbutton.h"
#import "ZESegmentedsView.h"
#import "PickerView.h"

@protocol clickbuttondelegate<NSObject>
-(void)cickbutton:(UIButton *)button;

@end

@interface Mydisturbview : UIView<ZESegmentedsViewDelegate>
-(instancetype)initMyViewWithFrame:(CGRect)frame;
@property(nonatomic,strong)ZESegmentedsView * semtsView;

@property(nonatomic,assign)NSInteger a;
@property(nonatomic,assign)NSInteger b;
@property(nonatomic,assign)NSInteger c;
@property(nonatomic,assign)NSInteger d;
@property(nonatomic,assign)NSInteger e;
@property(nonatomic,assign)NSInteger f;
@property(nonatomic,assign)NSInteger g;


@property(nonatomic,strong)PickerView * pickerView;


@property(nonatomic,copy)NSString * date;
@property(nonatomic,copy)NSString * endDate;



@property(nonatomic,strong)lklbutton * lklButton1;
@property(nonatomic,strong)lklbutton * lklButton2;

@property(nonatomic,copy)NSString * repeatStr;//数据源数组
@property(nonatomic,strong)NSMutableArray * mutableArr;


@property(nonatomic,weak)id <clickbuttondelegate>clickdelegate;
@property(nonatomic,copy)id <ZESegmentedsViewDelegate>zedelegete;
@end
