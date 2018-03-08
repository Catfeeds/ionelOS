//
//  MyChatTableViewCell.h
//  ione
//
//  Created by lkl on 2016/12/13.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"
@protocol  myCellDelegate <NSObject>
-(void)clickButton :(UIButton *)button;
-(void)longPressButton:(UILongPressGestureRecognizer *)recognoze;
@end
@interface MyChatTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property(nonatomic,strong)UIImageView * imageview;
@property(nonatomic,strong)ChatModel * chatModel;
@property(nonatomic,weak) id <myCellDelegate>myCellDelegate;
@property(nonatomic,strong)UILabel * label;
- (void)stopAnimate;
- (void)startAnimate;
@end
