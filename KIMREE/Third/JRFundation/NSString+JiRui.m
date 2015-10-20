//
//  NSString+JiRui.m
//  Smoking
//
//  Created by JIRUI on 14-4-1.
//  Copyright (c) 2014年 JIRUI. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "pinyin.h"
#import "NSString+JiRui.h"

@implementation NSString (JiRui)

//MD5加密
- (NSString *)stringForMD5
{
    if(self == nil || [self length] == 0)
        return nil;
    const char *value = [self UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (unsigned int)strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}

//将要添加到URL的字符串进行特殊处理，如果这些字符串含有 &， ？ 这些特殊字符，用“%+ASCII” 代替之
- (NSString*)encodeString
{
	CFStringRef newString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
	if (newString) {
		return (__bridge NSString *)newString;
    }
	return @"";
}

//汉字转拼音
- (NSString *)pinyin
{
    NSString *pinyinStr = @"";
    if(![self isEqualToString:@""]){
        for(int i = 0;i < self.length; i++) {
            NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                             pinyinFirstLetter([self characterAtIndex:i])]uppercaseString];
            
            pinyinStr = [pinyinStr stringByAppendingString:singlePinyinLetter];
        }
    }
    return pinyinStr;
}

//判断是否数字
- (BOOL)isNumber
{
    NSArray *nums = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
    
    return [nums containsObject:self];
}

//是否是邮箱格式
- (BOOL)validateEmail
{
    if (self == nil) {
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}
//将十六进制转换为正常字符串
+ (NSString *)stringFromHexString:(NSString *)hexString { //
    if ([hexString isEqual:@""]) {
        return @"";
    }
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    free(myBuffer);
    return unicodeString;
}
@end

