//
//  ErrorHelper.h
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-18.
//  Copyright (c) 2014年 JIRUI. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface ErrorHelper : NSObject
+ (NSString *)messageWithCode:(NSInteger)code;
+ (NSString *)messageWithData:(NSString *)data AndCode:(NSInteger)code;
@end
