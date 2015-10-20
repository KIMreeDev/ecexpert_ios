//
//  JRKeyChainHelper.h
//  ECIGARFAN
//
//  Created by renchunyu on 14-5-15.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"

@interface JRKeyChainHelper : NSObject

+ (void) saveUserName:(NSString*)userName
      userNameService:(NSString*)userNameService
             psaaword:(NSString*)pwd
      psaawordService:(NSString*)pwdService;

+ (void) deleteWithUserNameService:(NSString*)userNameService
                   psaawordService:(NSString*)pwdService;

+ (NSString*) getUserNameWithService:(NSString*)userNameService;

+ (NSString*) getPasswordWithService:(NSString*)pwdService;

+ (NSString *) getUserTypeWithService:(NSString *) userType;
+ (void)saveUserType:(UserType) userType userTypeService:(NSString *) typeService;

@end
