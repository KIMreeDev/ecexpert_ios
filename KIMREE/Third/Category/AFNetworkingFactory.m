//
//  AFNetworkingFactory.m
//  ECExpert
//
//  Created by Fran on 15/6/2.
//  Copyright (c) 2015年 Fran. All rights reserved.
//

#import "AFNetworkingFactory.h"

@implementation AFNetworkingFactory

+ (AFHTTPRequestOperationManager *)networkingManager{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager.requestSerializer setTimeoutInterval:10];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];// 默认的acceptableContentTypes缺少 text/html, 可以到 AFJSONResponseSerializer 代码223行查看
    return manager;
}

@end
