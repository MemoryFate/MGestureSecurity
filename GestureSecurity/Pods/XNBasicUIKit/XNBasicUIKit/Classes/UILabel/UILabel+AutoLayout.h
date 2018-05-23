//
//  UILabel+AutoLayout.h
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/26.
//

#import <UIKit/UIKit.h>

@interface UILabel (AutoLayout)

// 返回对应alignment的label 默认label使用autoLayout
+ (instancetype)xnb_labelWithTextAlignment:(NSTextAlignment)alignment;

/**
 快速实例化一个UILabel
 @param font    字体大小
 @param bColor  背景色
 @param tColor  字体颜色
 @param alignment 文本排列
 @param isWarp  是否换行
 @return        UIlabel
 */
+ (instancetype)xnb_labelWithFont:(UIFont *)font
                  backGroundColor:(UIColor *)bColor
                        textColor:(UIColor *)tColor
                    textAlignment:(NSTextAlignment)alignment
                           isWarp:(BOOL)isWarp;


@end
