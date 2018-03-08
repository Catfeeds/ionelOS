//
//  AddClockView.h
//  ione
//
//  Created by lkl on 2017/5/12.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZESegmentedsView.h"
#import "PickerView.h"
#import "lklbutton.h"
@protocol clickbuttondelegatee<NSObject>
-(void)cickbutton1:(UIButton *)button;

@end
@interface AddClockView : UIView<ZESegmentedsViewDelegate,UWDatePickerViewDelegate,UITextFieldDelegate>
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

@property(nonatomic,weak)id <clickbuttondelegatee> LklViewDelegate;

@property(nonatomic,strong)UITextField * textField;
@property(nonatomic,strong)lklbutton * lklButton1;

@end
