//
//  AppInfoModel.m
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-16.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppInfoModel.h"

@implementation AppInfoModel
- (void)loadData:(NSDictionary *)dict
{
  self.appVer = [dict valueForKey:@"app_ver"];
  self.forwardexFlag = [dict valueForKey:@"forwardex_flag"];
  self.standardexFlag = [dict valueForKey:@"standardex_flag"];
  self.infolistFlag = [dict valueForKey:@"infolist_flag"];
  self.updateFlag = [dict valueForKey:@"update_flag"];
  self.updateText = [dict valueForKey:@"update_text"];
  self.updateUrl = [dict valueForKey:@"update_url"];
  self.rateUrl = [dict valueForKey:@"rateUrl"];
  self.qqGrounp = [dict valueForKey:@"qq_qun"];
}
@end
