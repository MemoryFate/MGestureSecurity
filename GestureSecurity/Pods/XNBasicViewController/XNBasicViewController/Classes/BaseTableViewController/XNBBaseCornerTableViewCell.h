//
//  XNBBaseCornerTableViewCell.h
//  AFNetworking
//
//  Created by 江红胡 on 2018/1/19.
//

#import "XNBBaseTableViewCell.h"

@interface XNBBaseCornerTableViewCell : XNBBaseTableViewCell

- (UIView *)setupCornerView:(UIEdgeInsets)marginInsets
           withCornerRadius:(CGFloat)cornerRadius
            backgroundColor:(UIColor *)backgroundColor
           highlightedColor:(UIColor *)highlightedColor;

@end
