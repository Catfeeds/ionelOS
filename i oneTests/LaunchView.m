//
//  LaunchView.m
//  ione
//
//  Created by zlt on 16/8/9.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import "LaunchView.h"
@interface LaunchView()<UIScrollViewDelegate>
@property (nonatomic, strong)UIScrollView *runScrollView;
@property (nonatomic, strong)UIPageControl *pageController;
@property UIButton *onButton;

@end


@implementation LaunchView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.runScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        self.runScrollView.pagingEnabled = YES;
        
        self.runScrollView.contentSize = CGSizeMake(ScreenWidth * 3, ScreenHeight);
        

        
        [self addSubview:self.runScrollView];
        self.pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(0, ScreenHeight * 0.8, ScreenWidth, 10)];
        self.pageController.currentPageIndicatorTintColor = [UIColor greenColor];
        self.pageController.numberOfPages = 3;
        [self addSubview:self.pageController];
        CGPoint scrollPoint = CGPointMake(0, 0);
        [self.runScrollView setContentOffset:scrollPoint animated:YES];
        //添加引导页
        [self creatOne];
        [self creatTwo];
        [self creatThree];
    }
    return self;
}
- (void)onButtonGO{
    [self.delegate OnButtonClick];
}
#pragma mark --UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat PageIndictor = self.runScrollView.contentOffset.x/ScreenWidth;
    self.pageController.currentPage = roundf(PageIndictor);//取整
}
#pragma mark -- 添加启动页
- (void)creatOne{
    UIImageView *imageView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0启动页1.jpg"]];
    imageView.frame = CGRectMake(0, 0,ScreenWidth,ScreenHeight);
    
    //imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.runScrollView.delegate = self;
    [self.runScrollView addSubview:imageView];
}
- (void)creatTwo{
    UIImageView *imageView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0启动页2.jpg"]];
    imageView.frame = CGRectMake(ScreenWidth, 0,ScreenWidth,ScreenHeight);
    
    //imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.runScrollView.delegate = self;
    [self.runScrollView addSubview:imageView];
}

- (void)creatThree{
    UIImageView *imageView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0启动页3.jpg"]];
    imageView.frame = CGRectMake(ScreenWidth * 2, 0,ScreenWidth,ScreenHeight);
   // imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.runScrollView.delegate = self;
    [self.runScrollView addSubview:imageView];
    self.onButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 50,ScreenHeight * 0.8, 100, 50)];
    [self.onButton setTitle:@"立即进入" forState:UIControlStateNormal];
    [self.onButton addTarget:self action:@selector(onButtonGO) forControlEvents:UIControlEventTouchUpInside];
    self.onButton.backgroundColor = [UIColor greenColor];
    imageView.userInteractionEnabled = YES;
    [imageView addSubview:self.onButton];
    
}


@end
