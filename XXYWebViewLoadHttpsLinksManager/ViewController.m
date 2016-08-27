//
//  ViewController.m
//  XXYWebViewLoadHttpsLinksManager
//
//  Created by Jason_Xu on 16/8/27.
//  Copyright © 2016年 Jason_Xu. All rights reserved.
//

#import "ViewController.h"

#import "XXYWebViewLoadHttpsLinksManager.h"

@interface ViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) XXYWebViewLoadHttpsLinksManager *webViewManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createWebView];
}

- (void)createWebView{
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    _webViewManager = [[XXYWebViewLoadHttpsLinksManager alloc] init];
    _webViewManager.crmHttpsWebView = _webView;
    id webViewDelegate = _webView.delegate;
    _webView.delegate = _webViewManager;
    _webViewManager.crmWebViewDelegate = webViewDelegate;
    
    //https://www.cacert.org/
    //https://wwww.baidu.com
    //http://www.sina.com
    NSString *urlStr = @"https://www.cacert.org/";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
