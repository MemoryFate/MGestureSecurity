//
//  UIView+BackgroundColor.m
//  Pods
//
//  Created by Luo on 2017/11/2.
//

#import "UIView+BackgroundColor.h"

@implementation UIView (BackgroundColor)

-(void)xnb_setGradientBackgroundColorWithStartColor:(UIColor *)startColor EndColor:(UIColor *)endColor StartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint{
    //  创建 CAGradientLayer 对象
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    //  设置 gradientLayer 的 Frame
    gradientLayer.frame = self.bounds;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(id)startColor.CGColor,
                             (id)endColor.CGColor];
    //  设置三种颜色变化点，取值范围 0.0~1.0
    //        gradientLayer.locations = @[@(0.1f) ,@(0.4f)];
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(startPoint.x, startPoint.y);
    gradientLayer.endPoint = CGPointMake(endPoint.x,endPoint.y);
    //  添加渐变色到创建的 UIView 上去
    [self.layer addSublayer:gradientLayer];
}

@end
