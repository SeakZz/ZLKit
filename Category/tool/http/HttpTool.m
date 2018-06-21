//
//  HttpTool.m
//  Category
//
//  Created by long on 2018/1/10.
//  Copyright © 2018年 long. All rights reserved.
//

#import "HttpTool.h"
#import "HttpClient.h"

@implementation HttpTool

#pragma mark - request
+ (NSURLSessionDataTask *)GET:(NSString *)urlString
                       params:(NSDictionary *)params
                      success:(HttpSuccessBlock)success
                      failure:(HttpFailureBlock)failure {
    return [[HttpClient sharedClient].manager GET:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (NSURLSessionDataTask *)POST:(NSString *)urlString
                        params:(NSDictionary *)params
                       success:(HttpSuccessBlock)success
                       failure:(HttpFailureBlock)failure {
    return [[HttpClient sharedClient].manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)cancelAllRequest {
    [[HttpClient sharedClient].manager.tasks enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cancel];
    }];
}


#pragma mark - download
+ (NSURLSessionDownloadTask *)download:(NSString *)urlString
                              filePath:(NSString *)path
                              progress:(void (^)(NSProgress *downloadProgress))progress
                            completion:(HttpDownloadCompletionBlock)completion {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSessionDownloadTask *downloadTask = [[HttpClient sharedClient].manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) progress(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (!path) {
            NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSString *fullpath = [caches stringByAppendingPathComponent:urlString.lastPathComponent];
            return [NSURL fileURLWithPath:fullpath];
        }
        
        NSURL *filePathUrl = [NSURL fileURLWithPath:path];
        return filePathUrl;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        if (error) {
            if (completion) completion(NO, nil, error);
            return ;
        }
        
        if (filePath) {
            if (completion) completion(YES, filePath, nil);
        }
    }];
    
    [downloadTask resume];
    return downloadTask;
}

#pragma mark - networkreachability
+ (void)setReachabilityStatusChangeBlock:(void (^)(AFNetworkReachabilityStatus status))block {
    AFHTTPSessionManager *manager = [HttpClient sharedClient].manager;
    
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (block) block(status);
    }];
    
    [manager.reachabilityManager startMonitoring];
}
+ (BOOL)isNetworking {
    return [HttpClient sharedClient].manager.reachabilityManager.isReachable;
}
+ (AFNetworkReachabilityStatus)networkReachabilityStatus {
    return [HttpClient sharedClient].manager.reachabilityManager.networkReachabilityStatus;
}

@end
