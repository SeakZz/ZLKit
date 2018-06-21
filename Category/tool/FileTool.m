//
//  FileTool.m
//  Category
//
//  Created by long on 2018/2/26.
//  Copyright © 2018年 long. All rights reserved.
//

#import "FileTool.h"
#import <SDWebImage/SDImageCache.h>

@implementation FileTool

+ (void)getFileSizeOfCache:(void (^)(long long size))completion {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        long long s = [self fileSizeOfCache];
        
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(s);
            });
        }
    });
}

+ (void)clearCacheWithCompletion:(void (^)(BOOL isSuccess))completion {
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self zl_clearCache];
        
        dispatch_group_leave(group);
    });
    
    [[SDImageCache sharedImageCache] clearMemory];
    dispatch_group_enter(group);
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (completion) completion(YES);
    });
}


+ (long long)fileSizeOfCache {
    NSString *filePath = NSTemporaryDirectory();
    NSFileManager *fileManager = [NSFileManager defaultManager];

    //是否为文件
    BOOL isFile = NO;
    //判断文件或文件夹是否存在(也就是判断filePath是否是一个正确的路径)
    BOOL isExist = [fileManager fileExistsAtPath:filePath isDirectory:&isFile];

    if (!isExist) {
        return 0;
    }
    
    //遍历文件夹中的所有内容
    NSArray *subPaths = [fileManager subpathsAtPath:filePath];
    NSUInteger totalBytes = 0;
    for (NSString *subPath in subPaths) {
        //获取全路径 (文件夹下的全部内容的路径)
        NSString *fullPath = [filePath stringByAppendingString:[NSString stringWithFormat:@"/%@", subPath]];
        BOOL dir = NO;
        [fileManager fileExistsAtPath:fullPath isDirectory:&dir];
        
        NSInteger iSize = 0;
        //是文件就计算大小,注意文件夹是没有大小的所以就不用计算了
        if (!dir) {
            iSize = [[fileManager attributesOfItemAtPath:fullPath error:nil][NSFileSize] integerValue];
            totalBytes += iSize;
        }
    }
    
    totalBytes += [[SDImageCache sharedImageCache] getSize];
    
    return totalBytes;
}

+ (BOOL)zl_clearCache {
    NSString *filePath = NSTemporaryDirectory();
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //是否为文件
    BOOL isFile = NO;
    //判断文件或文件夹是否存在(也就是判断filePath是否是一个正确的路径)
    BOOL isExist = [fileManager fileExistsAtPath:filePath isDirectory:&isFile];
    
    if (!isExist) {
        return YES;
    }
    
    //遍历文件夹中的所有内容
    NSArray *subPaths = [fileManager subpathsAtPath:filePath];
    for (NSString *subPath in subPaths) {
        //获取全路径 (文件夹下的全部内容的路径)
        NSString *fullPath = [filePath stringByAppendingString:[NSString stringWithFormat:@"/%@", subPath]];
        BOOL dir = NO;
        [fileManager fileExistsAtPath:fullPath isDirectory:&dir];
        
        BOOL com = [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
        if (!com) {
            return NO;
        }
    }
    
    return YES;
}


+ (long long)fileSizeAtPath:(NSString*)filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

@end
