//
//  XNBBaseUIWebViewController.m
//  XNBasicViewController
//
//  Created by 江红胡 on 2017/11/20.
//

#import "XNBBaseUIWebViewController.h"
#import "XNBasicMacros.h"
#import "MJRefreshNormalHeader.h"
#import "XNBAlertView.h"
#import "XNBWebViewProgressView.h"

@interface XNBBaseUIWebViewController ()

@property (nonatomic, strong) XNBWebViewProgressView *progressView;          // 进度条

@property (nonatomic, strong) UIBarButtonItem *closeBarItem;                 // 关闭按钮

@end


@implementation XNBBaseUIWebViewController

+ (instancetype)pushWebViewController:(UINavigationController *)navigationController url:(NSString *)url title:(NSString *)title
{
    XNBBaseUIWebViewController *baseWebVC = nil;
    if (navigationController && [self isSubclassOfClass:[XNBBaseUIWebViewController class]]) {
        baseWebVC = [[[self class] alloc] init];
        baseWebVC.urlString = url;
        baseWebVC.initialTitle = title;
        
        [navigationController pushViewController:baseWebVC animated:YES];
    }
    
    return baseWebVC;
}

#pragma mark - Life Circle
- (void)dealloc
{
    _myWebView.scrollView.delegate = nil;
    _myWebView.delegate = nil;
    _myWebView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUIWebView];
    
    [self registerJSMethods];
    
    [self startWebViewLoading];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar addSubview:self.progressView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.progressView removeFromSuperview];
}

#pragma mark - Common Setup
- (void)setupUIWebView
{
    [self.view addSubview:self.myWebView];
    self.myWebView.delegate = self;
    
    [self.view addSubview:self.progressView];
    
    self.webViewDelegate = self;
}

- (void)onPressedBackBarButton
{
    if ([self.myWebView canGoBack]) {
        [self.myWebView goBack];
    } else {
        [self backToLastViewController];
    }
}

#pragma mark - Property
- (UIWebView *)myWebView
{
    if (!_myWebView) {
        _myWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _myWebView.scalesPageToFit = YES;
        _myWebView.userInteractionEnabled = YES;
        _myWebView.opaque = YES;
        _myWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        _myWebView.delegate = self;
    }
    
    return _myWebView;
}

- (XNBWebViewProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[XNBWebViewProgressView alloc] initWithFrame:CGRectMake(0, kXNBNavigationBarHeight - 2.f, kXNBScreenWidth, 2.f) withLineColor:self.customProgressColor ?: [UIColor blueColor]];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    
    return _progressView;
}

- (void)setNeedPullDownRefresh:(BOOL)needPullDownRefresh
{
    _needPullDownRefresh = needPullDownRefresh;
    if (_needPullDownRefresh) {
        if (!_refreshHeader) {
            self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownToRefreshAction)];
        }
        
        self.myWebView.scrollView.mj_header = self.refreshHeader;
    } else {
        [self.myWebView.scrollView.mj_header removeFromSuperview];
    }
}

#pragma mark - Method
- (void)cleanUIWebViewCookiesByURL:(NSString *)url
{
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *arr_cookies = [cookies cookiesForURL:[NSURL URLWithString:url]];
    for (NSHTTPCookie *cookie in arr_cookies) {
        [cookies deleteCookie:cookie];
    }
}

- (void)cleanUIWebViewCookies
{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
        [cookieStorage deleteCookie:cookie];
    }
}

#pragma mark - XNBBaseWebViewProtocol
- (void)loadCloseBarItem
{
    // 子类如没重写，则默认以下代码
    UIButton *item = [[UIButton alloc] init];
    [item setTitle:@"关闭" forState:UIControlStateNormal];
    [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [item addTarget:self action:@selector(backToLastViewController) forControlEvents:UIControlEventTouchUpInside];
    
    _closeBarItem = [[UIBarButtonItem alloc] initWithCustomView:item];
    
    [self.navigationItem setLeftBarButtonItems:@[self.navigationItem.leftBarButtonItem, _closeBarItem]];
}

- (void)registerJSMethods
{
    [self _setupWebViewBridge];
    
    // 交给子类处理
    
}

- (void)startWebViewLoading
{
    // 子类如没重写，则默认以下代码
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    request.timeoutInterval = 15.f;
    
    [self.myWebView loadRequest:request];
}

- (void)pullDownToRefreshAction
{
    // 交给子类处理
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // 开始加载
    [self.progressView startLoadingAnimation];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 完成加载
    [self.progressView endLoadingAnimation];
    [self.refreshHeader endRefreshing];
    
    NSString *pageTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = [webView canGoBack] ? pageTitle : (self.initialTitle.length ? self.initialTitle : pageTitle);;
    
    [self _showCloseBarItem];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // 加载失败
    [self.progressView endLoadingAnimation];
    [self.refreshHeader endRefreshing];
    
    [self _showCloseBarItem];
}

#pragma mark - Others
- (void)_showCloseBarItem
{
    // 层级>1时，展示关闭按钮
    if ([self.myWebView canGoBack]) {
        [self loadCloseBarItem];
    } else {
        self.navigationItem.leftBarButtonItems = nil;
        [self setDefaultBackBarItem];
    }
}

- (void)_setupWebViewBridge
{
    [WebViewJavascriptBridge enableLogging];
    self.webViewBridge = [WebViewJavascriptBridge bridgeForWebView:self.myWebView];
    [self.webViewBridge setWebViewDelegate:self];
}

@end

