//
//  OthersTableViewCell.h
//  ione
//
//  Created by lkl on 2016/12/13.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"
@protocol othersCellDelegate <NSObject>
-(void)otherCellButtonClick:(UIButton *)button;
-(void)longPressButton1:(UILongPressGestureRecognizer *)recognoze;
@end
@interface OthersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property(nonatomic,strong)UIView * redView;//语音小红点

@property(nonatomic,strong)UILabel * button1;
@property(nonatomic,weak)id<othersCellDelegate>othersButtonDelegate;
@property(nonatomic,strong)ChatModel * chatModel;
- (void)stopAnimate;
- (void)startAnimate;
@end
