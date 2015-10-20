//
//  SystemHelper.m
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-18.
//  Copyright (c) 2014年 JIRUI. All rights reserved.
//
#import "SystemHelper.h"
#import <sys/utsname.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "NSString+JiRui.h"
@implementation SystemHelper

//是否iPhone4及以上的型号(不包括iPad)
+ (BOOL)isLongScreen {
  if ([UIScreen instancesRespondToSelector:@selector(currentMode)]) {
    return CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size);
  }
  return NO;
}

//判断模拟器
+ (BOOL)isSimulator {
	NSString *deviceModel = [UIDevice currentDevice].model;
	return ([deviceModel isEqualToString:@"iPhone Simulator"] || [deviceModel isEqualToString:@"iPad Simulator"]);
}

//判断视网膜
+ (BOOL)isRetina {
  CGFloat scale = [[UIScreen mainScreen] scale];
  
  if (scale > 1.0)
    return YES;
  return NO;
}

//uuid设备唯一标识符
+ (NSString *)uuid{
  CFUUIDRef puuid = CFUUIDCreate( nil );
  CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
  NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
  CFRelease(puuid);
  CFRelease(uuidString);
  return result;
}

//mac地址
+ (NSString *)macaddress {
  int                 mib[6];
  size_t              len;
  char                *buf;
  unsigned char       *ptr;
  struct if_msghdr    *ifm;
  struct sockaddr_dl  *sdl;
  
  mib[0] = CTL_NET;
  mib[1] = AF_ROUTE;
  mib[2] = 0;
  mib[3] = AF_LINK;
  mib[4] = NET_RT_IFLIST;
  
  if ((mib[5] = if_nametoindex("en0")) == 0) {
    printf("Error: if_nametoindex error\n");
    return NULL;
  }
  
  if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
    printf("Error: sysctl, take 1\n");
    return NULL;
  }
  
  if ((buf = malloc(len)) == NULL) {
    printf("Could not allocate memory. error!\n");
    return NULL;
  }
  
  if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
    printf("Error: sysctl, take 2");
    free(buf);
    return NULL;
  }
  
  ifm = (struct if_msghdr *)buf;
  sdl = (struct sockaddr_dl *)(ifm + 1);
  ptr = (unsigned char *)LLADDR(sdl);
  NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                         *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
  free(buf);
  
  return outstring;
}

//发布版本号
+ (NSString *)appVersion
{
  NSString * str = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
  return  str;//[NSNumber numberWithFloat:[str floatValue]];
}

//开发版本号
+ (NSNumber *)buildVersion
{
	NSString * str = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
  return  [NSNumber numberWithFloat:[str floatValue]];
}

//应用名称
+ (NSString *)appName
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

//com.公司标识.应用名称
+ (NSString *)bundleID
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

//获得ios系统版本号
+ (CGFloat) systemVersion
{
	NSString * ver = [[UIDevice currentDevice] systemVersion];
	return  [ver floatValue];
}

//获取当前语言类型
+ (NSString *)currentLanguage
{
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSArray *languages = [userDefault objectForKey:@"AppleLanguages"];
	NSString *preferredLang = [languages objectAtIndex:0];
	return preferredLang;
}

//获取当前时区
+ (NSString *)currentTimeZone
{
  return  [[NSTimeZone localTimeZone] name];
}

//从url中获取自定义参数
+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName
{
  if (![paramName hasSuffix:@"="]) {
    paramName = [NSString stringWithFormat:@"%@=", paramName];
  }
  
  NSString * str = nil;
  NSRange start = [url rangeOfString:paramName];
  if (start.location != NSNotFound) {
    // confirm that the parameter is not a partial name match
    unichar c = '?';
    if (start.location != 0) {
      c = [url characterAtIndex:start.location - 1];
    }
    if (c == '?' || c == '&' || c == '#') {
      NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
      NSUInteger offset = start.location+start.length;
      str = end.location == NSNotFound ?
      [url substringFromIndex:offset] :
      [url substringWithRange:NSMakeRange(offset, end.location)];
      str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
  }
  return str;
}

//设备类型
+ (NSString*)deviceType
{
  struct utsname systemInfo;
  uname(&systemInfo);
  NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
  
  if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
  if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
  if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
  if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
  if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
  if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
  if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
  if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
  if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
  if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
  if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
  if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
  if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
  if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
  if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
  if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
  NSLog(@"NOTE: Unknown device type: %@", deviceString);
  return deviceString;
}

//经过MD5加密的设备唯一识别号（mac地址与bundleID）
+ (NSString *)uniqueDeviceIdentifier {
  NSString *macaddress = [self macaddress];
  NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
  
  NSString *stringToHash = [NSString stringWithFormat:@"%@%@",macaddress,bundleIdentifier];
  NSString *uniqueIdentifier = [stringToHash stringForMD5];
  
  return uniqueIdentifier;
}

//经过MD5加密的设备唯一识别号（mac地址）
+ (NSString *)uniqueGlobalDeviceIdentifier {
  NSString *macaddress = [self macaddress];
  NSString *uniqueIdentifier = [macaddress stringForMD5];
  
  return uniqueIdentifier;
}

@end
