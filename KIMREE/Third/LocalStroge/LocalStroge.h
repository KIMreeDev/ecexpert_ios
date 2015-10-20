//
//  LocalStroge.h
//  ECIGARFAN
//
//  Created by renchunyu on 14-5-16.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+Encryption.h"
#import "ecigarfanModel.h"


#define F_USER_INFORMATION @"user_information"              //用户信息
#define F_DEALER_INFORMATION @"dealer_information"          //经销商信息(地图版块)
#define F_CIGANDWINE_INFORMATION @"cigarettes_and_wine"     //烟酒行信息
//----排序后-------
#define F_DEALER_INFORMATION_SORT @"dealer_information_sort"          //经销商信息(地图版块)
#define F_CIGANDWINE_INFORMATION_SORT @"cigarettes_and_wine_sort"     //烟酒行信息
//----------------
#define F_LAST_LOCATION @"last_loaction"                    //上次定位位置
#define F_ADVERTISEMENT @"advertisement"                    //广告


#define F_WEBSITE_SELECTED @"website_selected"              //资讯版块选中网页
#define F_WEBSITE @"website"                                 //所有资讯版块
#define F_UPDATEINFORMATION @"update_information"            //版本升级信息



@interface LocalStroge : NSObject


//创建带NSMutableArray目录
+ (LocalStroge *)sharedInstance;
-(void) buildFileForKey:(NSString*)str witharray:(NSMutableArray*)array filePath:(NSSearchPathDirectory)folder;
//get、save、delete
-(id)getObjectAtKey:(NSString*)str filePath:(NSSearchPathDirectory)folder;
-(void) addObject:(id)object forKey:(NSString*)str filePath:(NSSearchPathDirectory)folder;
-(void) deleteFileforKey:(NSString*)str filePath:(NSSearchPathDirectory)folder;


@end

