//
//  NJKWebViewProgress.h
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-7.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef njk_weak
#if __has_feature(objc_arc_weak)
#define njk_weak weak
#else
#define njk_weak unsafe_unretained
#endif

typedef void (^NJKWebViewProgressBlock)(float progress);
@protocol NJKWebViewProgressDelegate;
@interface JRWebViewProgress : NSObject<UIWebViewDelegate>
@property (nonatomic, njk_weak) id<NJKWebViewProgressDelegate>progressDelegate;
@property (nonatomic, njk_weak) id<UIWebViewDelegate>webViewProxyDelegate;
@property (nonatomic, copy) NJKWebViewProgressBlock progressBlock;
@property (nonatomic, readonly) float progress; // 0.0..1.0

- (void)reset;
@end

@protocol NJKWebViewProgressDelegate <NSObject>
- (void)webViewProgress:(JRWebViewProgress *)webViewProgress updateProgress:(float)progress;
@end

