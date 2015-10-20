//
//  JRObject.m
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-16.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#include <objc/runtime.h>
#import "JRModel.h"

@implementation JRModel
/*
 *@brief 归档
 */

 - (void)encodeWithCoder:(NSCoder *)encoder {
 Class cls = [self class];
 @synchronized (self) {
 while (cls != [NSObject class]) {
 unsigned int numberOfIvars = 0;
 //取得当前class的Ivar数组
 Ivar* ivars = class_copyIvarList(cls, &numberOfIvars);
 for(const Ivar* p = ivars; p < ivars+numberOfIvars; p++) {
 Ivar const ivar = *p;
 //得到ivar的类型
 const char *type = ivar_getTypeEncoding(ivar);
 //取得它的名字，比如"year", "name".
 NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
 //取得某个key所对应的值
 id value = [self valueForKey:key];
 if (value) {
 switch (type[0]) {
 case _C_STRUCT_B: {
 NSUInteger ivarSize = 0;
 NSUInteger ivarAlignment = 0;
 //取得变量的大小
 NSGetSizeAndAlignment(type, &ivarSize, &ivarAlignment);
 //((const char *)self + ivar_getOffset(ivar))指向结构体变量
 NSData *data = [NSData dataWithBytes:(const char *)self + ivar_getOffset(ivar)
 length:ivarSize];
 [encoder encodeObject:data forKey:key];
 }
 break;
 default:
 [encoder encodeObject:value
 forKey:key];
 break;
 }
 }
 }
 if (ivars) {
 free(ivars);
 }
 
 cls = class_getSuperclass(cls);
 }
 }
 }
 
 
 // *@brief 解归档
 
 - (id)initWithCoder:(NSCoder *)decoder {
 self = [super init];
 
 if (self) {
 Class cls = [self class];
 while (cls != [NSObject class]) {
 unsigned int numberOfIvars = 0;
 Ivar* ivars = class_copyIvarList(cls, &numberOfIvars);
 for(const Ivar* p = ivars; p < ivars+numberOfIvars; p++) {
 Ivar const ivar = *p;
 const char *type = ivar_getTypeEncoding(ivar);
 NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
 id value = [decoder decodeObjectForKey:key];
 if (value) {
 switch (type[0]) {
 case _C_STRUCT_B: {
 NSUInteger ivarSize = 0;
 NSUInteger ivarAlignment = 0;
 NSGetSizeAndAlignment(type, &ivarSize, &ivarAlignment);
 NSData *data = [decoder decodeObjectForKey:key];
 char *sourceIvarLocation = (char *)self+ ivar_getOffset(ivar);
 [data getBytes:sourceIvarLocation length:ivarSize];
 memcpy((char *)self + ivar_getOffset(ivar), sourceIvarLocation, ivarSize);
 }
 break;
 default:
 [self setValue:[decoder decodeObjectForKey:key]
 forKey:key];
 break;
 }
 }
 }
 
 if (ivars) {
 free(ivars);
 }
 cls = class_getSuperclass(cls);
 }
 }
 return self;
 }
 
/*
 *@brief 将Dictionary数据转换到模型字段
 */


- (void)loadData:(NSDictionary *)dict
{
    
}






@end

