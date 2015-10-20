//
//  AppServer.m
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-16.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppServer.h"
#import "ArchiveServer.h"

static AppServer *instance;

@implementation AppServer
- (id)init
{
  self = [super init];
  if (self) {
    ;
  }
  return self;
}
+ (AppServer *)sharedInstance
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[AppServer alloc] init];
  });
  return instance;
}
- (AppInfoModel *)appInfo
{
  return [[ArchiveServer defaultArchiver] unarchiveWithKey:C_FILE_APP_INFO];
}
/*
 * @brief 第一次打开App请求一个用户uid
 */
- (void)registerUidWithFailed:(void (^)(NSString *msg))failed
                     finished:(void (^)(NSString *uid))finished
{
  [[JRRequestManager shareInstance]
   startRequestWithCmd:API_CMD_APP_REGISTER
   method:JRRequestMethodPOST
   params:nil
   key:API_CMD_APP_REGISTER
   failed:^(JRRequest *request,NSError *error){
     //请求出错
     failed([error localizedDescription]);
       
   }
   finished:^(JRRequest *request,JRResponse *response){
     //请求完成
     if (!response.code) {
       failed(response.msg);
     }
     else{
       NSString *uid = [response.data valueForKey:@"uid"];
       finished(uid);
     }
   }];
}

/*
 * @brief 获取基本信息
 */
- (void)appInfoWithFailed:(void (^)(NSString *msg))failed
                 finished:(void (^)(AppInfoModel *appInfo))finished
{
  [[JRRequestManager shareInstance]
   startRequestWithCmd:API_CMD_APP_INFO
   method:JRRequestMethodPOST
   params:nil
   key:API_CMD_APP_INFO
   failed:^(JRRequest *request,NSError *error){
     //请求出错
     failed([error localizedDescription]);
   }
   finished:^(JRRequest *request,JRResponse *response){
     //请求完成
     if (!response.code) {
       failed(response.msg);
     }
     else{
       AppInfoModel *appInfo = [[AppInfoModel alloc] init];
       [appInfo loadData:response.data];
       finished(appInfo);
       [[ArchiveServer defaultArchiver] archiveObject:appInfo key:C_FILE_APP_INFO];
     }
   }];
}

- (void)reportToken:(NSString *)token
             status:(NSNumber *)status
             failed:(void (^)(NSString *msg))failed
           finished:(void (^)(void))finished
{
  [[JRRequestManager shareInstance]
   startRequestWithCmd:API_CMD_APP_UPLOAD_TOKEN
   method:JRRequestMethodPOST
   params:@{@"client_id":token,@"status":status}
   key:API_CMD_APP_UPLOAD_TOKEN
   failed:^(JRRequest *request,NSError *error){
     failed([error localizedDescription]);
   }
   finished:^(JRRequest *request,JRResponse *response){
     if (!response.code) {
       failed(response.msg);
     }
     else{
       finished();
     }
   }];
}

/*
 * @brief 用户反馈
 */
- (void)feedbackWithContent:(NSString *)content
                    contact:(NSString *)contact
                     failed:(void (^)(NSString *msg))failed
                   finished:(void (^)(void))finished
{
  [[JRRequestManager shareInstance]
   startRequestWithCmd:API_CMD_APP_FEEDBACK
   method:JRRequestMethodPOST
   params:@{@"sContent":content,@"sContact":contact}
   key:API_CMD_APP_FEEDBACK
   failed:^(JRRequest *request,NSError *error){
     failed([error localizedDescription]);
   }
   finished:^(JRRequest *request,JRResponse *response){
     if (!response.code) {
       failed(response.msg);
     }
     else{
       finished();
     }
   }];
}
@end
