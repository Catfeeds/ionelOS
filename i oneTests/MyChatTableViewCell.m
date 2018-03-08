//
//  MyChatTableViewCell.m
//  ione
//
//  Created by lkl on 2016/12/13.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import "MyChatTableViewCell.h"

@implementation MyChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];


    self.label=[[UILabel alloc]initWithFrame:CGRectZero];
    self.label.textAlignment=NSTextAlignmentRight;
    [self.contentView addSubview:self.label];
    _imageview = [[UIImageView alloc] init];
    _imageview.userInteractionEnabled = NO;
     
    
    [_button addSubview:_imageview];
    NSMutableArray *mArr = [NSMutableArray array];
    for (int i = 1; i < 4; i++) {
        NSString *imgName = [NSString stringWithFormat:@"自己%d",i];
        UIImage *img = [UIImage imageNamed:imgName];
        [mArr addObject:img];
    }
    _imageview.animationImages = mArr;
    _imageview.animationDuration = 1.0;
    [_imageview stopAnimating];
    
    
    UILongPressGestureRecognizer * longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestrue:)];
    longPress.minimumPressDuration=0.3;
    [self.button addGestureRecognizer:longPress];
}
-(void)longPressGestrue:(UILongPressGestureRecognizer *)recognize{

    NSLog(@"长按");

    if (recognize.state==UIGestureRecognizerStateEnded){
    
        return;
    }
    else if (recognize.state==UIGestureRecognizerStateBegan){
     [self.myCellDelegate longPressButton:recognize];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setChatModel:(ChatModel *)chatModel{

    _chatModel=chatModel;
}
- (IBAction)buttonTapped:(id)sender {
    [self.myCellDelegate clickButton:sender];
    
}
-(void)layoutSubviews{
    [super layoutSubviews ];
    CGFloat width = self.bounds.size.width;
    
    arc4random_uniform(180);
    CGFloat voiceBtnW = width * 0.3 + width * 0.7 * _chatModel.duration/60 - 10;
//
    
    self.button.frame=CGRectMake(ScreenWidth - ScreenWidth * 0.1 -voiceBtnW * 0.8, 10, voiceBtnW * 0.8, ScreenWidth * 0.1);
    self.label.frame=CGRectMake(ScreenWidth - voiceBtnW * 0.8 - ScreenWidth * 0.2, 10, ScreenWidth * 0.1, ScreenWidth * 0.1);
    self.label.text=[NSString stringWithFormat:@"%lds",_chatModel.duration];
    self.imageview.frame=CGRectMake(voiceBtnW * 0.8 - ScreenWidth * 0.14, 0, ScreenWidth * 0.1, ScreenWidth * 0.1);
    CGRect frame=self.button.frame;
    frame.size.height=ScreenWidth * 0.1;
    frame.size.width=ScreenWidth * 0.1;
    frame.origin.y=10;
    frame.origin.x=ScreenWidth - ScreenWidth * 0.1;
    self.image.frame=frame;
}
- (void)stopAnimate {
    
    [_imageview stopAnimating];
}

- (void)startAnimate {
    
    [_imageview startAnimating];
}
@end
