//
//  UserModel.m
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-16.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "UserDetailModel.h"

@implementation UserDetailModel


/*
 *@brief 将Dictionary数据转换到模型字段
 */
- (void)loadData:(NSDictionary *)dict
{
    self.customerId = [[dict objectForKey:@"customer_id"]integerValue];     //用户ID值，自增长 not null
    self.customerName = [dict valueForKey:@"customer_name"];                //用户名          not null
    self.customerNickname = [dict valueForKey:@"customer_nickname"];        //昵称
    self.customerSex = [[dict valueForKey:@"customer_sex"] boolValue];      //性别：0、男 1、女
    self.customerSign = [dict valueForKey:@"customer_sign"];                //个性签名
    self.customerEmail = [dict valueForKey:@"customer_email"];              //email
    self.customerBirth = [dict valueForKey:@"customer_birth"];              //出生日期
    self.customerPhone = [dict valueForKey:@"customer_phone"];              //电话
    self.customerAddress = [dict valueForKey:@"customer_address"];          //详细地址
    self.customerHead = [dict valueForKey:@"customer_headimage"];           //用户头像路径
    self.customerDegree = [dict valueForKey:@"customer_degree"];            //会员级别 1、普通 2、青铜 3、白银 4、黄金 5、钻石
    self.createTime = [dict valueForKey:@"create_time"];                    //注册时间
    self.updateTime = [dict valueForKey:@"update_time"];                    //最后登录时间
}
@end




