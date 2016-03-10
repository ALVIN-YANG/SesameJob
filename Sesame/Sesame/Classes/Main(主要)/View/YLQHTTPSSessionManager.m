//
//  YLQHTTPSSessionManager.m
//  01-BS搭建
//
//  Created by 杨卢青 on 16/2/15.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "YLQHTTPSSessionManager.h"

@implementation YLQHTTPSSessionManager
- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration{
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
        //设置请求头
//        [self.requestSerializer setValue:@"iPhone7" forHTTPHeaderField:@"device"];
//        [self.requestSerializer setValue:@"9.2" forHTTPHeaderField:@"version"];
    }
    return self;
}
@end
