//
//  FoundViewController.m
//  i one
//
//  Created by zlt on 16/7/20.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import "FoundViewController.h"
#import "AppDelegate.h"
#import "FoundTableView1Cell.h"
#import "QuanZiViewController.h"
#import "LKLNetToll.h"
#import "myAticle.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "WebViewController.h"
@interface FoundViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)NSString * text;
@property(nonatomic,strong)UILabel * label;
@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UIImageView * imageView;
@property(nonatomic,strong)NSMutableArray * dataArr;
@end

@implementation FoundViewController


- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title=@"发现";
    
    self.automaticallyAdjustsScrollViewInsets=NO;

//    self.bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight * 0.2)];
//    self.bgView.backgroundColor=[UIColor clearColor];
//    [self.view addSubview:self.bgView];
//    UIView * lineView=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight * 0.2 - 0.5, ScreenWidth, 0.5)];
//    lineView.backgroundColor=[UIColor grayColor];
//    [self.bgView addSubview:lineView];
//    
    
//    
//    self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 30, self.bgView.bounds.size.height-60, self.bgView.bounds.size.height-60)];
//    
//    self.imageView.image=[UIImage imageNamed:@"图标"];
//    
//    
//    [self.bgView addSubview:self.imageView];
//    
//    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame=self.bgView.bounds;
//    button.backgroundColor=[UIColor clearColor];
//    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.bgView addSubview:button];
    
//    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(20 + ScreenWidth * 0.25,10, 50, 30)];
//    label.text=@"圈子";
//    label.textAlignment=NSTextAlignmentCenter;
//    label.font=[UIFont boldSystemFontOfSize:15];
//    [self.bgView addSubview:label];
    
    
//    UILabel * label1=[[UILabel alloc]initWithFrame:CGRectMake(20 + ScreenWidth * 0.25,self.bgView.bounds.size.height/2-10 ,ScreenWidth/2 ,self.bgView.bounds.size.height/2 )];
//    
//    label1.text=@"如果你无法简洁的表达你的想法，那说明你还不够了解它";
//    
//    label1.textAlignment=NSTextAlignmentLeft;
//    label1.font=[UIFont systemFontOfSize:12];
//    label1.numberOfLines=0;
//    [self.bgView addSubview:label1];
//    
//    UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-15, ScreenHeight * 0.1-5, 10, 10)];
//    
//    imageView.image=[UIImage imageNamed:@"箭头右"];
//    [self.bgView addSubview:imageView];
    
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenWidth, ScreenHeight -64)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[[UIView alloc]init];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    //添加下拉刷新试图
    [self.tableView addHeaderWithTarget:self action:@selector(requestArticle)];
    [self.tableView headerBeginRefreshing];
    //添加上拉加载
    [self.tableView addFooterWithTarget:self action:@selector(requestArticle)];
    [self.tableView footerBeginRefreshing];
    
    
    
    [self.view addSubview:self.tableView];
 
    [self requestArticle];
}
-(void)requestArticle{
    LKLNetToll * nettoll=[LKLNetToll shareInstance];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    NSString * url=[NSString stringWithFormat:@"%@&token=%@",getActicle,[userDefaults objectForKey:@"userTokentoken"]];
    [nettoll GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"res=%@",responseObject);
        
        
        self.dataArr=[NSMutableArray array];
        if ([responseObject[@"errcode"] integerValue]==0) {
            for (NSDictionary * dict in responseObject[@"data"]) {
                
                myAticle *model=[myAticle myArticleModelWithDict:dict];
                
                 [self.dataArr addObject:model];
                
            }
     
            [self.tableView reloadData];
             [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    

}
-(void)buttonTapped:(UIButton *)button{
    QuanZiViewController * VC=[[QuanZiViewController alloc]init];
    VC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:VC animated:YES];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  FoundTableView1Cell   * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"FoundTableView1Cell" owner:self options:nil] lastObject];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }

    }
    myAticle * model=self.dataArr[indexPath.row];

    [cell.image sd_setImageWithURL:[NSURL URLWithString:model.imageStr]];
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ScreenWidth/3;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 myAticle * model=self.dataArr[indexPath.row];
   
    WebViewController *vc=[[WebViewController alloc]init];
    vc.webStr=model.content;
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];

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
