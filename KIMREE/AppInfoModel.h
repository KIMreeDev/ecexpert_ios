//
//  AppInfoModel.h
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-16.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "JRModel.h"

@interface AppInfoModel : JRModel
@property(nonatomic,strong) NSString *appVer;//版本
@property(nonatomic,strong) NSString *forwardexFlag;//
@property(nonatomic,strong) NSString *standardexFlag;//
@property(nonatomic,strong) NSString *infolistFlag;//信息列表项
@property(nonatomic,strong) NSNumber *updateFlag;//
@property(nonatomic,strong) NSString *updateText;//更新信息
@property(nonatomic,strong) NSString *updateUrl;//上架网址
@property(nonatomic,strong) NSString *rateUrl;//上架网址
@property(nonatomic,strong) NSString *qqGrounp;//qq群
@end
