//
//  NSData+Encryption.h
//  ECIGARFAN
//
//  Created by renchunyu on 14-7-15.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

// AES加密

#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (Encryption)



- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密

- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密

- (NSString *)newStringInBase64FromData;            //追加64编码

+ (NSString*)base64encode:(NSString*)str;           //同上64编码



@end