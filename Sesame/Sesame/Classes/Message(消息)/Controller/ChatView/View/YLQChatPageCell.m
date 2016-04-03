//
//  YLQChatPageCell.m
//  集成环信SDK2.0
//
//  Created by 杨卢青 on 16/4/1.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "YLQChatPageCell.h"
#import "YLQVoiceTool.h"
#import <UIImageView+WebCache.h>

@interface YLQChatPageCell()
/** 显示聊天图片的控件*/
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation YLQChatPageCell

#pragma mark - lazyLoad

-(UIImageView *)imgView{
    if(!_imgView){
        _imgView = [[UIImageView alloc] init];
    }
    
    return _imgView;
}


- (void)awakeFromNib {
    // 添加Label的手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(msgLabelClick:)];
    [self.chatLabel addGestureRecognizer:tap];
}

- (void)msgLabelClick:(UITapGestureRecognizer *)tap {
    
    
    // 只有语音消息，才要播放
    id msgBody = self.message.messageBodies[0];
    if ([msgBody isKindOfClass:[EMVoiceMessageBody class]]) {
        NSLog(@"播放语音");
        BOOL isReceiver = [self.reuseIdentifier isEqualToString:ReceiverCellID];
        [YLQVoiceTool play:msgBody label:self.chatLabel isReceiver:isReceiver];
        NSLog(@"调用完毕");
    }
}

- (CGFloat)getCellHeight {
    //重新布局
    [self layoutIfNeeded];
    
    return 20 + self.chatLabel.bounds.size.height + 23;
}

- (void)setMessage:(EMMessage *)message {
    _message = message;
    
    // 移除图片控件
    [self.imgView removeFromSuperview];
    //获取消息体 (类型不确定)
    id msgBody = message.messageBodies[0];
    //文本消息
    if ([msgBody isKindOfClass:[EMTextMessageBody class]]) {
        EMTextMessageBody *textBody = msgBody;
        self.chatLabel.text = textBody.text;
    } else if ([msgBody isKindOfClass:[EMVoiceMessageBody class]]) {
        //语音消息
        [self showVoice:msgBody];
    }else if([msgBody isKindOfClass:[EMImageMessageBody class]]){//图片消息
        [self showImage:msgBody];
    }else{// 其它消息
        self.chatLabel.text = @"其他消息";
    }
}

- (void)showVoice:(EMVoiceMessageBody *)voiceBody {
    BOOL isReceiver = [self.reuseIdentifier isEqualToString:ReceiverCellID];
    
    // 可变的富文本
    NSMutableAttributedString *attStrM = [[NSMutableAttributedString alloc] init];
    
    // 时长
    NSString *timeStr = [NSString stringWithFormat:@"%ld'",voiceBody.duration];
    NSAttributedString *timeAtt = [[NSAttributedString alloc] initWithString:timeStr];
    
    // 图片
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.bounds = CGRectMake(0, -6, 25, 25);
    NSAttributedString *imgAtt = [NSAttributedString attributedStringWithAttachment:attach];
    if (isReceiver) {
        // 接收方：图片 + 时长
        // 图片
        attach.image = [UIImage imageNamed:@"chat_receiver_audio_playing_full"];
        [attStrM appendAttributedString:imgAtt];
        
        
        [attStrM appendAttributedString:timeAtt];
        
    }else{
        
        // 发送方：时长 + 图片
        // 时长
        [attStrM appendAttributedString:timeAtt];
        
        attach.image = [UIImage imageNamed:@"chat_sender_audio_playing_full"];
        [attStrM appendAttributedString:imgAtt];
        
    }
    
    
    self.chatLabel.attributedText = attStrM;
    

}

-(void)showImage:(EMImageMessageBody *)msgBody{
    
    // 设置Label的bounds
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.bounds = CGRectMake(0, 0, msgBody.size.width * 0.05, msgBody.size.height * 0.05);
    NSAttributedString *attStr= [NSAttributedString attributedStringWithAttachment:attach];
    self.chatLabel.attributedText = attStr;
    
    // 显示图片
    
    // 如果本地图片不存在，就从服务器下载显示
    if (![[NSFileManager defaultManager] fileExistsAtPath:msgBody.thumbnailLocalPath]) {
        NSURL *remoteURL = [NSURL URLWithString:msgBody.thumbnailRemotePath];
        [self.imgView sd_setImageWithURL:remoteURL placeholderImage:[UIImage imageNamed:@"downloading"]];
    }else{
        self.imgView.image = [UIImage imageWithContentsOfFile:msgBody.thumbnailLocalPath];
    }
    
    // 设置imgView的frm
    self.imgView.frame = CGRectMake(0, 0, msgBody.size.width * 0.05, msgBody.size.height * 0.05);
    
    // 2.把UIImageView添加Label
    [self.chatLabel addSubview:self.imgView];
    
}

@end
