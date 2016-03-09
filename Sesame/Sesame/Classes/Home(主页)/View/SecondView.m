//
//  SecondView.m
//  Sesame
//
//  Created by 杨卢青 on 16/3/8.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "SecondView.h"
#import "FastJobViewController.h"

@interface SecondView()
@property (weak, nonatomic) IBOutlet UIButton *ButtonOne;
@property (weak, nonatomic) IBOutlet UIButton *ButtonTwo;
@property (weak, nonatomic) IBOutlet UIButton *ButtonThree;
@property (weak, nonatomic) IBOutlet UIButton *ButtonFour;


@end
@implementation SecondView
- (void)awakeFromNib{

}


- (IBAction)ButtonOneClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(fastJobButtonClick)]) {
        [self.delegate fastJobButtonClick];
    }
}

- (IBAction)ButtonTwoClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(miaoJobButtonClick)]) {
        [self.delegate miaoJobButtonClick];
    }
}

- (IBAction)ButtonThreeClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(nearJobButtonClick)]) {
        [self.delegate nearJobButtonClick];
    }
}

- (IBAction)ButtonFourClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(travelJobButtonClick)]) {
        [self.delegate travelJobButtonClick];
    }
}
@end
