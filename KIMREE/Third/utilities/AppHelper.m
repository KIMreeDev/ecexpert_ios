//
//  AppSettings.m
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-18.
//  Copyright (c) 2014年 JIRUI. All rights reserved.
//

#import "AppHelper.h"
#import "SystemHelper.h"

static AppHelper *_sharedInstance = nil;

@implementation AppHelper
@synthesize qua = _qua;
@synthesize uid = _uid;
@synthesize sid = _sid;
@synthesize imgPost = _imgPost;
+ (AppHelper *)sharedInstance
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedInstance = [[AppHelper alloc] init];
  });
  return _sharedInstance;
}

//qua
- (NSString *)qua
{
  NSString *str = F_UD_STR(UDK_QUA);
  if (str == nil) {
    str = [self configQua];
    [S_USER_DEFAULTS setObject:str forKey:UDK_QUA];
    [S_USER_DEFAULTS synchronize];
  }
  return str;
}
//构造设备标识
- (NSString *)configQua
{
  CGRect rect_screen = [[UIScreen mainScreen]bounds];
  NSString *wh = [NSString stringWithFormat:@"%dx%d", (int)rect_screen.size.width, (int)rect_screen.size.height];
  NSString *mac = [SystemHelper macaddress];
  if ([SystemHelper systemVersion] >= 7.0 || mac == nil) {
    mac = [S_USER_DEFAULTS objectForKey:@"UUIDForMac"];
    if (mac == nil) {
      mac = [SystemHelper uuid];
      [S_USER_DEFAULTS setObject:mac forKey:@"UUIDForMac"];
    }
  }
  NSString *qua = [NSString stringWithFormat:@"1|%f|%@|%@|%@|%@|%@|%@|%@|%@|%@|%lu", [SystemHelper systemVersion], [SystemHelper appName], [SystemHelper buildVersion], [SystemHelper currentLanguage], [SystemHelper currentTimeZone], wh, [[UIDevice currentDevice] model], [SystemHelper uniqueGlobalDeviceIdentifier], mac, CONFIG_CHANNEL, time(NULL)];
  return qua;
}

//uid
- (NSString *)uid
{
  NSString *str = [S_USER_DEFAULTS stringForKey:UDK_UID];
  if (str.length == 0) {
    str = @"0";
  }
  return str;
}

- (void)setUid:(NSString *)uid
{
  if (uid.length != 0) {
    [S_USER_DEFAULTS setObject:uid forKey:UDK_UID];
    [S_USER_DEFAULTS synchronize];
  }
}

//sid
- (NSString *)sid
{
  NSString *str = [S_USER_DEFAULTS stringForKey:UDK_SID];
  if (str.length == 0) {
    str = @"0";
  }
  return str;
}
- (void)setSid:(NSString *)sid
{
  if (sid.length != 0) {
    [S_USER_DEFAULTS setObject:sid forKey:UDK_SID];
    [S_USER_DEFAULTS synchronize];
  }
}
//帖子中的图片
- (NSString *)imgPost
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"selectedImage.png"];
    if ([fileMgr fileExistsAtPath:fullPath]) {
        return fullPath;
    }
    else{
        return NULL;
    }
}
//清除图片
- (void)clearImgPost
{
        NSFileManager *fileMgr = [NSFileManager defaultManager];
            NSError *err;
        if ([fileMgr fileExistsAtPath:self.imgPost]) {
            [fileMgr removeItemAtPath:self.imgPost error:&err];
        };
}
@end















