//
//  XNBBaseViewController.h
//  XNBasicViewController
//
//  Created by 江红胡 on 2017/9/30.
//

#import <UIKit/UIKit.h>
#import "XNBBaseRequestModel.h"

typedef NS_ENUM(NSInteger, XNBViewControllerLoadingType) {
    XNBViewControllerLoadingTypeNormal,     // 正常
    XNBViewControllerLoadingTypeFullScreen, // 全屏不能操作
    XNBViewControllerLoadingTypeView        // View不能操作
};


@interface XNBBaseViewController : UIViewController

// 返回方法 通用
- (void)backToLastViewController;

@end


@interface XNBBaseViewController (NavigationBar)

// 设置导航标题
- (void)setNavBarTitle:(NSString *)title textColor:(UIColor *)textColor fontSize:(CGFloat)font;

// 设置导航栏标题图片
- (void)setNavBarTitle:(UIImage *)titleImage;

// 根据文字设置左导航按钮
- (void)setNavBarLeftItem:(NSString *)title textColor:(UIColor *)textColor;

// 根据文字设置右导航按钮
- (void)setNavBarRightItem:(NSString *)title textColor:(UIColor *)textColor;

// 根据图片设置左导航按钮
- (void)setNavBarLeftItem:(UIImage *)normalImage hightedImage:(UIImage *)hightedImage;

// 根据图片设置右导航按钮
- (void)setNavBarRightItem:(UIImage *)normalImage hightedImage:(UIImage *)hightedImage;

#pragma mark - Actions
// 默认的返回按钮
- (void)setDefaultBackBarItem;

// 返回按钮的回调
- (void)onPressedBackBarButton;

// 左边button回调
- (void)onPressedLeftBarItem;

// 右边button回调
- (void)onPressedRightBarItem;

@end


@interface XNBBaseViewController (Loading)

// 页面是否正在加载
@property (nonatomic, assign, readonly) BOOL isPageLoading;

// 显示页面加载
- (void)showCommonLoading;
- (void)showCommonLoading:(XNBViewControllerLoadingType)loadingType;
- (void)showCommonLoading:(XNBViewControllerLoadingType)loadingType offsetY:(CGFloat)offsetY;

// 页面加载完毕
- (void)dismissLoading;

@end


@interface XNBBaseViewController (Network)

// 配置model
- (XNBBaseRequestModel *)produceModel:(Class)modelClass;

// 请求成功
- (void)handleDataModelSuccess:(XNBBaseRequestModel *)xncashcatModel;
// 请求失败
- (void)handleDataModelError:(XNBBaseRequestModel *)xncashcatModel;
// 网络异常
- (void)handleNetworkError:(XNBBaseRequestModel *)xncashcatModel;

@end
