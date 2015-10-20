//
//  UserDetailModel.h
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-16.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "JRModel.h"

@interface UserDetailModel : JRModel

@property (nonatomic, assign) NSInteger customerId;
@property(nonatomic,strong) NSString *customerName;
@property(nonatomic,strong) NSString *customerNickname;
@property(nonatomic,assign) BOOL customerSex;
@property(nonatomic,strong) NSString *customerSign;
@property(nonatomic,strong) NSString *customerEmail;
@property(nonatomic,strong) NSString *customerBirth;
@property(nonatomic,strong) NSString *customerPhone;
@property(nonatomic,strong) NSString *customerAddress;
@property(nonatomic,strong) NSString *customerHead;
@property(nonatomic,strong) NSString *customerDegree;
@property(nonatomic,strong) NSString *createTime;
@property(nonatomic,strong) NSString *updateTime;



- (void)loadData:(NSDictionary *)dict;

@end



