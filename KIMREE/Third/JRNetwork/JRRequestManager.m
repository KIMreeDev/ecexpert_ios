//
//  JRRequestManager.m
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-15.
//  Copyright (c) 2014年 JIRUI. All rights reserved.
//
#import "JRRequestManager.h"
#import "CJSONSerializer.h"
#import "AppHelper.h"
static JRRequestManager *manager;

@interface JRRequestManager ()
{
  NSMutableDictionary *items;
}
@end
@implementation JRRequestManager

//初始化
- (id)init
{
  self = [super init];
  if (self) {
    items = [[NSMutableDictionary alloc] init];
  }
  return self;
}
/*
 * @brief 单例
 */
+ (JRRequestManager *)shareInstance
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[JRRequestManager alloc] init];
  });
  return manager;
}
/*
 * @brief 请求数据
 */
- (void)startRequestWithCmd:(NSString *)cmd
                     method:(JRRequestMethod)method
                     params:(NSDictionary *)params
                   delegate:(id<JRRequestDelegate>)delegate
                        key:(NSString *)key
{
  //构造请求参数
  NSDictionary *data = [self params:params cmd:cmd];

  //构造请求项
  JRRequest *item = [[JRRequest alloc] initWithMethod:method url:API_POSTBAR_URL params:data delegate:delegate key:key];
  
  //保存请求信息
  [items setValue:item forKey:key];
  //发送请求
  [item startRequest];
}

/*
 * @brief 请求数据
 */
- (void)startRequestWithUrl:(NSString *)url
                     method:(JRRequestMethod)method
                     params:(NSDictionary *)params
                        key:(NSString *)key
                     failed:(THRequestFailedBlock)failedBlock
                   finished:(THRequestFinishedBlock)finishedBlock
{
  //构造请求项
  JRRequest *item = [[JRRequest alloc] initWithMethod:method url:url params:params key:key failed:failedBlock finished:finishedBlock];
  
    if (items.count) {
        for (NSString *keyStr in items.allKeys) {
            [self cancelRequestWithKey:keyStr];
        }
    }
  //保存请求信息
  [items setValue:item forKey:key];
  //发送请求
  [item startRequest];
}

/*
 * @brief 请求数据
 */
- (void)startRequestWithCmd:(NSString *)cmd
                     method:(JRRequestMethod)method
                     params:(NSDictionary *)params
                        key:(NSString *)key
                     failed:(THRequestFailedBlock)failedBlock
                   finished:(THRequestFinishedBlock)finishedBlock
{
  //构造请求参数 
  NSDictionary *data = [self params:params cmd:cmd];
  
  //构造请求项
  JRRequest *item = [[JRRequest alloc] initWithMethod:method url:API_POSTBAR_URL params:data key:key failed:failedBlock finished:finishedBlock];
    if (items.count) {
        for (NSString *keyStr in items.allKeys) {
            [self cancelRequestWithKey:keyStr];
        }
    }
  //保存请求信息
  [items setValue:item forKey:key];
    
  //发送请求
  [item startRequest];

}
/*
 * @brief 取消请求
 */
- (void)cancelRequestWithKey:(NSString *)key
{
  JRRequest *item = [items valueForKey:key];
  if (item) {
    [item cancelRequest];
    item.delegate = nil;
    [items removeObjectForKey:key];
  }
  else{
    THLog(@"no such request with key=%@",key);
  }
}
/*
 * @brief 根据key移除相应的请求项
 */
- (void)removeRequestItemWithKey:(NSString *)key
{
  JRRequest *item = [items valueForKey:key];
  if (item) {
    item.delegate = nil;
    [items removeObjectForKey:key];
  }
  else{
    THLog(@"no such request with key=%@",key);
  }
}

//构造请求参数
- (NSDictionary *)params:(NSDictionary *)params cmd:(NSString *)cmd
{
  AppHelper *appHelper = [AppHelper sharedInstance];
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
  [dict setValue:@"iphone" forKey:@"qua"];
  [dict setValue:@(API_VER) forKey:@"ver"];
  [dict setValue:appHelper.uid forKey:@"uid"];
  if (appHelper.sid) {
    [dict setValue:appHelper.sid forKey:@"sid"];
  }
  [dict setValue:cmd forKey:@"cmd"];
  if (params) {
    [dict setValue:params forKey:@"param"];
  }
  THLog(@"data:%@",dict);
  NSData *data = [[CJSONSerializer serializer] serializeDictionary:dict error:nil];
  NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

  return @{@"data":str};
}

@end





















