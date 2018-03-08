//
//  NewsViewController.m
//  i one
//
//  Created by zlt on 16/7/20.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewCell.h"
#import "FMDatabase.h"
#import "MessageModel.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD+Add.h"
@interface NewsViewController () <UITableViewDataSource,UITableViewDelegate>{


    
    NSMutableArray *_selectArray; //选中的数组
    

}
@property(nonatomic,strong)MessageModel * model;
@property(nonatomic,strong)UIButton * selectAllBtn;
@property(nonatomic,strong)UIButton * deleteBtn;
@property(nonatomic,strong)UIButton * selectedBtn;
@property(nonatomic,copy)NSString * tokenURL;
@property(nonatomic,strong)UIView * deleteView;//删除按钮视图
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"消息提醒";
    self.automaticallyAdjustsScrollViewInsets=NO;
 //红点消失
//   self.navigationController.tabBarItem.badgeValue=nil;
//    UIApplication * app=[UIApplication sharedApplication];
//    app.applicationIconBadgeNumber=0;
   //选择按钮

    
     _selectArray=[NSMutableArray array];
    _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
   _selectedBtn.frame = CGRectMake(0, 0, 20, 20);
    [_selectedBtn setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
    
    
    [_selectedBtn addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:_selectedBtn];
    
    self.navigationItem.rightBarButtonItem =selectItem;
 
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view addSubview:_tableView];
 
    
}

-(void)loadDeleteView{

     //删除按钮
    self.deleteView=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight,ScreenWidth , 49)];
    self.deleteView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:self.deleteView];
    
    //全选
    
    _selectAllBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _selectAllBtn.frame = CGRectMake(0, 0, ScreenWidth/2, 49);
    
    [_selectAllBtn setTitle:Localized(@"全选") forState:UIControlStateNormal];
    
    [_selectAllBtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteView addSubview:_selectAllBtn];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    //删除
    [_deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
   

    [_deleteBtn setTitle:Localized(@"删除") forState:UIControlStateNormal];
    
    _deleteBtn.frame = CGRectMake(ScreenWidth/2,0, ScreenWidth/2 , 49);
    
    [_deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.deleteView addSubview:_deleteBtn];
    
    UIView * lineView=[[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2-0.5,10 , 1, 29)];
    lineView.backgroundColor=[UIColor blackColor];
    [self.deleteView addSubview:lineView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _alertArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString *CellIdentifier = @"cell" ;
    NewsTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if  (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsTableViewCell"  owner:nil options:nil] firstObject];
     

   _model=self.alertArr[indexPath.row];
        
   
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if (_model.type1==1) {
    //  cell.firstLabel.text=@"围栏提醒";
        if (_model.status==0) {
             cell.secondLabel.text=[NSString stringWithFormat:@"%ld离开了%ld号围栏",(long)_model.device_name,(long)_model.fine];
            
            
        }else{
         cell.secondLabel.text=[NSString stringWithFormat:@"%ld进入了%ld号围栏",(long)_model.device_name,(long)_model.fine];
        
        }
     
    }
    else if (_model.type1==2){
   // cell.firstLabel.text=@"低电提醒";
        
        cell.secondLabel.text=[NSString stringWithFormat:@"%@剩余电量%ld",_model.device_name,(long)_model.power];
    }else if (_model.type1==3){
        
        if (_model.isTag==1) {
            cell.status.text=@"已读";
            cell.status.textColor=[UIColor redColor];
            
        }
        
        cell.secondLabel.text=[NSString stringWithFormat:@"%@请求绑定%@",_model.user_name,_model.device_name];
        
    }else if (_model.type1==4){
   // cell.firstLabel.text=@"绑定请求结果";
        if (_model.result==0) {
              cell.secondLabel.text=[NSString stringWithFormat:@"拒绝绑定设备%@的请求",_model.device_name];
            cell.secondLabel.adjustsFontSizeToFitWidth=YES;
        }else{
           cell.secondLabel.text=[NSString stringWithFormat:@"通过绑定设备%@的请求",_model.device_name];
                cell.secondLabel.adjustsFontSizeToFitWidth=YES;
        }
      
    }else{
   // cell.firstLabel.text=@"语音消息";
        cell.secondLabel.text=[NSString stringWithFormat:@"%@收到语音消息",_model.device_name];
    }
    
    // 把时间戳转化成时间
 
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeInterval time=_model.time;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    
  
    cell.thirdLabel.text=confromTimespStr;
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
 _model   = [_alertArr objectAtIndex:indexPath.row];
   
  
    
    if (!_tableView.editing)
        
    {
         NewsTableViewCell * cell=[tableView cellForRowAtIndexPath:indexPath];
        if (_model.type1==3 ) {
            
            _model.isTag=1;
            
            [self.dataBase update:_model];

            
            if( cell.status.text.length==0) {

            UIAlertController * VC=[UIAlertController alertControllerWithTitle:nil message:@"请求绑定" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action1=[UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
                
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                
                self.tokenURL=[userDefaults objectForKey:@"userTokentoken"];
                NSString * BindRspURL1=[NSString stringWithFormat:@"%@token1=%@&token2=8c4e323f771e226e1a89c72ee6efedaf&imei=%@&user=%ld&result=1",BindRspURl,self.tokenURL,_model.imei,(long)_model.user];
                NSLog(@"url=%@",BindRspURL1);
                [manager GET:BindRspURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    NSLog(@"responseObject=%@",responseObject);
                    
                    if ([[responseObject[@"errcode"] stringValue] isEqualToString:@"0"]) {
                        [MBProgressHUD showSuccess:@"成功" toView:self.view];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.status.text=@"已读";
                        
                        cell.status.textColor=[UIColor redColor];
                    });
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    
                }];
            }];
            UIAlertAction * action2=[UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                
                self.tokenURL=[userDefaults objectForKey:@"userToken"];
                NSString * BindRspURL1=[NSString stringWithFormat:@"%@token1=%@&token2=8c4e323f771e226e1a89c72ee6efedaf&imei=%@&user=%ld&result=0",BindRspURl,self.tokenURL,_model.imei,(long)_model.iD];
                [manager GET:BindRspURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
                        [MBProgressHUD showError:@"已拒绝" toView:self.view];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.status.text=@"已读";
                        
                        cell.status.textColor=[UIColor redColor];
                    });
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    
                }];
            }];
            [VC addAction:action1];
             [VC addAction:action2];
            [self presentViewController:VC animated:YES completion:nil];
                                    
        }
        }
    }
    
    if (![_selectArray containsObject:_model]) {
        [_selectArray addObject:_model];
    }
}


#pragma mark 取消选中行
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_tableView.editing)
        return;
    
    _model = [_alertArr objectAtIndex:indexPath.row];
    if ([_selectArray containsObject:_model]) {
        [_selectArray removeObject:_model];
    }
}

//#pragma mark 返回编辑模式，默认为删除模式
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
//}

-(void)viewWillDisappear:(BOOL)animated{
     self.navigationController.tabBarItem.badgeValue=nil;
    
    self.tableView.editing=NO;
    _selectAllBtn.hidden=YES;
    _deleteBtn.hidden=YES;
    [_selectedBtn setTitle:Localized(@"删除") forState:UIControlStateNormal];
    
    [_selectArray removeAllObjects];
    
 
    DataBase * dataBase=[DataBase shareManager];
    dataBase.newMessage=NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
   self.navigationController.tabBarItem.badgeValue=nil;
       [self loadData];
    [_tableView reloadData];
//    self.appDelegate= (AppDelegate *) [[UIApplication sharedApplication] delegate];
//    [self.appDelegate.dataBase.db open];
//    
//    self.alertArr=(NSMutableArray *)[self.appDelegate.dataBase getAllAlert];
//
//
//    NSLog(@"lllll%@",self.alertArr);
//   
//   [_tableView reloadData];
    
}
- (void)selectedBtn:(UIButton *)button {
 
    
    //支持同时选中多行
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    self.tableView.editing = !self.tableView.editing;
    
    
    if (self.tableView.editing) {
        
    
        
      
        
        [_selectArray removeAllObjects];
        [self loadDeleteView];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.deleteView.transform=CGAffineTransformMakeTranslation(0,-49);
        }];

    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.deleteView.transform=CGAffineTransformMakeTranslation(0,49); 
        } completion:^(BOOL finished) {
            [self.deleteView removeFromSuperview];
            self.deleteView=nil;
        }];
       
       
        
        [_selectArray removeAllObjects];
       
    }
}
-(void)deleteClick:(UIButton *) button {

    
    
    if (self.tableView.editing) {
        //删除的操作
        //得到删除的索引
        
                NSMutableArray *indexArray = [NSMutableArray array];
             for (_model in _selectArray) {
            
        //    [self.appDelegate.dataBase.db open];
                    NSLog(@"选择的数组是%@",_selectArray);
                    NSInteger num = [_alertArr indexOfObject:_model];
                    NSLog(@"全部数组%@",_alertArr);
                    NSLog(@"这个号码是%ld",(long)num);
            
            
                    NSIndexPath *path = [NSIndexPath indexPathForRow:num inSection:0];
                 
                 
                    [indexArray addObject:path];
              
                
                 
                 [self.dataBase del:_model];
          
                 
               
        }
        //刷新
        //删除
             [self.alertArr removeObjectsInArray:_selectArray];
              NSLog(@"真正de 益处后的数组%@",self.alertArr);
              [_tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
        
             [self.tableView reloadData];
        
           [_selectArray removeAllObjects];
    }
 
    else return;
    
}
-(void)selectAllBtnClick:(UIButton *)button{
    for (int i = 0; i < self.alertArr.count; i ++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition: UITableViewScrollPositionBottom];
    }
 [_selectArray addObjectsFromArray:self.alertArr];

}

-(void)longPress1:(UILongPressGestureRecognizer *)gesture

{
    self.deleteBtn.hidden=NO;
    self.selectAllBtn.hidden=NO;
    [self.selectedBtn setTitle:Localized(@"取消") forState:UIControlStateNormal];
    if(gesture.state == UIGestureRecognizerStateBegan)
        
    {
        
        CGPoint point = [gesture locationInView:self.tableView];
        
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
        
        if(indexPath == nil)
            return ;
        self.tableView.editing = YES;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScreenHeight * 0.15;
}
-(void)loadData{
    
    self.alertArr=[NSMutableArray array];
    self.dataBase=[DataBase shareManager];
    
      self.alertArr=(NSMutableArray *)[self.dataBase getAllAlert];
    
}

@end
