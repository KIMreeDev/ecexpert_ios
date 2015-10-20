//
//  ArchiveServer.h
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-16.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface ArchiveServer : NSObject
@property(nonatomic,strong) NSString *path;

+ (ArchiveServer *)defaultArchiver;
- (ArchiveServer *)initWithPath:(NSString *)path;

- (id)unarchiveWithKey:(NSString *)key;
- (void)archiveObject:(NSObject *)object key:(NSString *)key;

- (void)cleanArchiveWithKey:(NSString *)key;
- (void)cleanAllArchiveFile;
- (CGFloat)sizeOfAllArchiveFile;
- (CGFloat)sizeOfArchiveWithKey:(NSString *)key;

@end
