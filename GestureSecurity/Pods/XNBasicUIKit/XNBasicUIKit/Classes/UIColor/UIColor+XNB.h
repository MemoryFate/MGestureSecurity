//
//  UIColor+XNB.h
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/26.
//

#import <UIKit/UIKit.h>

@interface UIColor (XNB)

// 根据key来获取颜色 (alpha 默认为 1)
+ (UIColor *)xnb_colorForKey:(NSString *)key;

// 根据key 与 alpha 来获取颜色
+ (UIColor *)xnb_colorForKey:(NSString *)key alpha:(CGFloat)alpha;

// UIColor 转 UIImage
+ (UIImage *)xnb_imageWithColor:(UIColor *)color;

// 随机颜色
+ (UIColor *)xnb_randomColor;

@end
