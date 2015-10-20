//
//  DateViewController.m
//  Demo
//
//  Created by JIRUI on 15/4/22.
//  Copyright (c) 2015年 kimree. All rights reserved.
//

#import "DateViewController.h"
#import "FSCalendar.h"
#import "FSCalendarHeader.h"
#import "NSDate+FSExtension.h"

@interface DateViewController ()

@property (strong, nonatomic) FSCalendar *calendar;

@property (strong, nonatomic) NSDateFormatter *outDateFormatter;
@property (strong, nonatomic) NSString *formatter;

@end

@implementation DateViewController


- (void)dealloc{
    NSLog(@"DateViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = NO;
    
    [self initData];
    [self initView];
    
    self.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishiSelectAction)];
}

- (void)finishiSelectAction{
    NSString *str = [self.calendar.selectedDate fs_stringWithFormat:_formatter];
    
    if (self.finishDatePickBlock) {
        self.finishDatePickBlock([self.outDateFormatter dateFromString:str]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData{
    _formatter = @"yyyy-MM-dd";
    _outDateFormatter = [[NSDateFormatter alloc] init];
    _outDateFormatter.dateFormat = _formatter;
}

- (void)goback{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"放弃修改?" message:@"放弃修改数据?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [super goback];
        }
    }];
}

/**
 *  初始化日历参数
 */
- (void)initView{
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    FSCalendarHeader *header = [[FSCalendarHeader alloc] initWithFrame:(CGRect){{0,64},{frame.size.width, 50}}];
    
    _calendar = [[FSCalendar alloc] initWithFrame:(CGRect){{0,114},{frame.size.width, 280}}];
    
    if (self.autoSelectedDate) {
        _calendar.selectedDate = self.autoSelectedDate;
    }
    
    _calendar.header = header;
    _calendar.dataSource = self;
    _calendar.delegate = self;
    [_calendar setHeaderTitleColor:[UIColor redColor]];
    [_calendar setHeaderDateFormat:@"yyyy-MMMM"];
    [_calendar setSelectionColor:[UIColor blueColor]];
    [_calendar setFirstWeekday:[[NSCalendar currentCalendar] firstWeekday]];
    
    [self.view addSubview:header];
    [self.view addSubview:_calendar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FSCalendarDelegate
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date{
    BOOL canSelect = YES;
    NSString *shouldSelectDateString = [date fs_stringWithFormat:_formatter];
    NSString *minDateString = [self.outDateFormatter stringFromDate:self.minDate];
    NSString *maxDateString = [self.outDateFormatter stringFromDate:self.maxDate];
    
    if (minDateString != nil) {
        if ([shouldSelectDateString compare:minDateString] == NSOrderedAscending) {
            canSelect = NO;

        }        
    }
    
    if (maxDateString != nil) {
        if ([shouldSelectDateString compare:maxDateString] == NSOrderedDescending) {
            canSelect = NO;
        }
    }
    
    if (!canSelect) {
        NSMutableString *errorStr = [[NSMutableString alloc] init];
        [errorStr appendFormat:@"The selected date must"];
        
        if (minDateString != nil) {
            [errorStr appendFormat:@"\n>= %@ ", minDateString];
        }
        if (maxDateString != nil) {
            [errorStr appendFormat:@"\n<= %@ ", maxDateString];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误日期" message:errorStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    
    return canSelect;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date{
    NSString *selectedDateString = [date fs_stringWithFormat:_formatter];
    NSLog(@"did select date %@",selectedDateString);
}

- (void)calendarCurrentMonthDidChange:(FSCalendar *)calendar{
    NSLog(@"did change to month %@",[_calendar.currentMonth fs_stringWithFormat:@"MMMM yyyy"]);
}


#pragma mark - FSCalendarDataSource
//- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date{
//
//}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
