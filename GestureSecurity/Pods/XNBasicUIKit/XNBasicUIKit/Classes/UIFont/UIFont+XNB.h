//
//  UIFont+XNB.h
//  XNBasicFramework
//
//  Created by 江红胡 on 2017/9/26.
//

#import <UIKit/UIKit.h>

@interface UIFont (XNB)

// 细体
+ (UIFont *)xnb_thinFontOfSize:(CGFloat)fontSize;

// 正常
+ (UIFont *)xnb_normalFontOfSize:(CGFloat)fontSize;

// 粗体
+ (UIFont *)xnb_boldFontOfSize:(CGFloat)fontSize;

// PingFangSC-Medium
+ (UIFont *)xnb_PingFangSCMediumOfSize:(CGFloat)fontSize;

// PingFangSC-Regular
+ (UIFont *)xnb_PingFangSCRegularOfSize:(CGFloat)fontSize;

@end
