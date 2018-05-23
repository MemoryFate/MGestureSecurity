//
//  UIView+GestureRecognizer.h
//  XNBasicFramework
//
//  Created by 江红胡 on 2017/9/26.
//

#import <UIKit/UIKit.h>

typedef void(^XNBGestureRecognizerActionBlock)(UIGestureRecognizer *gestureRecognizer);

@interface UIView (GestureRecognizer)

// 移除手势
- (void)xnb_removeAllGestures;

// single tapped
- (void)xnb_whenSingleTapped:(XNBGestureRecognizerActionBlock )block;

// double tapped
- (void)xnb_whenDoubleTapped:(XNBGestureRecognizerActionBlock )block;

// long pressed
- (void)xnb_whenLongPressed:(XNBGestureRecognizerActionBlock )block;

@end
