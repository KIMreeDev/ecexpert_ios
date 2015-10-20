//
//  JRRequestManager.h
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-15.
//  Copyright (c) 2014年 JIRUI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRRequest.h"

@interface JRRequestManager : NSObject

/*
 * @brief 单例
 */
+ (JRRequestManager *) shareInstance;

/*
 * @brief 请求数据
 */
- (void)startRequestWithCmd:(NSString *)cmd
                     method:(JRRequestMethod)method
                     params:(NSDictionary *)params
                   delegate:(id<JRRequestDelegate>)delegate
                        key:(NSString *)key;

/*
 * @brief 请求数据
 */
- (void)startRequestWithUrl:(NSString *)url
                     method:(JRRequestMethod)method
                     params:(NSDictionary *)params
                        key:(NSString *)key
                     failed:(THRequestFailedBlock)failedBlock
                   finished:(THRequestFinishedBlock)finishedBlock;

/*
 * @brief 请求数据
 */
- (void)startRequestWithCmd:(NSString *)cmd
                     method:(JRRequestMethod)method
                     params:(NSDictionary *)params
                        key:(NSString *)key
                     failed:(THRequestFailedBlock)failedBlock
                   finished:(THRequestFinishedBlock)finishedBlock;

/*
 * @brief 取消请求
 */
- (void)cancelRequestWithKey:(NSString *)key;

/*
 * @brief 根据key移除相应的请求项
 */
- (void)removeRequestItemWithKey:(NSString *)key;

@end
































