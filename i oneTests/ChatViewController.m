//
//  ChatViewController.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/5.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//



#import "ChatViewController.h"
#import "MyChatTableViewCell.h"
#import "MBProgressHUD+Add.h"
#import "OthersTableViewCell.h"
#import "ChatDAtabase.h"
#import "ChatModel.h"
#import <AVFoundation/AVFoundation.h>
#import "VoiceConverter.h"
#import "MyShowView.h"
#import "LKLNetToll.h"
#import "MyFileManager.h"
#define ToolbarInputViewHeight 43.0f
@interface ChatViewController()<UITableViewDataSource,UITableViewDelegate,AVAudioRecorderDelegate,myCellDelegate,othersCellDelegate>{
CGFloat viewHeight;
}

@property(nonatomic,strong)MyChatTableViewCell * myCell;
// 记录选中的单元格
@property(nonatomic,strong)OthersTableViewCell * oteherCell;

@property(nonatomic,assign)  NSInteger recordTime; // 用于记录录音时间
@property(nonatomic,strong)NSTimer * playTimerFirst;
@property(nonatomic,strong)NSTimer * playTimer;
@property(nonatomic,assign)  NSInteger playCount; // 用于记录录音播放
@property(nonatomic,assign)NSInteger playCountFirst;

@property(nonatomic,copy)NSString * tokenURL;
@property(nonatomic,strong)NSMutableArray * IdArr;


@property (nonatomic,strong) NSString *fileName;
@property (nonatomic,strong) AVAudioRecorder *recorder;
@property (nonatomic,strong) AVPlayer *player;

//录音状态(是否录音)
@property (nonatomic, assign)BOOL isRecoding;

// 录音文件路径
@property (nonatomic,copy) NSString *playName;
//录音存储路径
@property (nonatomic, strong)NSURL *tmpFile;

// 定时器
@property (nonatomic,strong) NSTimer *timer;
// 属性设置
@property (nonatomic,copy) NSDictionary *recorderSettingsDict;

@property(nonatomic,strong)AVAudioSession * session;
//当前的时间
@property (strong, nonatomic)   NSString         *recordFileName;

@property (nonatomic) UIButton *voiceButton;

@end
static NSString *const cellIdentifier=@"QQChart";
@implementation ChatViewController





-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
//    _chatDatabase=[ChatDAtabase shareManager];
//    self.messageArray=[NSArray array];
//    
//    self.messageArray=[_chatDatabase getAllAlert];
    
    [self loadData];
    
    self.title=@"语音聊天";
    self.view.backgroundColor=[UIColor whiteColor];
    
    //add UItableView
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 40)];
    
    label.textAlignment=NSTextAlignmentCenter;
    label.text=_name;
    [self.view addSubview:label];
    UIView * lineView1=[[UIView alloc]initWithFrame:CGRectMake(0, 104, ScreenWidth, 0.5)];
    lineView1.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:lineView1];
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+40 +0.5, ScreenWidth, ScreenHeight-50-64-40-0.5) style:UITableViewStylePlain];
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;//chat_bg_default.jpg
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.view addSubview:self.tableView];
    
    UIView * lineView=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 72, ScreenWidth, 0.5)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    // 创建button5
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,ScreenHeight - 71.5,ScreenWidth,71.5)];
    [self.view addSubview:button];
    
    
    [button setImage:[UIImage imageNamed:@"语音按钮"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"语音按钮"] forState:UIControlStateHighlighted];
   
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    [button setTitle:@"按住说话"forState:UIControlStateNormal];
    [button setTitle:@"松开发送"forState:UIControlStateHighlighted];
    
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [button addTarget:self action:@selector(holdDownButtonTouchDown)forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(holdDownButtonTouchUpInside)forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(holdDownDragOutside)forControlEvents:UIControlEventTouchDragExit];
    
    _voiceButton = button;

}

-(void)viewDidLayoutSubviews
{
    CGSize titleLabelSize = [_voiceButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : _voiceButton.titleLabel.font}];
    
    //获取 imageView 的size
    CGSize imageViewSize = _voiceButton.imageView.frame.size;
    
    [_voiceButton setImageEdgeInsets:UIEdgeInsetsMake(5, (ScreenWidth - imageViewSize.width)/2,0 ,0 )];
    [_voiceButton setTitleEdgeInsets:UIEdgeInsetsMake(5 + imageViewSize.height, (ScreenWidth - titleLabelSize.width)/2 - imageViewSize.width, 0, 0)];

}
-(void)loadData{
    
    _chatDatabase=[ChatDAtabase shareManager];
    self.messageArray=[NSArray array];
    
    self.messageArray=[_chatDatabase getAllAlert];
    self.dataArr=[NSMutableArray array];
    for (ChatModel * model in self.messageArray) {
        if ([model.imei isEqualToString: self.imei]) {
            [self.dataArr addObject:model];
        }
    }
    NSLog(@"真正数组的个数%lu",(unsigned long)self.dataArr.count);
}

- (void)_createUI {

    
    //录音设置
    self.recorderSettingsDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [NSNumber numberWithFloat: 8000.0],AVSampleRateKey,//采样率
                                 [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                 [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数默认 16
                                 [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                               
                                 nil];
    
    self.playName = [MyFileManager newFileWithExtension:@"wav"];
   
    self.tmpFile = [NSURL fileURLWithPath:[MyFileManager pathForFile:self.playName]];
    //初始化
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.tmpFile settings:self.recorderSettingsDict error:nil];
    
    //开启音量检测
    self.recorder.meteringEnabled = YES;
    self.recorder.delegate = self;
}

- (void)holdDownButtonTouchDown {
    
    NSLog(@"holdDownButtonTouchDown");
    _session = [AVAudioSession sharedInstance];

    
    NSError *error1;
    [_session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error1];
     [self _createUI];
    //判断后台有没有播放
    if (_session == nil) {
        
        NSLog(@"Error creating sessing:%@", [error1 description]);
        
    } else {
        
        [_session setActive:YES error:&error1];
        
    }

    if (!self.isRecoding) {
        //将录音状态变为录音
        self.isRecoding = YES;
 
        if (self.recorder) {
                //开启音量检测
            self.recorder.meteringEnabled =YES;
            [self.recorder prepareToRecord];
            [self.recorder record];
           
            //启动定时器
            self.timer=[NSTimer timerWithTimeInterval:1 target:self selector:@selector(levelTimer:) userInfo:nil repeats:YES];
            [[NSRunLoop  currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
            _recordTime = 0;

        }
    }
}

- (void)holdDownButtonTouchUpInside {
   

    
    if (_recordTime<1) {
        //录音停止
        [self.recorder stop];
        self.isRecoding=NO;
        self.recorder =nil;
        //  结束定时器
        [self.timer invalidate];
        self.timer =nil;
        MyShowView * myView=[[MyShowView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth * 0.4, ScreenWidth * 0.4) WithTitle:@"语音时间过短"];
        myView.center=CGPointMake(ScreenWidth/2, ScreenHeight/2);
        [[UIApplication sharedApplication].keyWindow addSubview:myView];
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [myView removeFromSuperview];
        });
      
        return;
    }
 

    //录音停止
    [self.recorder stop];
    
    self.isRecoding=NO;
    self.recorder =nil;
  //  结束定时器
    [self.timer invalidate];
    self.timer =nil;
    
     NSLog(@"记录的录音时间%ld",_recordTime);
   
    NSString *amrPath = [MyFileManager newFileWithExtension:@"amr"];
    
    if( [VoiceConverter ConvertWavToAmr:[MyFileManager pathForFile:self.playName]
                            amrSavePath:[MyFileManager pathForFile:amrPath]]){
   
   

        NSURL * url=[NSURL fileURLWithPath:[MyFileManager pathForFile:amrPath]];
       
       //创建请求工具对象
       LKLNetToll *newWorkTool = [LKLNetToll shareInstance];
       
       //设置网络请求标识
       [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.tokenURL=[userDefaults objectForKey:@"userTokentoken"];
    
    NSString * postURL1=[NSString stringWithFormat:@"%@token=%@",postURL,self.tokenURL];
    
    
    [newWorkTool POST:postURL1 parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileURL:url name:@"file" error:nil];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"上传%@",responseObject);
        if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
              self.url= responseObject[@"data"][@"url"];
            
            NSString * postVoiceURL1=[NSString stringWithFormat:@"%@&token=%@&imei=%@&url=%@",postVoiceURL,self.tokenURL,_imei,_url];
            
            
            [newWorkTool GET:postVoiceURL1 parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
                    NSLog(@"上传成功");
                }
                [MyFileManager deleteFile:amrPath];
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [MyFileManager deleteFile:amrPath];
            }];

        }
      
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"错误%@",error);
    }];
    
       
   }
    
    
     ChatModel * chatModel=[[ChatModel alloc]init];
    
    chatModel.duration=_recordTime;
    chatModel.url= self.playName;
    chatModel.isSelf = 1;
    chatModel.imei=self.imei;
    if (_recordTime >=1) {
        [self.chatDatabase addMessage:chatModel];
        
        
        [self.dataArr addObject:chatModel];
        
        
        [self.tableView reloadData];
        
        if (self.dataArr && self.dataArr.count>0 ) {
            
            NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.dataArr.count -1  inSection:0];
            [_tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
             [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }

       
    }
    
   
 
    

}
-(void)levelTimer:(NSTimer *)timer{
  _recordTime++;
}
-(void)holdDownDragOutside{
    NSLog(@"11");
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString *CellIdentifier = @"cell" ;
    ChatModel * chatModel=self.dataArr[indexPath.row];
    if (chatModel.isSelf) {
        MyChatTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
      
        if  (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyChatTableViewCell"  owner:nil options:nil] firstObject];
              cell.myCellDelegate=self;
            cell.chatModel=chatModel;
            cell.backgroundColor=[UIColor clearColor];
        }
        
          return cell;
    }
   
    
    else {
         OthersTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
       
        if  (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"OthersTableViewCell"  owner:nil options:nil] firstObject];
             cell.othersButtonDelegate=self;

            cell.chatModel = chatModel;
            if (cell.chatModel.isTag==1) {
                cell.redView.hidden=YES;
            }
                

        }
        
   
        return cell;

    }
}

//点击自己发的播放
-(void)clickButton :(UIButton *)button{
    if (_playTimerFirst) {
         [_playTimerFirst invalidate];
    }
   
    MyChatTableViewCell * cell= (MyChatTableViewCell *) button.superview.superview;
    
//    
    [_myCell stopAnimate];
    if (self.player) {
        self.player=nil;
    }
    [cell startAnimate];
    _myCell=cell;
    NSIndexPath * indexPath=[self.tableView indexPathForCell:cell];
    ChatModel * model=self.dataArr[indexPath.row];
    
    NSString * str=    model.url;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error1;
    [audioSession setCategory:AVAudioSessionCategorySoloAmbient error:&error1];
    [audioSession setActive:YES error:&error1];

    NSURL * url=[NSURL fileURLWithPath:[MyFileManager pathForFile:str]];
    
    self.player=[[AVPlayer alloc]initWithURL:url];
    

    [self.player play];
    
    [self startWithCellFirst:cell WithModel :model];
}

-(void)startWithCellFirst :(MyChatTableViewCell *)cell WithModel :(ChatModel *)model{
    NSArray * arr=@[cell,model];
    _playTimerFirst = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_playCountFirst:) userInfo:arr repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:_playTimerFirst forMode:NSDefaultRunLoopMode];
    _playCountFirst = 0;

}
// 判断是否播放完成
- (void)_playCountFirst: (NSTimer *)timer {
    
    ChatModel * model=timer.userInfo[1];
    _playCountFirst ++;
    
    MyChatTableViewCell * cell=timer.userInfo[0];
    if (_playCountFirst >= model.duration) {
        [self.player pause];
        
        [cell stopAnimate];
        [_playTimerFirst invalidate];
        
        self.player=nil;
        self.playTimerFirst=nil;
    }
}


//点击别人发的
-(void)otherCellButtonClick:(UIButton *)button{
    if (_playTimer) {
       [_playTimer invalidate];
    }
    OthersTableViewCell * cell=(OthersTableViewCell *)button.superview.superview;
    [_oteherCell stopAnimate];
    [cell startAnimate];
    _oteherCell=cell;
    
    _oteherCell.redView.hidden=YES;
    [_chatDatabase update:_oteherCell.chatModel];
    
    NSIndexPath * indexPath=[self.tableView indexPathForCell:cell];
    ChatModel * model=self.dataArr[indexPath.row];
   
    NSString * str=    model.url;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error1;
    [audioSession setCategory:AVAudioSessionCategorySoloAmbient error:&error1];
    [audioSession setActive:YES error:&error1];
    
    if (str==nil) {
        [cell stopAnimate];
        return;
    }
    NSURL * url=[NSURL fileURLWithPath:[MyFileManager pathForFile:str]];
    
    self.player=[[AVPlayer alloc]initWithURL:url];
    
    [self.player play];
    
    [self _startPlayWithCell:cell WithModel :model];
    
    
}

// 开始播放计时
- (void)_startPlayWithCell :(OthersTableViewCell *)cell WithModel:(ChatModel *)model{
    NSArray * arr=@[cell,model];
    _playTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_playCount:) userInfo:arr repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:_playTimer forMode:NSDefaultRunLoopMode];
    _playCount = 0;
    
}

// 判断是否播放完成
- (void)_playCount: (NSTimer *)timer {
    ChatModel * model=timer.userInfo[1];
    _playCount++;
    
    OthersTableViewCell * cell=timer.userInfo[0];
    if (_playCount >= model.duration) {
        [self.player pause];
        [cell stopAnimate];
        [_playTimer invalidate];
        self.player=nil;
        self.playTimer=nil;
    }
}

#pragma mark - AVAudioRecorderDelegate方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [_session setActive:NO error:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    [self loadData];
//     [_tableView reloadData];
    //tableView 滚动到最后一个单元格
    if (self.dataArr && self.dataArr.count>0 ) {
   
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.dataArr.count -1  inSection:0];
    [_tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}

- (NSString *)getCurrentTimeLong
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    //为字符型
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    return [timeString substringToIndex:13];
}

#pragma mark - 生成文件路径
+ (NSString*)GetPathByFileName:(NSString *)_fileName ofType:(NSString *)_type{
   
    NSString* fileDirectory = [[_fileName stringByAppendingPathExtension:_type]
                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return fileDirectory;
}
//自己
-(void)longPressButton:(UILongPressGestureRecognizer *)recognoze{
    if (recognoze.state == UIGestureRecognizerStateEnded) {
        
        return;
        
    } else if (recognoze.state == UIGestureRecognizerStateBegan){
            CGPoint p=[recognoze locationInView:self.tableView];
            NSIndexPath * indexPath=[self.tableView indexPathForRowAtPoint:p];
              NSInteger a =indexPath.row;
                UIAlertController * VC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
         __weak typeof(self) weakSelf = self;
                UIAlertAction * a1=[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                  
                    
                    ChatModel * model=self.dataArr[indexPath.row];
                    
                    [self.chatDatabase del:model];
                    
                    [self.dataArr removeObject:model];
                    
//                    self.messageArray=[self.chatDatabase getAllAlert];
//                    
                   NSLog(@"a=%d,count=%d",a,self.dataArr.count);
                    
                    NSMutableArray * arr=[NSMutableArray array];
                    
                    [arr addObject:[NSIndexPath indexPathForRow:a inSection:0]];
                    
                    
                    [weakSelf.tableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
                    
                   
                      [self.tableView reloadData];
                 
    
                }];
                [VC addAction:a1];
                UIAlertAction * a2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
                }];
                [VC addAction:a2];
                [self presentViewController: VC animated:YES completion:nil];
    
    }
}
//别人语音删除
-(void)longPressButton1:(UILongPressGestureRecognizer *)recognoze{
    if (recognoze.state == UIGestureRecognizerStateEnded) {
        
        return;
        
    } else if (recognoze.state == UIGestureRecognizerStateBegan) {
    
    CGPoint p=[recognoze locationInView:self.tableView];
    NSIndexPath * indexPath=[self.tableView indexPathForRowAtPoint:p];
    NSInteger a =indexPath.row;
    UIAlertController * VC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction * a1=[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        ChatModel * model=self.dataArr[indexPath.row];
        
        [self.chatDatabase del:model ];
        [self.dataArr removeObject:model];
        
//        self.messageArray=[self.chatDatabase getAllAlert];
//        
//        NSLog(@"a=%ld,count=%ld",a,self.messageArray.count);
        
        NSMutableArray * arr=[NSMutableArray array];
        
        [arr addObject:[NSIndexPath indexPathForRow:a inSection:0]];
        
        [weakSelf.tableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
        
        
        [self.tableView reloadData];
        
        
    }];
    [VC addAction:a1];
    UIAlertAction * a2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [VC addAction:a2];
    [self presentViewController: VC animated:YES completion:nil];
    
    }
}

#pragma mark - 生成当前时间字符串
+ (NSString*)GetCurrentTimeString{
    NSDateFormatter *dateformat = [[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateformat stringFromDate:[NSDate date]];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.chatDatabase.newMessage=NO;
    
        
    if (self.player) {
        [self.player pause];
        self.player=nil;
    }
    

}

@end
