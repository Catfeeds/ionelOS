//
//  SheZhiTableViewCell.h
//  ione
//
//  Created by lkl on 2017/5/3.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol switchTappedDelegate <NSObject>
-(void)switchTapped:(id)sender;
@end
@interface SheZhiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
@property(nonatomic,strong)id<switchTappedDelegate> swtichdelegate;
@end
