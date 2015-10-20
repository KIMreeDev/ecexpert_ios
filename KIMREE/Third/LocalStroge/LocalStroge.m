//
//  LocalStroge.m
//  ECIGARFAN
//
//  Created by renchunyu on 14-5-16.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import "LocalStroge.h"

@implementation LocalStroge

#pragma mark
#pragma mark  init

+ (LocalStroge *)sharedInstance
{
    static dispatch_once_t onceToken;
    static LocalStroge *instance= nil;
    dispatch_once(&onceToken, ^{
        instance = [[LocalStroge alloc] init];
    });
    return instance;
}


#pragma mark
#pragma mark  build file with NSMutableArray


-(void) buildFileForKey:(NSString*)str witharray:(NSMutableArray*)array filePath:(NSSearchPathDirectory)folder
{
    
    NSString *Path = [NSSearchPathForDirectoriesInDomains(folder, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filepath=[Path stringByAppendingPathComponent:str];
    
    [NSKeyedArchiver archiveRootObject:array toFile:filepath];

}




#pragma mark
#pragma mark get 、save、delete


-(id)getObjectAtKey:(NSString*)str filePath:(NSSearchPathDirectory)folder
{
    
    NSString *Path = [NSSearchPathForDirectoriesInDomains(folder, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filepath=[Path stringByAppendingPathComponent:str];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //NSLog(@"目录%@",filepath);
    
    //解密
    NSData *cipher = [[NSKeyedUnarchiver unarchiveObjectWithFile:filepath] AES256DecryptWithKey:@"ecigarfan"];
   
    if([fileManager fileExistsAtPath:filepath]){
        return [NSKeyedUnarchiver unarchiveObjectWithData:cipher];//逆归档

    }
    return nil;
}


-(void) addObject:(id)object forKey:(NSString*)str filePath:(NSSearchPathDirectory)folder
{
    
    NSString *Path = [NSSearchPathForDirectoriesInDomains(folder, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filepath=[Path stringByAppendingPathComponent:str];
    

    ecigarfanModel *model=[[ecigarfanModel alloc] initWithObject:object];
    //归档
    id objectAfter= [NSKeyedArchiver archivedDataWithRootObject:model.model];
     //AES加密
     NSData *cipher = [objectAfter AES256EncryptWithKey:@"ecigarfan"];
    
    [NSKeyedArchiver archiveRootObject:cipher toFile:filepath];

}


-(void) deleteFileforKey:(NSString*)str filePath:(NSSearchPathDirectory)folder
{
    
    NSString *Path = [NSSearchPathForDirectoriesInDomains(folder, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filepath=[Path stringByAppendingPathComponent:str];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filepath]){
        
        [fileManager removeItemAtPath:filepath error:nil];
    }
}



@end
