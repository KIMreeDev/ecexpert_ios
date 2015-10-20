//
//  DateTimeHelper.h
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-18.
//  Copyright (c) 2014年 JIRUI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTimeHelper : NSObject
+ (NSString *)formatStringWithDate:(NSDate *)date;
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format;
+ (NSInteger)daysFromDate:(NSDate *) startDate toDate:(NSDate *) endDate;
+ (NSString *)getLocalDateFormateUTCDate:(NSString *)date;
+ (NSString *)getUTCFormateLocalDate:(NSString *)localDate;
@end
