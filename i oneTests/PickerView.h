//
//  PickerView.h
//  ione
//
//  Created by lkl on 2017/5/9.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    // 开始日期
    DateTypeOfStart = 0,
    
    // 结束日期
    DateTypeOfEnd,

}DateType;
@protocol UWDatePickerViewDelegate <NSObject>

/**
 *  选择日期确定后的代理事件
 *
 *  @param date 日期
 *  @param type 时间选择器状态
 */
- (void)getSelectDate:(NSString *)date type:(DateType)type;
-(void)removedatepicker;
@end
@interface PickerView : UIView
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (weak, nonatomic) IBOutlet UIButton *cancellButton;
@property (weak, nonatomic) IBOutlet UIButton *qdButton;
@property(nonatomic,weak)id<UWDatePickerViewDelegate>delegate;
@property(nonatomic,assign)DateType type;
+ (PickerView *)instancePickerView;
@end
