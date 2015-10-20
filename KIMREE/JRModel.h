//
//  JRObject.h
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-16.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRModel : NSObject<NSCoding>
- (void)loadData:(NSDictionary *)dict;
/*
 *@brief 归档
 */

 - (void)encodeWithCoder:(NSCoder *)encoder;
 
 
 // *@brief 解归档
 
 - (id)initWithCoder:(NSCoder *)decoder;

/*
 *@brief 将Dictionary数据转换到模型字段
 */
@end


