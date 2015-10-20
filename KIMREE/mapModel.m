//
//  mapModel.m
//  ECIGARFAN
//
//  Created by renchunyu on 14-5-6.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import "mapModel.h"

@implementation mapModel

- (id)loadDataAndReturn:(NSDictionary *)dic
{
    self.dealer_type=[[dic valueForKey:@"dealer_type"] integerValue];//类型，经销商或烟酒行
    self.dealerId = [[dic valueForKey:@"dealer_id"]integerValue];//经销商ID值，自增长
    self.dealerName = [dic valueForKey:@"dealer_name"];  //经销商名称
    self.dealerAddress = [dic valueForKey:@"dealer_address"]; //经销商地址
    self.dealerLongitude = [dic valueForKey:@"dealer_lng"];//经度（谷歌地图）
    self.dealerLatitude = [dic valueForKey:@"dealer_lat"];//纬度（谷歌地图）
    self.dealerTel = [dic valueForKey:@"dealer_tel"];//固定电话
    self.dealerPhone = [dic valueForKey:@"dealer_phone"];//私人电话
    self.dealerConnector = [dic valueForKey:@"dealer_connector"];//联系人
    self.dealerBilling = [dic valueForKey:@"dealer_billing"];//经销商广告语
    self.dealerDescription = [dic valueForKey:@"dealer_desc"];//经销商详细介绍
    self.dealerLogo = [dic valueForKey:@"dealer_logo"];//经销商logo地址
    self.effectTimestamp = [dic valueForKey:@"effect_tm"];//成为经销商时间
    self.dealerDistance = [dic valueForKey:@"dealer_distance"];//距离
    return self;

}


@end
