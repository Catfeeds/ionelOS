//
//  CALayer+MyUI.m
//  ione
//
//  Created by lkl on 2017/5/16.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "CALayer+MyUI.h"

@implementation CALayer (MyUI)
- (void)setBorderUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}
@end
