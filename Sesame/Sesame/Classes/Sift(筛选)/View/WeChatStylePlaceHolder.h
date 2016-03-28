//
//  WeChatStylePlaceholder.h
//  Sesame
//
//  Created by 杨卢青 on 16/3/28.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeChatStylePlaceHolderDelegate <NSObject>

@required
- (void)emptyOverlayClicked:(id)sender;

@end

@interface WeChatStylePlaceHolder : UIView

@property (nonatomic, weak) id<WeChatStylePlaceHolderDelegate> delegate;

@end
