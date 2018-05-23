//
//  XNBBaseWKWebViewController.h
//  XNBasicViewController
//
//  Created by 江红胡 on 2017/10/9.
//

#import "XNBBaseViewController.h"
#import <WebKit/WebKit.h>
#import "WKWebViewJavascriptBridge.h"
#import "XNBBaseWebViewProtocol.h"
#import "MJRefreshHeader.h"

@interface XNBBaseWKWebViewController : XNBBaseViewController
<XNBBaseWebViewProtocol, WebViewJavascriptBridgeBaseDelegate>

// title为空时，自动获取当前页面标题
+ (instancetype)pushWebViewController:(UINavigationController *)navigationController url:(NSString *)url title:(NSString *)title;

@property (nonatomic, strong) WKWebView *myWebView;

// web url
@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, weak) id<XNBBaseWebViewProtocol> webViewDelegate;

@property (nonatomic, strong) WKWebViewJavascriptBridge *webViewBridge;

@property (nonatomic, strong) MJRefreshHeader *refreshHeader;

// 是否需要下拉刷新
@property (nonatomic, assign) BOOL needPullDownRefresh;

// 清楚WKWebView Cookies缓存
- (void)cleanWKWebViewCookies;

@end
