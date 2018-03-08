//
//  LaunchView.h
//  ione
//
//  Created by zlt on 16/8/9.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RunPageControllerDelegate <NSObject>

-(void)OnButtonClick;

@end
@interface LaunchView : UIView
@property id<RunPageControllerDelegate>delegate;
@end
