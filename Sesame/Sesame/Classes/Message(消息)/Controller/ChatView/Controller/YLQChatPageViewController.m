//
//  YLQChatPageViewController.m
//  集成环信SDK2.0
//
//  Created by 杨卢青 on 16/4/1.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "YLQChatPageViewController.h"
#import "YLQChatPageCell.h"
#import <AVFoundation/AVFoundation.h>
#import "EaseMob.h"
#import "EMCDDeviceManager.h"
#import "YLQVoiceTool.h"
#import "YLQTimeCell.h"
#import "YLQTimeTool.h"

//#import <EaseMob.h>

@interface YLQChatPageViewController()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, EMChatManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarBottomConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarHeightConstraints;

/** 计算cell高度的工具*/
@property (nonatomic, strong) YLQChatPageCell *chatCellTool;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UIButton *typeSelectButton;

@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//存放对方聊天内容
@property (nonatomic, strong) NSMutableArray *dataArray;

/** 上一个会话时间 */
@property (nonatomic, copy) NSString *lastTimeStr;
/** 当前的会话对象*/
@property (nonatomic, strong) EMConversation *conversation;

@end

@implementation YLQChatPageViewController

#pragma mark - lazy load
- (YLQChatPageCell *)chatCellTool {
    
    if (!_chatCellTool) {
        _chatCellTool = [self.tableView dequeueReusableCellWithIdentifier:ReceiverCellID];
    }
    
    return _chatCellTool;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.buddy.username;

    
    // 添加代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    //加载本地数据库的聊天记录
    [self loadMessageFramDB];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //监听键盘弹出
    NSNotificationCenter *center =[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 监听键盘
- (void)keyboardWillShow:(NSNotification *)center{
    //获取键盘frame
    CGRect keyboardFrame = [center.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.toolBarBottomConstraints.constant = keyboardFrame.size.height;
    CGFloat offsetY = self.tableView.contentSize.height - self.tableView.frame.size.height + keyboardFrame.size.height + 44;
    self.tableView.contentOffset = CGPointMake(0, offsetY);
}

- (void)keyboardWillHide:(NSNotification *)center{
    self.toolBarBottomConstraints.constant = 0;
}

#pragma mark - 加载聊天记录
- (void)loadMessageFramDB {
    //获取会话对象  单聊
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.buddy.username conversationType:eConversationTypeChat];
    self.conversation = conversation;
    //获取聊天记录
    //标准使用这个
//    - (NSArray *)loadNumbersOfMessages:(NSUInteger)aCount before:(long long)timestamp;
    //但是现在简单的加载所有
    NSArray *allMessage = [conversation loadAllMessages];
    for (EMMessage *msg in allMessage) {
        [self addMessageToDataSource:msg];
        
    }
}

// 把消息添加到数据源
-(void)addMessageToDataSource:(EMMessage *)msg{
    
    // 1.添加时间到数据源
    NSString *timeStr = [YLQTimeTool timeStr:msg.timestamp];
    
#warning 过滤，同一时间内，只显示一个时间
    if (![self.lastTimeStr isEqualToString:timeStr]) {
        [self.dataArray addObject:timeStr];
        self.lastTimeStr = timeStr;
    }
    
    // 2.添加消息模型到数据源
    [self.dataArray addObject:msg];
    
    // 更改消息未读的 为 已读
    if (msg.isRead == NO){
        [self.conversation markMessageWithId:msg.messageId asRead:YES];
    }
    
}


-(void)viewDidAppear:(BOOL)animated{
    [self scrollToBottom];
}


#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 如果数据源是NSString类型，要显示TimeCell
    id obj = self.dataArray[indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        static NSString *TimeCellID = @"TimeCell";
        YLQTimeCell *timeCell = [tableView dequeueReusableCellWithIdentifier:TimeCellID];
        // 显示时间
        timeCell.timeLabel.text = obj;
        
        return timeCell;
    }

    //聊天类型
    EMMessage *message = obj;
    //是否是接收方
    BOOL isReceiver = [message.from isEqualToString:self.buddy.username];
    YLQChatPageCell *cell = nil;
    if (isReceiver) {
        cell = [tableView dequeueReusableCellWithIdentifier:ReceiverCellID];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:SenderCellID];
    }
    cell.message = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //把接受到的内容给 用来计算cell高度的cell
    id obj = self.dataArray[indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        return 24;
    }
    self.chatCellTool.message = obj;
    return [self.chatCellTool getCellHeight];
}

#pragma mark - 监听TextView的文字变化
- (void)textViewDidChange:(UITextView *)textView {
    //计算textView里面文字的高度
    CGFloat textHeight = textView.contentSize.height;
    if (textHeight > 68) {
        textHeight = 68;
    }
    
    self.toolBarHeightConstraints.constant = textHeight + 13;
    
    // 如果最后一个字是换行字符，代表点击了“发送按钮”
    if([textView.text hasSuffix:@"\n"]){
        
        //取出回车换行字符
        NSString *text = [textView.text substringToIndex:textView.text.length - 1];
        // 1.把消息发送给服务器
         [self sendTextMessage:text];
        
        // 2.清空textView的文字
        textView.text = nil;
        
        // 3.恢复InputToolBar高度
        self.toolBarHeightConstraints.constant = 46;
    }
    

}

// 发送文本聊天消息
-(void)sendTextMessage:(NSString *)text{    //创建消息体

    EMChatText *chatText = [[EMChatText alloc] initWithText:text];
    EMTextMessageBody *textBuddy = [[EMTextMessageBody alloc] initWithChatObject:chatText];
    
    [self sendMessageWithBody:textBuddy];

}

// 接收到好友回复的消息
-(void)didReceiveMessage:(EMMessage *)message{
    //微信： test3 - test2
    //环信： test4 - tes3 //的聊天记录也显示
#warning 只有是当前好友的聊天记录，才显示
    if (![message.from isEqualToString:self.buddy.username])return;
    
#warning  只有是单聊的聊天类型，才显示
    if (message.messageType != eMessageTypeChat) return;
    
    // 把消息添加到数据源
       [self addMessageToDataSource:message];
    // 刷新表格
    [self.tableView reloadData];
    
    [self scrollToBottom];
}

- (IBAction)startRecord:(id)sender {
    // 1.NSFileManger (创建一个录音文件)
    // 2.把录音的数据写入一个文件
    //    不使用AVAudioRecorder类实现，使用环信封装录音框架
    
#warning 每次录音的文件名需要不同的
    int x = arc4random() % 100000;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
    [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error) {
        if (!error) {
            NSLog(@"录音开启成功");
        }else{
            NSLog(@"录音开启失败%@",error);
        }
    }];
    
}
- (IBAction)stopRecord:(id)sender {
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
//        NSLog(@"%@",recordPath);
        if (!error) {
            // 发语音给服务器
            [self sendVoiceMessage:recordPath duration:aDuration];
        }else{
            NSLog(@"发语音给服务器失败%@",error);
        }
        
    }];
}

-(void)sendVoiceMessage:(NSString *)filePath duration:(NSInteger)duration{
    
#warning 开发时，加上时间长短的判断
    
    // 创建一个聊天的语音对象
    EMChatVoice *chatVoice = [[EMChatVoice alloc] initWithFile:filePath displayName:@"音频"];
    chatVoice.duration = duration;
    
    // 创建一个语音的消息
    EMVoiceMessageBody *voiceBody = [[EMVoiceMessageBody alloc] initWithChatObject:chatVoice];
    // 发送
    [self sendMessageWithBody:voiceBody];
    
}


-(void)sendImageMessage:(UIImage *)selectedImg{
    // 创建一个聊天图片对象
    // 原始图片
    EMChatImage *originalImage = [[EMChatImage alloc] initWithUIImage:selectedImg displayName:@"[图片]"];
    // 缩略图
#warning 缩略图的大小可以自己指定，缩略图传一个nil,代表环信会计算缩略图的大小
    EMChatImage *thumbnailImage = nil;
    
    // 创建图片的消息体
    EMImageMessageBody *imgBody = [[EMImageMessageBody alloc] initWithImage:originalImage thumbnailImage:thumbnailImage];
    
    [self sendMessageWithBody:imgBody];
    
}


#pragma mark - 抽取公共的方法
#pragma mark 发消息
-(void)sendMessageWithBody:(id<IEMMessageBody>)body{
    
    // 创建消息对象
    EMMessage *message = [[EMMessage alloc] initWithReceiver:self.buddy.username bodies:@[body]];
    
    // 发消息
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil prepare:^(EMMessage *message, EMError *error) {
        NSLog(@"准备发送聊天消息");
    } onQueue:nil completion:^(EMMessage *message, EMError *error) {
        NSLog(@"聊天消息发送成功");
    } onQueue:nil];
    
    // 刷新表格
    [self addMessageToDataSource:message];
    [self.tableView reloadData];
    // 表格滑动到底部
    [self scrollToBottom];

}


- (IBAction)cancelRecord:(id)sender {
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
}

- (IBAction)voiceButtonClick:(id)sender {
    self.recordButton.hidden = !self.recordButton.hidden;
    
    if (self.recordButton.hidden == NO) {
        // 退出键盘, 结束编辑
        [self.view endEditing:YES];
        
        // 让InputToolBar回到默认46的高度
        self.toolBarHeightConstraints.constant = 46;
    }else{
        // 键盘弹出
        [self.inputTextView becomeFirstResponder];
        
        // 让InputToolBar回到实际高度
        [self textViewDidChange:self.inputTextView];
        
    }
}

#pragma mark - imagePickDelegate
- (IBAction)typeSelectorClick:(id)sender {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imgPicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // 1.获取用户选择的图片
    UIImage *selectedImg = info[UIImagePickerControllerOriginalImage];
    
    // 2.发图片
    [self sendImageMessage:selectedImg];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


//- (void)sendImageMassege:(UIImage *)selectedImage {
//    //创建图片消息体
//    EMImageMessageBuddy *imageBuddy = [EMImageMessageBuddy alloc]
//    //创建消息对象
//    EMMessage *message = [EMMessage alloc] initWithReceiver:self.buddy.username bodies:<#(NSArray *)#>
//}


#pragma mark - ScrollDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //停止语音播放
    [YLQVoiceTool stop];
}


-(void)scrollToBottom{
    if (self.dataArray.count == 0) return;
    
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)dealloc{
    //移除代理
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    // 移除键盘的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
