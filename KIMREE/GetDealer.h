//
//  GetDealer.h
//  ECIGARFAN
//
//  Created by renchunyu on 14-8-8.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol getDearlerDelegate <NSObject>

-(void)reloadView;
@end


@interface GetDealer : NSObject{
}
+(GetDealer*)shareInstance:(NSString*)strUrl;
@property (assign,nonatomic) id<getDearlerDelegate>delegate;
@property (strong,nonatomic)  ASIHTTPRequest *request;
@property (nonatomic, strong) NSMutableArray *localArr;

- (void)getInformationFromNetwork:(NSString *)strUrl;
-(void)cancelRequest;
@end
