//
//  DateViewController.h
//  Demo
//
//  Created by JIRUI on 15/4/22.
//  Copyright (c) 2015年 kimree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FSCalendar.h"

typedef void (^FinishDatePickBlock)(NSDate *pickDate);

@class FSCalendar;

@interface DateViewController : BaseViewController <FSCalendarDelegate, FSCalendarDataSource>

@property (strong, nonatomic) NSDate *minDate;
@property (strong, nonatomic) NSDate *maxDate;
@property (strong, nonatomic) NSDate *autoSelectedDate;

@property (copy, nonatomic) FinishDatePickBlock finishDatePickBlock;

@end
