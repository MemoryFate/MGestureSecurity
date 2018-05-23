//
//  UIView+Corner.m
//  XNBasicUIKit
//
//  Created by 江红胡 on 2017/9/30.
//

#import "UIView+Corner.h"

@implementation UIView (Corner)

- (void)xnb_setCornerRadii:(CGSize)cornerRadii forRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
