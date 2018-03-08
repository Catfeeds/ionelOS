//
//  LklView.h
//  ione
//
//  Created by lkl on 2017/4/28.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZESegmentedsView.h"
#import "PickerView.h"
#import "lklbutton.h"
@protocol clickbuttondelegatee<NSObject>
-(void)cickbutton1:(UIButton *)button;

@end
@interface LklView : UIView<ZESegmentedsViewDelegate,UWDatePickerViewDelegate>
-(instancetype)initMyViewWithFrame:(CGRect)frame;

@property(nonatomic,strong)ZESegmentedsView * semtsView;
@property(nonatomic,strong)UIView * bgView;
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
@property(nonatomic,weak)id <clickbuttondelegatee> LklViewDelegate;


@property(nonatomic,strong)lklbutton * lklButton1;
@property(nonatomic,strong)lklbutton * lklButton2;
@end
