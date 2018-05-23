//
//  UIApplication+XNB.h
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/26.
//

#import <UIKit/UIKit.h>

@interface UIApplication (XNB)

// 获取当前活跃的UIViewController
- (UIViewController *)xnb_currentActivityViewController;

// 打开App的系统设置面板
- (void)xnb_openSettingPage;

// 拨打电话
- (void)xnb_telTo:(NSString *)phoneNumber;

// 注册推送通知
- (void)xnb_registerNotificationSettings;

// 是否开启推送通知
- (BOOL)xnb_allowedNotification;

// 打开系统推送通知设置页面
- (void)xnb_openNotificationSettings;

// 打开app在appStore的主页面
- (void)xnb_openAppStoreWithAppId:(NSString *)appId;

// 打开app在appStore的评价页面
- (void)xnb_openAppStoreReviewsWithAppId:(NSString *)appId;

@end
