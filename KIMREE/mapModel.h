//
//  mapModel.h
//  ECIGARFAN
//
//  Created by renchunyu on 14-5-6.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import "JRModel.h"

@interface mapModel : JRModel

@property(assign,nonatomic) NSInteger dealer_type;//类型  1:经销商  2:烟酒行
@property(nonatomic,assign) NSInteger dealerId; // 经销商id
@property(nonatomic,strong) NSString *dealerName; // 经销商名称
@property(nonatomic,strong) NSString *dealerAddress; // 经销商地址
@property(nonatomic,strong) NSString *dealerLongitude; //  经度
@property(nonatomic,strong) NSString *dealerLatitude; //  纬度
@property(nonatomic,strong) NSString *dealerTel; //  固定电话
@property(nonatomic,strong) NSString *dealerPhone; //  私人电话
@property(nonatomic,strong) NSString *dealerConnector; // 联系人
@property(nonatomic,strong) NSString *dealerBilling; //  广告词
@property(nonatomic,strong) NSString *dealerDescription; //   经销商描述
@property(nonatomic,strong) NSString *dealerLogo; //   logo地址
@property(nonatomic,strong) NSString *effectTimestamp; //  成为经销商时间
@property(nonatomic,strong) NSString *dealerDistance; //  距离

- (id)loadDataAndReturn:(NSDictionary *)dictionary;

@end
