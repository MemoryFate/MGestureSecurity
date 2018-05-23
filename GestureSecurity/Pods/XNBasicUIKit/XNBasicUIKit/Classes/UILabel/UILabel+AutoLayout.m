//
//  UILabel+AutoLayout.m
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/26.
//

#import "UILabel+AutoLayout.h"
#import "ALView+PureLayout.h"

@implementation UILabel (AutoLayout)

+ (instancetype)xnb_labelWithTextAlignment:(NSTextAlignment)alignment
{
    UILabel *label = [[self alloc] initForAutoLayout];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = alignment;
    
    return label;
}

+ (instancetype)xnb_labelWithFont:(UIFont *)font
                  backGroundColor:(UIColor *)bColor
                        textColor:(UIColor *)tColor
                    textAlignment:(NSTextAlignment)alignment
                           isWarp:(BOOL)isWarp
{
    UILabel *label = [self xnb_labelWithTextAlignment:alignment];
    label.font = font;
    label.backgroundColor = bColor;
    label.textColor = tColor;
    label.numberOfLines = isWarp ? 0 : 1;
    [label sizeToFit];
    return label;
}

@end
