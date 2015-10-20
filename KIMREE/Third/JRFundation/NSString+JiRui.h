//
//  NSString+JiRui.h
//  Smoking
//
//  Created by JIRUI on 14-4-1.
//  Copyright (c) 2014年 JIRUI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JiRui)

//将字符串转化为MD5字符串
- (NSString *)stringForMD5;

//将要添加到URL的字符串进行特殊处理
- (NSString *)encodeString;

//汉字转为拼音首字母
- (NSString *)pinyin;

//判断是否是数字
- (BOOL)isNumber;

//是否是邮箱格式
- (BOOL)validateEmail;
//把十六进制转换为普通字符串
+ (NSString *)stringFromHexString:(NSString *)hexString;
@end
