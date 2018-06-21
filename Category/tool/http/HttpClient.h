//
//  HttpClient.h
//  Category
//
//  Created by long on 2018/1/16.
//  Copyright © 2018年 long. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPSessionManager;

static NSString *const kBaseURLString = @"http://mapi.meishichina.com/";

@interface HttpClient : NSObject

+ (instancetype)sharedClient;

@property (nonatomic, strong, readonly) AFHTTPSessionManager *manager;

@end
