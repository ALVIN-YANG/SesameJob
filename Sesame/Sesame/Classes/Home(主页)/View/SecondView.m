//
//  SecondView.m
//  Sesame
//
//  Created by 杨卢青 on 16/3/8.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "SecondView.h"

@interface SecondView()
@property (weak, nonatomic) IBOutlet UIButton *ButtonOne;
@property (weak, nonatomic) IBOutlet UIButton *ButtonTwo;
@property (weak, nonatomic) IBOutlet UIButton *ButtonThree;
@property (weak, nonatomic) IBOutlet UIButton *ButtonFour;

@end
@implementation SecondView



- (IBAction)ButtonOneClick:(id)sender {
    YLQLog(@"点击了第一个Button");
}

- (IBAction)ButtonTwoClick:(id)sender {
    YLQLog(@"点击了第二个Button");
}

- (IBAction)ButtonThreeClick:(id)sender {
    YLQLog(@"点击了第三个Button");
}

- (IBAction)ButtonFourClick:(id)sender {
    YLQLog(@"点击了第四个Button");
}
@end
