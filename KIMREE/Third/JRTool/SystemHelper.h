//
//  SystemHelper.h
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-18.
//  Copyright (c) 2014年 JIRUI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemHelper : NSObject

+ (BOOL)isLongScreen;
+ (BOOL)isSimulator;
+ (BOOL)isRetina;
+ (NSString *)uuid;
+ (NSString *)macaddress;
+ (NSString *)appVersion;
+ (NSNumber *)buildVersion;
+ (NSString *)appName;
+ (NSString *)bundleID;
+ (CGFloat)systemVersion;
+ (NSString *)currentLanguage;
+ (NSString *)currentTimeZone;
+ (NSString*)deviceType;
+ (NSString *)uniqueGlobalDeviceIdentifier;
+ (NSString *)uniqueDeviceIdentifier;

@end
