//
//  HttpClient.m
//  Category
//
//  Created by long on 2018/1/16.
//  Copyright © 2018年 long. All rights reserved.
//

#import "HttpClient.h"
#import <AFNetworking/AFNetworking.h>

@interface HttpClient ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation HttpClient

+ (instancetype)sharedClient {
    static HttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HttpClient alloc] init];
    });
    
    return _sharedClient;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLString]];
        
        self.manager.requestSerializer.timeoutInterval = 15.0f;
        
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
                
    }
    return self;
}

@end
