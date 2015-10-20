//
//  TradeRecordViewController.h
//  ECExpert
//
//  Created by JIRUI on 15/5/15.
//  Copyright (c) 2015年 JIRUI. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, TradeRecordType) {
    TradeRecordTypeCustomer = 0, // default
    TradeRecordTypeDealer,
    TradeRecordTypeGift
};

@interface TradeRecordViewController : BaseViewController

@property (assign, nonatomic) TradeRecordType tradeRecordType;

@property (strong, nonatomic) NSDictionary    *customerInfoDic;
@property (strong, nonatomic) NSDictionary    *sellerInfoDic;

@end
