//
//  UserModel.m
//  ECIGARFAN
//
//  Created by renchunyu on 14-5-30.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
- (void)loadData:(NSDictionary *)dict
{
    self.userName = [dict valueForKey:@"username"];//用户账号
    self.userPassword= [dict valueForKey:@"userpassword"];  //用户密码
    
}

@end
