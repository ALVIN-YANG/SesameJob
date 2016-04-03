//
//  YLQChatPageCell.h
//  集成环信SDK2.0
//
//  Created by 杨卢青 on 16/4/1.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EaseMob.h>

static NSString *ReceiverCellID = @"ReceiveCell";
static NSString *SenderCellID= @"SenderCell";

@interface YLQChatPageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *chatLabel;
/**要从数据库取出会话记录的模型*/
@property (nonatomic, strong) EMMessage *message;
- (CGFloat)getCellHeight;
@end
