//
//  XNBBaseUIWebViewController.h
//  XNBasicViewController
//
//  Created by 江红胡 on 2017/11/20.
//

#import "XNBBaseViewController.h"
#import "WebViewJavascriptBridge.h"
#import "XNBBaseWebViewProtocol.h"
#import "MJRefreshHeader.h"

@interface XNBBaseUIWebViewController : XNBBaseViewController
<XNBBaseWebViewProtocol, WebViewJavascriptBridgeBaseDelegate, UIWebViewDelegate>

// title为空时，自动获取当前页面标题
+ (instancetype)pushWebViewController:(UINavigationController *)navigationController url:(NSString *)url title:(NSString *)title;

@property (nonatomic, strong) UIWebView *myWebView;

// web url
@property (nonatomic, copy) NSString *urlString;

// 第一次进入时的标题
@property (nonatomic, copy) NSString *initialTitle;

// 导航栏进度条颜色
@property (nonatomic, strong) UIColor *customProgressColor;

@property (nonatomic, weak) id<XNBBaseWebViewProtocol> webViewDelegate;

@property (nonatomic, strong) WebViewJavascriptBridge *webViewBridge;

@property (nonatomic, strong) MJRefreshHeader *refreshHeader;

// 是否需要下拉刷新
@property (nonatomic, assign) BOOL needPullDownRefresh;

// 清楚WKWebView Cookies缓存
- (void)cleanUIWebViewCookiesByURL:(NSString *)url;
- (void)cleanUIWebViewCookies;

@end
