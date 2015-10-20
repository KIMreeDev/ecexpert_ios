//
//  DateTimeHelper.m
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-18.
//  Copyright (c) 2014年 JIRUI. All rights reserved.
//

#import "DateTimeHelper.h"

@implementation DateTimeHelper
//（获得时间的长短）
+ (NSString *)formatStringWithDate:(NSDate *)date {

//    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
//    [NSTimeZone setDefaultTimeZone:timeZone];
  NSString *result;
  NSTimeInterval interval = -[date timeIntervalSinceNow];
  if (interval<0 || !date) {
    result = @"just";//不同国家，不同时区，会造成本地时间比较为负，则为刚刚
  }else if (interval<60) {
    result =NSLocalizedString(@"just", nil);
  }else if (interval/60<60) {
    //小于60分钟
    result = [NSString stringWithFormat:NSLocalizedString(@"%d minutes ago", nil),(NSInteger)interval/60];
  }else if(interval/60/60<24){
    //小于24小时
    result = [NSString stringWithFormat:NSLocalizedString(@"%d hours ago", nil),(NSInteger)interval/60/60];
  }else{
      NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
      [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
      result = [formatter stringFromDate:date];
  }
  
  return result;
}

//设置日期的格式
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:format];
//  NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
  return [formatter stringFromDate:date];
}

//中间持续天数
+ (NSInteger)daysFromDate:(NSDate *) startDate toDate:(NSDate *) endDate {
  NSTimeInterval start = [startDate timeIntervalSince1970];
  NSTimeInterval over = [endDate timeIntervalSince1970];
  NSInteger days = ceil((over - start)/(24*60*60));
  return days;
}
//把标准时间转换成正常时间
+ (NSString *)getLocalDateFormateUTCDate:(NSString *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [formatter dateFromString:date];
    
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:destDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:destDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:destDate];
    NSString *beginStr = [formatter stringFromDate:destinationDateNow];

    return beginStr;
}
//把正常时间转换成标准时间
+(NSString *)getUTCFormateLocalDate:(NSString *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:localDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}
@end












