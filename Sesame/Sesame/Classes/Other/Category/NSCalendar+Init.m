//
//  NSCalendar+Init.m
//  01-BS搭建
//
//  Created by 杨卢青 on 16/2/14.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "NSCalendar+Init.h"

@implementation NSCalendar (Init)

//让真机可以调试??
+ (instancetype)ylq_calentar{
    if ([NSCalendar instancesRespondToSelector:@selector(calendarIdentifier)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [NSCalendar currentCalendar];
}
@end
