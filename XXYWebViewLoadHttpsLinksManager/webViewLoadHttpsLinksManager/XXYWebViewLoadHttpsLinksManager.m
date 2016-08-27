//
//  XXYWebViewLoadHttpsLinksManager.m
//  XXYWebViewLoadHttpsLinksManager
//
//  Created by Jason_Xu on 16/8/27.
//  Copyright © 2016年 Jason_Xu. All rights reserved.
//

#import "XXYWebViewLoadHttpsLinksManager.h"

#define kCRMWebviewValidation       (@"CACert")

@implementation XXYWebViewLoadHttpsLinksManager
/**
 *  init
 *
 *  @return <#return value description#>
 */
- (instancetype)init{
    self = [super init];
    if (self) {
        _authenticated = NO;
    }
    return self;
}

#pragma mark - <UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"%s", __func__);
    if (self.crmWebViewDelegate && [self.crmWebViewDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        [self.crmWebViewDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    //判断当前连接是否需要验证 https需要  http 不需要
    if ([request.URL.scheme isEqualToString:@"https"]) {
        if (!_authenticated) {
            [self.crmHttpsWebView stopLoading];
            _request = request;
            _urlConnection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
            [_urlConnection start];
            return NO;
        }
    }
    return YES;
}
/**
 *  开始下载
 *
 *  @param webView <#webView description#>
 */
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"%s", __func__);
    if (self.crmWebViewDelegate && [self.crmWebViewDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.crmWebViewDelegate webViewDidStartLoad:webView];
    }
}
/**
 *  已经结束下载
 *
 *  @param webView <#webView description#>
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"%s", __func__);
    
    if (self.crmWebViewDelegate && [self.crmWebViewDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.crmWebViewDelegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%s", __func__);
    
    if (self.crmWebViewDelegate && [self.crmWebViewDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.crmWebViewDelegate webView:webView didFailLoadWithError:error];
    }
}

#pragma mark - <NSURLConnectionDelegate>

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    if (NSURLErrorNotConnectedToInternet == error.code) {
        //错误处理
    }else if (connection.currentRequest.timeoutInterval >= 5.0f){
        //超时处理
    }
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    NSLog(@"%s", __func__);
    if (challenge.previousFailureCount == 0) {
        //_authenticated = YES;
        //获取der格式CA证书路径
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:kCRMWebviewValidation ofType:@"cer"];
        // 提取二进制内容
        NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
        
        // 根据二进制内容提取证书信息
        SecCertificateRef certificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)cerData);
        // 形成钥匙链
        NSArray *trustedCertificates = @[CFBridgingRelease(certificate)];
        //NSArray *trustedCertificates = @[(__bridge id)certificate];
        
        //取出服务器证书
        SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
        SecTrustResultType trustResult;
        
        //CFRelease(serverTrust);
        //注意：这里将之前导入的证书设置成下面验证的Trust Object anchor certificate(信任对象的锚点证书)
        SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)trustedCertificates);
        
        OSStatus status = SecTrustEvaluate(serverTrust, &trustResult);
        
        if (status == errSecSuccess && (trustResult == kSecTrustResultProceed || trustResult == kSecTrustResultUnspecified)) {
            
            //验证成功，生成NSURLCredential凭证cred，告知challenge的sender使用这个凭证来继续连接
            _authenticated = YES;
            
            NSURLCredential *cre = [NSURLCredential credentialForTrust:serverTrust];
            [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
            [self showAlertWithTitle:@"验证成功" message:[NSString stringWithFormat:@"%@", challenge]];
        }else{
            //验证失败，取消这次验证流程
            _authenticated = NO;
            
            [challenge.sender cancelAuthenticationChallenge:challenge];
            [self showAlertWithTitle:@"验证失败" message:[NSString stringWithFormat:@"%@", challenge]];
        }
    }
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    
    NSString *method = [protectionSpace authenticationMethod];
    if (NSURLAuthenticationMethodServerTrust == method) {
        return YES;
    }
    return NO;
}

#pragma mark - <NSURLConnectionDataDelegate>

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    //_authenticated = YES;
    [_urlConnection cancel];
    [self.crmHttpsWebView loadRequest:_request];
}

//测试用的提示框
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
}


@end

