//
//  GetDealer.m
//  ECIGARFAN
//
//  Created by renchunyu on 14-8-8.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import "GetDealer.h"

@interface GetDealer(){
}

@end
static GetDealer *instance	= nil;

@implementation GetDealer

+(id)shareInstance:(NSString*)strUrl
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken , ^{
        [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
        instance = [[GetDealer alloc]init];
    });

    if (strUrl) {
        [instance getInformationFromNetwork:strUrl];   
    }

    return instance;
}

- (NSMutableArray *)localArr{
    if (!_localArr.count) {
        _localArr = [NSMutableArray arrayWithArray:[[LocalStroge sharedInstance] getObjectAtKey:F_DEALER_INFORMATION filePath:NSCachesDirectory]];
    }
    return _localArr;
}

- (void)getInformationFromNetwork:(NSString *)strUrl
{

    _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [_request setDelegate:self];
    [_request setDownloadCache:[ASIDownloadCache sharedCache]];
    [_request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [_request setShouldAttemptPersistentConnection:NO];
    [_request setTimeOutSeconds:10];
    [_request startAsynchronous];

    
    if (!self.localArr.count) {
        [MMProgressHUD showWithTitle:nil status:NSLocalizedString(@"Getting information...", @"")];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    [MMProgressHUD dismissWithError:NSLocalizedString(@"Access to information failure", nil)];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *jsonData = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    
    NSMutableDictionary *rootDic = [[CJSONDeserializer deserializer] deserialize:jsonData error:&error];
    
    int status=[[rootDic objectForKey:@"code"] intValue];
    
    if (status==1) {
        
        
//        NSMutableArray *cigAdnWineArray=[[NSMutableArray alloc] init];
        NSMutableArray *dealerArray=[[NSMutableArray alloc] init];
        NSArray *array=[[NSArray alloc] initWithArray:[rootDic objectForKey:@"data"]];
        
        for (int i=0; i<array.count; i++) {
            
            if ([(NSString*)[array[i] objectForKey:@"dealer_type"] isEqualToString:@"1"]) {
                [dealerArray addObject:array[i]];
            }else if([(NSString*)[array[i] objectForKey:@"dealer_type"] isEqualToString:@"2"]||[(NSString*)[array[i] objectForKey:@"dealer_type"] isEqualToString:@"3"])
            {
//               [cigAdnWineArray addObject:array[i]];
            }else if ([(NSString*)[array[i] objectForKey:@"dealer_type"] isEqualToString:@"4"])
            {
                //代表既卖烟酒，又卖电子烟
                [dealerArray addObject:array[i]];
//                [cigAdnWineArray addObject:array[i]];
            }
            
        }
//        [[LocalStroge sharedInstance] addObject:cigAdnWineArray forKey:F_CIGANDWINE_INFORMATION filePath:NSCachesDirectory];
        
        NSMutableArray *temporaryArr = [NSMutableArray arrayWithArray:[[LocalStroge sharedInstance] getObjectAtKey:F_DEALER_INFORMATION filePath:NSCachesDirectory]];
        BOOL isSame = [temporaryArr isEqualToArray:dealerArray];
        if (!isSame) {
            //数据不一样，重新加载
            [[LocalStroge sharedInstance] addObject:dealerArray forKey:F_DEALER_INFORMATION filePath:NSCachesDirectory];
            [self.localArr removeAllObjects];
            [self reload];
        }
        
         [MMProgressHUD dismissWithSuccess:nil];
        
        
    }else{
        [MMProgressHUD dismissWithError:[rootDic objectForKey:@"data"]];
        
    }
    
    
}

-(void)reload
{
    if ([_delegate respondsToSelector:@selector(reloadView)]) {
        [_delegate reloadView];
    }
    
}

-(void)cancelRequest
{
    [_request cancel];
    [_request clearDelegatesAndCancel];
    
}

@end
