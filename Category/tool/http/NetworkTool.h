//
//  NetworkTool.h
//  Category
//
//  Created by long on 2018/1/19.
//  Copyright © 2018年 long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Reachability/Reachability.h>

typedef void (^NetworkStatusBlock)(NetworkStatus status);

@interface NetworkTool : NSObject

/** 监听网络状态 */
+ (void)listeningNetworkStatus;

/** 监听网络状态 */
+ (void)listeningNetworkStatus:(NetworkStatusBlock)status;

/** 当前网络状态 */
+ (NetworkStatus)currentStatus;

@end
