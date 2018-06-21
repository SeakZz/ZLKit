//
//  HttpTool.h
//  Category
//
//  Created by long on 2018/1/10.
//  Copyright © 2018年 long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void (^HttpSuccessBlock) (id response);
typedef void (^HttpFailureBlock) (NSError *error);

typedef void (^HttpDownloadCompletionBlock) (BOOL isSuccess, NSURL *pathURL, NSError *error);

@interface HttpTool : NSObject

/** get请求 */
+ (NSURLSessionDataTask *)GET:(NSString *)urlString
                       params:(NSDictionary *)params
                      success:(HttpSuccessBlock)success
                      failure:(HttpFailureBlock)failure;

/** post请求 */
+ (NSURLSessionDataTask *)POST:(NSString *)urlString
                        params:(NSDictionary *)params
                       success:(HttpSuccessBlock)success
                       failure:(HttpFailureBlock)failure;

/** 取消所有请求 */
+ (void)cancelAllRequest;


/**
 下载文件

 @param urlString 文件地址
 @param path 下载到本地路径 (传nil 返回默认路径)
 @param progress 下载进度
 @param completion 下载完成 成功返NSURL 失败返NSError
 @return 本次下载任务
 */
+ (NSURLSessionDownloadTask *)download:(NSString *)urlString
                              filePath:(NSString *)path
                              progress:(void (^)(NSProgress *downloadProgress))progress
                            completion:(HttpDownloadCompletionBlock)completion;


/** 监听网络状态变化 */
+ (void)setReachabilityStatusChangeBlock:(void (^)(AFNetworkReachabilityStatus status))block;
/** 判断是否有网络 (监听之后调用) */
+ (BOOL)isNetworking;
/** 判断网络类型 (监听之后调用) */
+ (AFNetworkReachabilityStatus)networkReachabilityStatus;

@end
