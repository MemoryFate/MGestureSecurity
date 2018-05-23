//
//  XNBBaseWebViewProtocol.h
//  XNBasicViewController
//
//  Created by 江红胡 on 2017/11/20.
//

#ifndef XNBBaseWebViewProtocol_h
#define XNBBaseWebViewProtocol_h

@protocol XNBBaseWebViewProtocol <NSObject>

@optional
// 加载关闭按钮  如需自定义样式，重写
- (void)loadCloseBarItem;

// 开始webView 请求
- (void)startWebViewLoading;

// 下拉刷新触发的方法
- (void)pullDownToRefreshAction;


@required
// 注册需要和H5交互的方法
- (void)registerJSMethods;

@end

#endif /* XNBBaseWebViewProtocol_h */
