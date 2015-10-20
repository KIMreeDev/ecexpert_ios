//
//  AppServer.h
//  haitaotong
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-16.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AppInfoModel.h"

@interface AppServer : NSObject
+ (AppServer *)sharedInstance;
- (AppInfoModel *)appInfo;

/*
 * @brief 第一次打开App请求一个用户uid
 */
- (void)registerUidWithFailed:(void(^)(NSString *msg))failed
                     finished:(void(^)(NSString *uid))finished;

/*
 * @brief 获取基本信息
 */
- (void)appInfoWithFailed:(void(^)(NSString *msg))failed
                  finished:(void(^)(AppInfoModel *appInfo))finished;
/*
 * @brief 上传Push Token
 */
- (void)reportToken:(NSString *)token
             status:(NSNumber *)status
             failed:(void(^)(NSString *msg))failed
           finished:(void(^)(void))finished;
/*
 * @brief 用户提交反馈信息
 * @param content 反馈信息
 * @param contact 用户联系方式
 */
- (void)feedbackWithContent:(NSString *)content
                    contact:(NSString *)contact
                     failed:(void(^)(NSString *msg))failed
                   finished:(void(^)(void))finished;
@end
