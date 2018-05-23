//
//  UIButton+XNB.h
//  XNBasicUIKit
//
//  Created by 江红胡 on 2017/9/30.
//

#import <UIKit/UIKit.h>

@interface UIButton (XNB)

/**
 快速创建UIButton
 @param type        buttonType
 @param title       buttonTitle
 @param alignment   titleAlign
 @param fontSize    titleSize
 @param titleColor  字体颜色
 @param backGroundColor 背景颜色
 @return            UIButton
 */
+ (instancetype)buttonWithType:(UIButtonType)type
                   normalTitle:(NSString *)title
                 textAlignment:(NSTextAlignment)alignment
                          font:(CGFloat)fontSize
                    titleColor:(UIColor *)titleColor
               backGroundColor:(UIColor *)backGroundColor;


// 
- (void)mdf_setBackgroundImageByColor:(UIColor *)color forState:(UIControlState)state;

@end
