//
//  UserModel.h
//  ECIGARFAN
//
//  Created by renchunyu on 14-5-30.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import "JRModel.h"

@interface UserModel : JRModel
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *userPassword;
- (void)loadData:(NSDictionary *)dict;
@end
