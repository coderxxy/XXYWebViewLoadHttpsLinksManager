# XXYWebViewLoadHttpsLinksManager
webView加载https 需要验证证书.cer 格式
demo应用：
1. 如果想使用可以直接把 'XXYWebViewLoadHttpsLinksManager.h'文件倒入到工程中，遵守webview代理；
2. 创建自己的webview
- (void)createWebView{
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webViewManager = [[XXYWebViewLoadHttpsLinksManager alloc] init];
    _webViewManager.crmHttpsWebView = _webView;
    id webViewDelegate = _webView.delegate;
    _webView.delegate = _webViewManager;
    _webViewManager.crmWebViewDelegate = webViewDelegate;
    //以下三个网站是为了验证demo是否可以行。
    //分别是有证书https链接，无证书https链接以及无需验证http链接
    //https://www.cacert.org/
    //https://wwww.baidu.com
    //http://www.sina.com
    //https://www.cacert.org/
    //https://wwww.baidu.com
    //http://www.sina.com
    NSString *urlStr = @"https://www.cacert.org/";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}
