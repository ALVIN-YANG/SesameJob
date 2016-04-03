//
//  YLQVoiceTool.m
//  集成环信SDK2.0
//
//  Created by 杨卢青 on 16/4/1.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "YLQVoiceTool.h"
#import "EMCDDeviceManager.h"

//类对象, 用
static UIImageView *animatingImageView = nil;

@implementation YLQVoiceTool
+(void)play:(EMVoiceMessageBody *)voiceBody label:(UILabel *)label isReceiver:(BOOL)receiver{
    
    // 把以前的动画取消
    [animatingImageView removeFromSuperview];
    
    // 1.播放语音
    // 获取语音文件路径
    
    
    NSString *voicePath = voiceBody.localPath;
    // 如果本地的语音文件不存在，就要播放远程语音
    if (![[NSFileManager defaultManager] fileExistsAtPath:voicePath]) {
        voicePath = voiceBody.remotePath;
    }
    
    
    [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:voicePath completion:^(NSError *error) {
        if (!error) {
            NSLog(@"语音播放完成");
//                        [animatingImageView stopAnimating];
            [animatingImageView removeFromSuperview];
        }else{
            NSLog(@"语音播放失败%@",error);
        }
    }];
    
    // 2.播放语音动画
    // 动画的图片
    UIImageView *animationImgView =  [[UIImageView alloc] init];
    CGFloat imH = label.bounds.size.height;
    CGFloat imW = imH;
    CGFloat imgY = 0;
    CGFloat imgX = 0;
    
    if (receiver) {
        animationImgView.animationImages = @[
                                             [UIImage imageNamed:@"chat_receiver_audio_playing000"],
                                             [UIImage imageNamed:@"chat_receiver_audio_playing001"],
                                             [UIImage imageNamed:@"chat_receiver_audio_playing002"],
                                             [UIImage imageNamed:@"chat_receiver_audio_playing003"]
                                             ];
    }else{
        animationImgView.animationImages =  @[
                                              [UIImage imageNamed:@"chat_sender_audio_playing_000"],
                                              [UIImage imageNamed:@"chat_sender_audio_playing_001"],
                                              [UIImage imageNamed:@"chat_sender_audio_playing_002"],
                                              [UIImage imageNamed:@"chat_sender_audio_playing_003"]
                                              ];
        
        imgX = label.bounds.size.width - imW;
    }
    animationImgView.frame = CGRectMake(imgX, imgY, imW, imH);
    animationImgView.animationDuration = 1;
    
    [label addSubview:animationImgView];
    
    [animationImgView startAnimating];
    
    // 给静态变量赋值
    animatingImageView = animationImgView;
    
}


+(void)stop{
    // 取消播放
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    
    // 移除动画
    [animatingImageView removeFromSuperview];
}

@end
