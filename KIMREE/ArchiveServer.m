//
//  ArchiveServer.m
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-16.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//
#import "ArchiveServer.h"
static ArchiveServer *instance = nil;
@implementation ArchiveServer

+ (ArchiveServer *)defaultArchiver
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[ArchiveServer alloc] initWithPath:F_PATH_IN_DOCUMENTS(@"model")];
  });
  return instance;
}

- (ArchiveServer *)initWithPath:(NSString *)path
{
  self = [super init];
  if (self) {
    self.path = path;
  }
  return self;
}

- (void)cleanAllArchiveFile {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if ([fileManager fileExistsAtPath:self.path]) {
    [fileManager removeItemAtPath:self.path error:nil];
  }
}

- (void)cleanArchiveWithKey:(NSString *)key {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSString *path = [self.path stringByAppendingPathComponent:key];
  if ([fileManager fileExistsAtPath:path]) {
    [fileManager removeItemAtPath:path error:nil];
  }
}

- (CGFloat)sizeOfArchiveWithKey:(NSString *)key
{
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSString *path = [self.path stringByAppendingPathComponent:key];
  if ([fileManager fileExistsAtPath:path]) {
    return [[fileManager attributesOfItemAtPath:path error:nil] fileSize];
  }
  return 0;
}
- (CGFloat)sizeOfAllArchiveFile
{
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if ([fileManager fileExistsAtPath:self.path]) {
    return [[fileManager attributesOfItemAtPath:self.path error:nil] fileSize];
  }
  return 0;
}

- (id)unarchiveWithKey:(NSString *)key {
  NSString * filePath = [self.path stringByAppendingPathComponent:key];
  return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

- (void)archiveObject:(NSObject *)object key:(NSString *)key {
  @autoreleasepool {
    @synchronized (object) {
      @try {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:self.path]) {
          [fileManager createDirectoryAtPath:self.path withIntermediateDirectories:NO attributes:nil error:nil];
        }
        NSString * filePath = [self.path stringByAppendingPathComponent:key];
        [NSKeyedArchiver archiveRootObject:object toFile:filePath];
      }
      @catch (NSException *exception) {
        THLog(@"%@",exception.description);
      }
      @finally {
      }
    }
  }
}

@end
