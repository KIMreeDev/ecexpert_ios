//
//  AFNetworkingFactory.h
//  ECExpert
//
//  Created by Fran on 15/6/2.
//  Copyright (c) 2015年 Fran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface AFNetworkingFactory : NSObject

+ (AFHTTPRequestOperationManager *)networkingManager;

@end
