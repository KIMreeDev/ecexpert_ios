//
//  ErrorHelper.m
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-18.
//  Copyright (c) 2014年 JIRUI. All rights reserved.
//

#import "ErrorHelper.h"

@implementation ErrorHelper
+ (NSString *)messageWithCode:(NSInteger)code
{
  NSString *msg = @"未知错误";
  switch (code) {
    case ERROR_CODE_SUCCESS:
//          msg = NSLocalizedString(@"Success", nil);
          msg = @"";
      break;
    case ERROR_CODE_CONNECT_FAILED:
      msg = NSLocalizedString(@"No Internet connection", nil) ;
      break;
    case ERROR_CODE_CONNECT_TIMEOUT:
      msg = NSLocalizedString(@"Connection timeout, please try again later.", nil) ;
      break;
//    case ERROR_CODE_API_FAILED:
//      msg = @"接口出错";
//      break;
//    case ERROR_CODE_NULL:
//      msg = @"返回数据格式错误";
    default:
      break;
  }
  return msg;
}

+ (NSString *)messageWithData:(NSString *)data AndCode:(NSInteger)code
{
    NSString *msg = @"未知错误";
    
    switch (code) {
        case ERROR_CODE_SUCCESS:
            msg = @"";
            break;
        case ERROR_CODE_CONNECT_TIMEOUT:
            msg = NSLocalizedString(@"Connection timeout, please try again later.", nil) ;
            break;
        default:
            break;
    }
    
    if (code == 0) {
        if ([data isEqualToString:@"发帖失败。原因是：SESSION值与数据库中不一致"]||
            [data isEqualToString:@"删帖失败。原因是：SESSION值与数据库中不一致"]||
            [data hasPrefix:@"回帖失败。原因是：SESSION值与数据库中不一致.数据库内是"]) {
            msg = NSLocalizedString(@"Login has expired, please login again",nil);
            //注销本地登录
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:API_LOGIN_SID];
            [[LocalStroge sharedInstance] deleteFileforKey:F_USER_INFORMATION filePath:NSDocumentDirectory];
        }
        
        if ([data hasPrefix:@"发帖失败。原因是Duplicate entry"]) {
            msg = NSLocalizedString(@"Topics that are repeated, please modify the theme", nil);
            THLog(@"msg = %@", msg);
        }
    }
    
    return msg;
}
@end
