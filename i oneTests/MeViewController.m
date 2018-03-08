//
//  MeViewController.m
//  ione
//
//  Created by lkl on 2017/4/11.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "MeViewController.h"
#import "ClassCollectionViewCell.h"
#import "SheZhiViewController.h"
#import "BaseNavigationViewController.h"
#import "ConnectionViewController.h"
#import "BondssViewController.h"
#import "MyCollectionViewCell.h"
#import "NickViewController.h"
@interface MeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSArray * titleArr;
@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout *flowLayOut;
@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,strong)UIImageView  *imageView;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.titleArr=@[@"设备列表",@"充值续费",@"活动"];
    
    self.title=@"我";
    
    
    
    self.bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight * 0.2)];
    self.bgView.backgroundColor=[UIColor colorWithRed:152.0/ 255.0 green:245.0 / 255.0 blue:255.0 / 255.0 alpha:1];
    
    [self.view addSubview:self.bgView];
    
    self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 20, self.bgView.bounds.size.height-40, self.bgView.bounds.size.height-40)];
    
    self.imageView.image=[UIImage imageNamed:@"头像"];
    
    
    [self.bgView addSubview:self.imageView];
    
    UILabel * userlabel=[[UILabel alloc]initWithFrame:CGRectMake(10+ScreenWidth * 0.25 +10,self.imageView.center.y-30 , 70, 30)];
    userlabel.textAlignment=NSTextAlignmentLeft;
    userlabel.text=@"用户名:";
    [self.bgView addSubview:userlabel];
    
    UILabel * nickLabel=[[UILabel alloc]initWithFrame:CGRectMake(10+ScreenWidth * 0.25 +10, self.imageView.center.y, 70, 30)];
    nickLabel.text=@"昵称:";
    nickLabel.textAlignment=NSTextAlignmentLeft;
    [self.bgView addSubview:nickLabel];
    
    self.label1=[[UILabel alloc]initWithFrame:CGRectMake(10+ScreenWidth * 0.25 +20 +60,self.imageView.center.y-30 , ScreenWidth/3.5+20, 30)];
    self.label1.text=[userDefaults objectForKey:@"USERname"];
    self.label1.textAlignment=NSTextAlignmentLeft;
    [self.bgView addSubview:self.label1];
    
   
    
    self.nickButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.nickButton.frame=CGRectMake(10+ScreenWidth * 0.25 +20 +60, self.imageView.center.y, ScreenWidth-nickLabel.frame.origin.y-70, 30);
    self.nickButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    self.nickButton.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.nickButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.nickButton addTarget:self action:@selector(nickButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.nickButton];
    
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(ScreenWidth -40, 10, 40, 40);
    [button setImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:button];
    
    
    self.flowLayOut=[[UICollectionViewFlowLayout alloc]init];
    self.flowLayOut.minimumLineSpacing=0;
    self.flowLayOut.minimumInteritemSpacing=0;
    NSLog(@"背景视图的高度和%f,%f",self.bgView.bounds.size.height,self.bgView.bounds.origin.y);
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0,ScreenHeight * 0.2, ScreenWidth,
                                                                          ScreenWidth/4) collectionViewLayout:self.flowLayOut];
    self.collectionView.backgroundColor=[UIColor whiteColor];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [self.view addSubview:self.collectionView];
   
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];

}
-(void)nickButtonTapped:(UIButton *)button{
    NickViewController * nickVC=[[NickViewController alloc]init];
    nickVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:nickVC animated:YES];

}
-(void)buttonTapped:(UIButton *)button{
   
    SheZhiViewController * VC=[[SheZhiViewController alloc]initWithNibName:@"SheZhiViewController" bundle:nil];
    
    VC.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:VC animated:YES];

}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MyCollectionViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.label.text=self.titleArr[indexPath.item];
    if (indexPath.item==0) {
        cell.image.image=[UIImage imageNamed:@"设备图标"];
    }
//    else if (indexPath.item==1){
//    cell.image.image=[UIImage imageNamed:@"充值图标"];
//    }
//    else{
//    cell.image.image=[UIImage imageNamed:@"活动图标"];
//    }
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,0,0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return CGSizeMake(ScreenWidth /3 ,ScreenWidth/4);
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item==0) {
       
        BondssViewController * vc=[[BondssViewController alloc]initWithNibName:@"BondssViewController" bundle:nil];
         
        
        vc.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:vc animated:YES];
    }

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     [self.navigationController setNavigationBarHidden:YES animated:YES];
    if ([userDefaults objectForKey:@"nick"]) {
        [self.nickButton setTitle:[userDefaults objectForKey:@"nick"] forState:UIControlStateNormal];
        
    }
    else{
        if ([userDefaults objectForKey:@"nick"]) {
            NSString * str=[userDefaults objectForKey:@"nick"];
            [self.nickButton setTitle:str forState:UIControlStateNormal];
        }
        else{
        [self.nickButton setTitle:@"某某某" forState:UIControlStateNormal];
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
