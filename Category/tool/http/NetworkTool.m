//
//  NetworkTool.m
//  Category
//
//  Created by long on 2018/1/19.
//  Copyright © 2018年 long. All rights reserved.
//

#import "NetworkTool.h"

static NSString *const kHostName = @"www.baidu.com";

@interface NetworkTool ()

@property (nonatomic, strong) Reachability *reachability;

@property (nonatomic, copy) NetworkStatusBlock statusBlock;

@end


@implementation NetworkTool

+ (instancetype)sharedManager {
    static NetworkTool *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[NetworkTool alloc] init];
    });
    return _manager;
}

+ (void)listeningNetworkStatus {
    [[self sharedManager] _listeningNetworkStatus:nil];
}

+ (void)listeningNetworkStatus:(NetworkStatusBlock)status {
    [[self sharedManager] _listeningNetworkStatus:status];
}

+ (NetworkStatus)currentStatus {
    return [NetworkTool sharedManager].reachability.currentReachabilityStatus;;
}


- (void)_listeningNetworkStatus:(NetworkStatusBlock)status {
    if (status) self.statusBlock = [status copy];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityChanged:)
                                                 name:kReachabilityChangedNotification object:nil];
    self.reachability = [Reachability reachabilityWithHostName:kHostName];
    [self.reachability startNotifier];
}


- (void)networkReachabilityChanged:(NSNotification* )notify {
    Reachability* curReach = [notify object];
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (self.statusBlock) self.statusBlock(status);
}


@end
