//
//  XNBasicMacros.h
//  Pods
//
//  Created by 江红胡 on 2017/9/20.
//
//

#ifndef XNBasicMacros_h
#define XNBasicMacros_h

#import <Foundation/Foundation.h>

// 客户端App版本号
#define kXNBClientVersion                   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


// System Size
#define kXNBScreenBounds                    ([UIScreen mainScreen].bounds)
#define kXNBScreenHeight                    ([UIScreen mainScreen].bounds.size.height)
#define kXNBScreenWidth                     ([UIScreen mainScreen].bounds.size.width)
#define kXNBScreenScale                     ([UIScreen mainScreen].scale)
#define kXNBSingleLineHeight                (1.f / [UIScreen mainScreen].scale)
#define kXNBStatusBarHeight                 [UIApplication sharedApplication].statusBarFrame.size.height
#define kXNBNavigationBarHeight             (44.f)
#define kXNBTabBarHeight                    (kXNBScreenIsIPhoneX ? 83.f : 49.f)
#define kXNBNavigationAndStatusBarHeight    (kXNBStatusBarHeight + kXNBNavigationBarHeight)
#define kXNBTableViewBottomButtonHeight     (56.f)
#define kXNBScreenRealWidth                 kXNBScreenWidth * kXNBScreenScale
#define kXNBScreenRealHeight                kXNBScreenHeight * kXNBScreenScale

#define kXNBScreenAutoLayoutScale           (kXNBScreenWidth / 375)
#define kXNBScreenAutoLayoutScaleCeil(x)    ceilf(kXNBScreenAutoLayoutScale*(x))

// iPhone X
#define kXNBScreenIsIPhoneX                 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define kXNBScreenSafeBottomHeight          (kXNBScreenIsIPhoneX ? 34.f : 0.0)

// 图片
#define kXNBImage(name)                     [UIImage imageNamed:name]

// 常用字体颜色
#define kXNBTextColorDefult                 [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]
#define kXNBTextColorDeepGary               [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]
#define kXNBTextColorGary                   [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]

// 常用颜色
#define kXNBGaryBackgroundColor             [UIColor colorWithRed:242/255.0 green:244/255.0 blue:246/255.0 alpha:1]
#define kXNBGaryLineColor                   [UIColor colorWithWhite:0 alpha:0.08]

// 操作系统版本号
#define kXNBCurrentSystemVersion            [[UIDevice currentDevice] systemVersion]

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// DEBUG日志
#ifdef DEBUG
#define XNBLog(s,...) NSLog(@"<%p %@:(%d)>\n  %s\n  %@\n\n", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __func__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define XNBLog(s,...)
#endif

#endif /* XNBasicMacros_h */
