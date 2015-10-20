//
//  JRRequest.h
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-15.
//  Copyright (c) 2014年 JIRUI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRResponse.h"
/*
 * @brief 请求方式
 */
typedef enum{
  JRRequestMethodGET,
  JRRequestMethodPOST
} JRRequestMethod;

/*
 * @brief 返回数据格式
 */
typedef enum{
  JRResponseTypeText,
  JRResponseTypeJSON,
  JRResponseTypeXML
} JRResponseType;

/*
 * @brief THRequestDelegate
 */
@class JRRequest;
@protocol JRRequestDelegate <NSObject>
//请求失败回调
- (void)requestFailed:(JRRequest *)request error:(NSError *)error;
//请求完成回调
- (void)requestFinished:(JRRequest *)request response:(JRResponse *)response;
@end

/*
 * @brief THRequest Block
 */
typedef void(^THRequestFailedBlock) (JRRequest *item, NSError *error);
typedef void(^THRequestFinishedBlock) (JRRequest *item, JRResponse *response);

/*
 * @brief THRequest
 */
@interface JRRequest : NSObject
//是否正在加载数据
@property (nonatomic,readonly) BOOL isLoading;
//请求方法，如：GET、POST
@property (nonatomic) JRRequestMethod method;
//请求路径url
@property (nonatomic,copy) NSString *url;
//请求参数
@property (nonatomic,strong) NSDictionary *params;

//请求结束回调代理
@property (nonatomic,weak) id<JRRequestDelegate> delegate;
//请求标识，可以根据key来识别请求项，取消请求等
@property (nonatomic,copy) NSString *key;
//请求失败回调
@property (nonatomic,copy) THRequestFailedBlock failedBlock;
//请求完成回调
@property (nonatomic,copy) THRequestFinishedBlock finishedBlock;



/*
 * @brief 初始化
 */
- (JRRequest *)initWithMethod:(JRRequestMethod)method
                          url:(NSString *)url
                       params:(NSDictionary *)params
                     delegate:(id<JRRequestDelegate>)delegate
                          key:(NSString *)key;

/*
 * @brief 初始化
 */
- (JRRequest *)initWithMethod:(JRRequestMethod)method
                          url:(NSString *)url
                       params:(NSDictionary *)params
                          key:(NSString *)key
                       failed:(THRequestFailedBlock)failedBlock
                     finished:(THRequestFinishedBlock)finishedBlock;

/*
 * @brief 发送请求
 */
- (void)startRequest;

/*
 * @brief 取消请求
 */
- (void)cancelRequest;

@end





























