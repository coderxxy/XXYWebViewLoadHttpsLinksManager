//
//  XXYWebViewLoadHttpsLinksManager.h
//  XXYWebViewLoadHttpsLinksManager
//
//  Created by Jason_Xu on 16/8/27.
//  Copyright © 2016年 Jason_Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XXYWebViewLoadHttpsLinksManager : NSObject<UIWebViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong, readonly) NSURLConnection * urlConnection;
@property (nonatomic, strong, readonly) NSURLRequest *request;
//是否需要身份验证
@property (nonatomic, assign, readonly) BOOL authenticated;
//声明httpsWebView
@property (nonatomic, strong) UIWebView *crmHttpsWebView;
//构造代理方法
@property (nonatomic, weak) id <UIWebViewDelegate> crmWebViewDelegate;

@end
