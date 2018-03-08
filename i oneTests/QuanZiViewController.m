//
//  QuanZiViewController.m
//  ione
//
//  Created by lkl on 2017/4/10.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "QuanZiViewController.h"
#import "LKLNetToll.h"
#import "QuanZiTableViewCell.h"
#import "myAticle.h"
#import "UIImageView+WebCache.h"
@interface QuanZiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArr;
@end

@implementation QuanZiViewController
-(NSMutableArray *)dataArr{

    if (_dataArr==nil) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"圈子";
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenWidth, ScreenHeight -64)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    [self.view addSubview:self.tableView];
    [self reuestfriend];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuanZiTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"QuanZiTableViewCell" owner:self options:nil] lastObject];
        
    }
    myAticle * model=self.dataArr[indexPath.row];
    cell.image1.image=[UIImage imageNamed:@"圈子图标"];
    cell.label2.text=model.title;
    
    [cell.image2 sd_setImageWithURL:[NSURL URLWithString:model.imageStr]];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return (ScreenHeight-64)/4;
}
-(void)reuestfriend{

    LKLNetToll * netToll=[LKLNetToll shareInstance];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    NSString * urlString=[NSString stringWithFormat:@"%@&token=8c4e323f771e226e1a89c72ee6efedaf",getUserFriend];
    [netToll GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"resres=%@",responseObject);
        if ([responseObject[@"errcode"] integerValue]==0) {
            for (NSDictionary * dict in responseObject[@"data"]) {
                
                myAticle *model=[myAticle myArticleModelWithDict:dict];
                
                [self.dataArr addObject:model];
                
            }
            
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
