//
//  FileCacheManager.h
//  01-BS搭建
//
//  Created by 杨卢青 on 16/1/22.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileCacheManager : NSObject
/**
 *  计算文件夹的尺寸
 *
 *  @param directoriesPath 文件路径
 *  @param completeBlock   计算完后回调block
 */
+ (void)getCacheSizeOfDirectoriesPath:(NSString *)directoriesPath completeBlock:(void(^)(NSInteger))completeBlock;

/**
 *  清空路径下的缓存
 *
 *  @param direstoriesPath 文件路径
 */
+ (void)removeDirectoriesPath:(NSString *)directoriesPath;
@end
