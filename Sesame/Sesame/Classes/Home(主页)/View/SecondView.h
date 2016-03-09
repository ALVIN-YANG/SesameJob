//
//  SecondView.h
//  Sesame
//
//  Created by 杨卢青 on 16/3/8.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SecondViewDelegate <NSObject>

- (void)fastJobButtonClick;
- (void)miaoJobButtonClick;
- (void)nearJobButtonClick;
- (void)travelJobButtonClick;

@end
@interface SecondView : UIView

/**delegate*/
@property (nonatomic, strong) id<SecondViewDelegate> delegate;

@end
