//
//  UIScrollView+XNB.h
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/26.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (XNB)

@property (nonatomic, assign) CGFloat contentOffsetX;
@property (nonatomic, assign) CGFloat contentOffsetY;

@property (nonatomic, assign) CGFloat contentInsetTop;
@property (nonatomic, assign) CGFloat contentInsetLeft;
@property (nonatomic, assign) CGFloat contentInsetBottom;
@property (nonatomic, assign) CGFloat contentInsetRight;

@property (nonatomic, assign) CGFloat scrollIndicatorInsetTop;
@property (nonatomic, assign) CGFloat scrollIndicatorInsetLeft;
@property (nonatomic, assign) CGFloat scrollIndicatorInsetBottom;
@property (nonatomic, assign) CGFloat scrollIndicatorInsetRight;

@property (nonatomic, assign) CGFloat contentSizeWidth;
@property (nonatomic, assign) CGFloat contentSizeHeight;

- (void)xnb_stopScrolling;

- (BOOL)xnb_isScrollToBottom;
- (BOOL)xnb_isScrollToBottomWithDeviation:(CGFloat)deviation;

@end
