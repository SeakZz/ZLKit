//
//  FileTool.h
//  Category
//
//  Created by long on 2018/2/26.
//  Copyright © 2018年 long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileTool : NSObject

/** 获取缓存大小 */
+ (void)getFileSizeOfCache:(void (^)(long long size))completion;
+ (long long)fileSizeOfCache;

/** 清理缓存 */
+ (void)clearCacheWithCompletion:(void (^)(BOOL isSuccess))completion;

/** 获取指定路径文件大小 */
+ (long long)fileSizeAtPath:(NSString*)filePath;

@end
