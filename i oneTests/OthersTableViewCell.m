//
//  OthersTableViewCell.m
//  ione
//
//  Created by lkl on 2016/12/13.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import "OthersTableViewCell.h"
@interface OthersTableViewCell ()

@property (nonatomic, strong) UIImageView *imgView;

@end
@implementation OthersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _button1=[[UILabel alloc]initWithFrame:CGRectZero];
    _button1.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_button1];
    
    _imgView = [[UIImageView alloc] init];
    _imgView.userInteractionEnabled =NO;
    
    
    [_button addSubview:_imgView];
    NSMutableArray *mArr = [NSMutableArray array];
    for (int i = 1; i < 4; i++) {
        NSString *imgName = [NSString stringWithFormat:@"对方%d",i];
        UIImage *img = [UIImage imageNamed:imgName];
        [mArr addObject:img];
    }
    _imgView.animationImages = mArr;
    _imgView.animationDuration = 1.0;
    [_imgView stopAnimating];
    
    
    UILongPressGestureRecognizer * longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestrue:)];
    longPress.minimumPressDuration=0.2;
    [self.button addGestureRecognizer:longPress];

    self.redView=[[UIView alloc]initWithFrame:CGRectZero];
    self.redView.layer.cornerRadius=5.0;
    self.redView.hidden=NO;
    self.redView.backgroundColor=[UIColor redColor];
    [self.contentView addSubview:self.redView];
    
}
-(void)longPressGestrue:(UILongPressGestureRecognizer *)recognize{
    
    NSLog(@"长按");
    
    if (recognize.state==UIGestureRecognizerStateEnded){
        
        return;
    }
    else if (recognize.state==UIGestureRecognizerStateBegan){
        [self.othersButtonDelegate longPressButton1:recognize];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)OtherButtonTapped:(id)sender {
    [self.othersButtonDelegate otherCellButtonClick:sender];
}

- (void)setChatModel:(ChatModel *)chatModel
{
    _chatModel = chatModel;
    

}

-(void)layoutSubviews{
    [super layoutSubviews];
  
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat voiceBtnW = width * 0.3 + width * 0.7 * _chatModel.duration/60.0 - 10;
  
    _button.frame = CGRectMake(ScreenWidth * 0.1, 10, voiceBtnW * 0.8, ScreenWidth * 0.1);
   
    
    
    _button1.frame=CGRectMake(ScreenWidth * 0.1 + voiceBtnW * 0.8,(height - 40) * 0.5, ScreenWidth * 0.1, ScreenWidth * 0.1);
    _button1.text=[NSString stringWithFormat:@"%lds",_chatModel.duration];
    self.redView.frame=CGRectMake(ScreenWidth * 0.1 + voiceBtnW * 0.8 + 10 +ScreenWidth *0.1 ,(height - 40) * 0.5 + ScreenWidth * 0.05-4, 8, 8);
     _imgView.frame = CGRectMake(ScreenWidth * 0.05, 0, ScreenWidth * 0.1, ScreenWidth * 0.1);
    CGRect frame;
    frame.size.height=ScreenWidth * 0.1;
    frame.size.width=ScreenWidth * 0.1;
    frame.origin.y=10;
    frame.origin.x=0;
    self.image.frame=frame;
}
- (void)stopAnimate {
    
    [_imgView stopAnimating];
}
- (void)startAnimate {
    
    [_imgView startAnimating];
}

@end
