//
//  UIView+BackgroundColor.h
//  Pods
//
//  Created by Luo on 2017/11/2.
//

#import <UIKit/UIKit.h>

@interface UIView (BackgroundColor)

/**
  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
 */
-(void)xnb_setGradientBackgroundColorWithStartColor:(UIColor *)color EndColor:(UIColor *)endColor StartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint;

@end
