//
//  TradeOutputViewController.h
//  ECExpert
//
//  Created by JIRUI on 15/5/18.
//  Copyright (c) 2015年 JIRUI. All rights reserved.
//

#import "BaseViewController.h"
#import "TradeRecordViewController.h"

@interface TradeOutputViewController : BaseViewController

// 用来判断查看交易记录的用户类型
@property (assign, nonatomic) TradeRecordType tradeRecordType;

@property (copy, nonatomic) NSDictionary *tradeInfoDic;

@end
