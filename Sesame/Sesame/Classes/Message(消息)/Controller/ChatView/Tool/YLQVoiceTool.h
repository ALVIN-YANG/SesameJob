//
//  YLQVoiceTool.h
//  集成环信SDK2.0
//
//  Created by 杨卢青 on 16/4/1.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLQVoiceTool : NSObject
// 播放语音
+(void)play:(EMVoiceMessageBody *)voiceBody label:(UILabel *)label isReceiver:(BOOL)receiver;
//停止播放
+(void)stop;
@end
