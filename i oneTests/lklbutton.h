//
//  lklbutton.h
//  ione
//
//  Created by lkl on 2017/4/24.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface lklbutton : UIButton
@property(nonatomic,strong)UILabel * label;



-(instancetype)initWithMyButtonframe:(CGRect)frame;
@end
