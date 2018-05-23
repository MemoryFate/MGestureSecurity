//
//  UIView+Corner.h
//  XNBasicUIKit
//
//  Created by 江红胡 on 2017/9/30.
//

#import <UIKit/UIKit.h>

@interface UIView (Corner)

// 设置圆角 corners指定哪几个角圆角
- (void)xnb_setCornerRadii:(CGSize)cornerRadii forRoundingCorners:(UIRectCorner)corners;

@end
