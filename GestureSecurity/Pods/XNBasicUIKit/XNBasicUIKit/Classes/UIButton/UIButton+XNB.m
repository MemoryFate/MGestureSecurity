//
//  UIButton+XNB.m
//  XNBasicUIKit
//
//  Created by 江红胡 on 2017/9/30.
//

#import "UIButton+XNB.h"
#import "UIColor+XNB.h"

@implementation UIButton (XNB)

+ (instancetype)buttonWithType:(UIButtonType)type
                   normalTitle:(NSString *)title
                 textAlignment:(NSTextAlignment)alignment
                          font:(CGFloat)fontSize
                    titleColor:(UIColor *)titleColor
               backGroundColor:(UIColor *)backGroundColor
{
    UIButton *button = [self buttonWithType:type];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.textAlignment = alignment;
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    button.backgroundColor = backGroundColor;
    [button sizeToFit];
    
    return button;
}

- (void)mdf_setBackgroundImageByColor:(UIColor *)color forState:(UIControlState)state
{
    [self setBackgroundImage:[UIColor xnb_imageWithColor:color] forState:state];
}

@end
