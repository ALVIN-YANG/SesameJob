//
//  YLQContactsViewController.m
//  集成环信SDK2.0
//
//  Created by 杨卢青 on 16/3/31.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "YLQContactsViewController.h"
#import <EaseMob.h>
#import "YLQChatPageViewController.h"
#import "YLQAddContactsView.h"

@interface YLQContactsViewController()<EMChatManagerDelegate>
@property (nonatomic, strong) NSArray *buddyList;
@end

@implementation YLQContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    
    //1.先从本地数据库获取好友数据
    NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
    self.buddyList = buddyList;
    
#warning 一定不要忘了设置代理
    // 添加chatManager的代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    //AppDelegate中已经开启了自动获取好友列表, 所以下列代码不用
    //2.如果本地没有数据, 就从网络获取, 并且保存到数据库
//    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
//        if (!error) {
//            self.buddyList = buddyList;
//            //刷新表格
//            [self.tableView reloadData];
//        } else {
//            NSLog(@"获取好友列表失败 %@", error);
//        }
//    } onQueue:nil];
//    NSLog(@"%@", buddyList);
}

- (void)setNavigation
{
    self.navigationItem.title = @"雇主列表";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"添加雇主" forState:UIControlStateNormal];
    //Custom必须设置颜色
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(jumpToAddFriends) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btn]];
}

- (void)jumpToAddFriends
{
    YLQAddContactsView *addVC = [[UIStoryboard storyboardWithName:NSStringFromClass([YLQAddContactsView class]) bundle:nil] instantiateInitialViewController];
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.buddyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuddyCell"];
    EMBuddy *buddy = self.buddyList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"雇主 : %@", buddy.username];
    cell.tintColor = [UIColor orangeColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //sender会传到下面
//    EMBuddy *buddy = self.buddyList[indexPath.row];
//
//    YLQChatPageViewController *chatVC = [[YLQChatPageViewController alloc] init];
//    chatVC.buddy = buddy;
//    [self.navigationController pushViewController:chatVC animated:YES];
    //sender会传到下面
    EMBuddy *buddy = self.buddyList[indexPath.row];
    [self performSegueWithIdentifier:@"ChatPageSegue" sender:buddy];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destVC = segue.destinationViewController;
    if ([destVC isKindOfClass:[YLQChatPageViewController class]]) {
        YLQChatPageViewController *chatVC = destVC;
        chatVC.buddy = sender;
    }
}

//编辑cell
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //获取要删除的好友的名字
    EMBuddy *buddy = self.buddyList[indexPath.row];
    //调用删除Cell方法
    [[EaseMob sharedInstance].chatManager removeBuddy:buddy.username removeFromRemote:YES error:nil];
}


#pragma mark - EMChatManagerDelegate
//被好友删除时
- (void)didRemovedByBuddy:(NSString *)username {
    [self fetchBuddyListFromServer];
}

//好友同意添加时
- (void)didAcceptedByBuddy:(NSString *)username {
    [self fetchBuddyListFromServer];
}

- (void)fetchBuddyListFromServer {
    //从服务器获取最新列表, 刷新
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (!error) {
            self.buddyList = buddyList;
            //刷新表格
            [self.tableView reloadData];
        } else {
            NSLog(@"获取好友列表失败 %@", error);
        }
    } onQueue:nil];
}

//删除时会调用此方法
- (void)didUpdateBuddyList:(NSArray *)buddyList changedBuddies:(NSArray *)changedBuddies isAdd:(BOOL)isAdd {
    //刷新表格
//    NSLog(@"执行删除");
    self.buddyList = buddyList;
    [self.tableView reloadData];
}

-(void)dealloc{
    //移除代理
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}
@end
