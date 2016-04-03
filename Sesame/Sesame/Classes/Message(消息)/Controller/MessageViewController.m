//
//  MessageViewController.m
//  Sesame
//
//  Created by 杨卢青 on 16/1/26.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "MessageViewController.h"
#import "YLQChatPageViewController.h"

@interface MessageViewController ()<EMChatManagerDelegate>
/** 会话数据*/
@property (nonatomic, strong) NSArray *conversations;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    // 加载会话列表
    //    [[EaseMob sharedInstance].chatManager conversations]
    self.conversations =  [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    NSLog(@"会话列表 %@",self.conversations);
    
    self.navigationItem.title = @"芝麻客服";
    // 显示总的未读消息数
    [self showTabbarItemBadge];
}

- (void)showTabbarItemBadge {
    // 获取总的未读取消息数
    NSUInteger totalUnreadCount = 0;
    for (EMConversation *conversation in self.conversations) {
        totalUnreadCount += [conversation unreadMessagesCount];
    }
    
    // 显示数字
    if (totalUnreadCount) {
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",totalUnreadCount];
    } else {
        self.navigationController.tabBarItem.badgeValue = nil;
    }
    
}

#pragma mark - EMChatManagerDelegate
//网络状态改变的回调
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    //
    if (eEMConnectionDisconnected == connectionState) {
        NSLog(@"未连接");
        self.title = @"未连接";
    } else {
        NSLog(@"恢复连接");
    }
}

/*!
 @method
 @brief 将要发起自动重连操作
 @discussion
 @result
 */
- (void)willAutoReconnect {
    self.title = @"连接中";
}

/*!
 @method
 @brief 自动重连操作完成后的回调（成功的话，error为nil，失败的话，查看error的错误信息）
 @discussion
 @result
 */
- (void)didAutoReconnectFinishedWithError:(NSError *)error {
    self.navigationItem.title = @"芝麻客服";
}


#pragma mark - EMChatManagerDelegate
/*!
 @method
 @brief 好友请求被接受时的回调
 @discussion
 @param username 之前发出的好友请求被用户username接受了
 */
- (void)didAcceptedByBuddy:(NSString *)username {
    //提示用户成功
    NSString *msg = [NSString stringWithFormat:@"%@同意了你的请求", username];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加成功" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:knowAction];
    [self presentViewController:alert animated:YES completion:nil];
}

/*!
 @method
 @brief 好友请求被拒绝时的回调
 @discussion
 @param username 之前发出的好友请求被用户username拒绝了
 */
- (void)didRejectedByBuddy:(NSString *)username {
    //提示用户被拒绝
    NSString *msg = [NSString stringWithFormat:@"%@拒绝了您的请求", username];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加失败" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:knowAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//响应 他人 添加好友请求
- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"好友的添加请求" message:message preferredStyle:UIAlertControllerStyleActionSheet];
    //两个Action
    //同意
    UIAlertAction *agree = [UIAlertAction actionWithTitle:@"Agree" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //回复给服务器
        [[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:nil];
    }];
    
    //拒绝
    UIAlertAction *reject = [UIAlertAction actionWithTitle:@"Reject" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //选择后的动作, 告诉服务器
        [[EaseMob sharedInstance].chatManager rejectBuddyRequest:username reason:@"不加陌生人" error:nil];
    }];
    [alert addAction:agree];
    [alert addAction:reject];
    
    //整合后弹出Alert
    [self presentViewController:alert animated:YES completion:nil];
}

//被好友删除, 正常不会监听的
- (void)didRemovedByBuddy:(NSString *)username {
    NSString *msg = [username stringByAppendingString:@"把你删除了"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"好友删除提醒" message:msg preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:knowAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversations.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"ConversationCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 获取会话对象
    EMConversation *conversation = self.conversations[indexPath.row];
    
    // 获取未读取消息数
    NSUInteger unreadCount = [conversation unreadMessagesCount];
    
    // 显示好友的名称
    cell.textLabel.text = [NSString stringWithFormat:@"%@ 未读消息数:%@",conversation.chatter,@(unreadCount)];
    
    // 显示最后聊天的内容
    // 1.获取消息体
    id msgBody = conversation.latestMessage.messageBodies[0];
    if ([msgBody isKindOfClass:[EMTextMessageBody class]]) {//文本消息
        EMTextMessageBody *textBody = msgBody;
        cell.detailTextLabel.text = textBody.text;
    }else if ([msgBody isKindOfClass:[EMVoiceMessageBody class]]){//语音
        EMVoiceMessageBody *voiceBody = msgBody;
        cell.detailTextLabel.text = voiceBody.displayName;
    }else if ([msgBody isKindOfClass:[EMImageMessageBody class]]){//图片
        EMImageMessageBody *imgBody = msgBody;
        cell.detailTextLabel.text = imgBody.displayName;
    }else{
        
        cell.detailTextLabel.text = @"未处理的消息类型";
    }
    return cell;
}

// 未读消息数的改变
-(void)didUnreadMessagesCountChanged{
    
    // 刷新表格
    [self.tableView reloadData];
    
    // 刷新Badge
    [self showTabbarItemBadge];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //进入聊天界面
    YLQChatPageViewController *chatVc = [[UIStoryboard storyboardWithName:@"MessageViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatPageStoryBoard"];
    
    // 获取会话对象
    EMConversation *conversation = self.conversations[indexPath.row];
    
    
    // 封装一个好友的模型
    EMBuddy *buddy = [EMBuddy buddyWithUsername:conversation.chatter];
    
    chatVc.buddy = buddy;
    
    [self.navigationController pushViewController:chatVc animated:YES];
    
    
}


-(void)dealloc{
    //移除代理
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

@end
