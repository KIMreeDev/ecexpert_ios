//
//  JRResponse.h
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-15.
//  Copyright (c) 2014年 JIRUI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRResponse : NSObject
@property (nonatomic,assign) NSInteger code;
@property (nonatomic,copy) NSString *msg;
@property (nonatomic,copy) NSString *cmd;
@property (nonatomic,assign) NSInteger timeInterval;
@property (nonatomic,retain) id data;

/*
 * @brief 根据字典来初始化
 */
- (JRResponse *)initWithData:(id)data;
@end
