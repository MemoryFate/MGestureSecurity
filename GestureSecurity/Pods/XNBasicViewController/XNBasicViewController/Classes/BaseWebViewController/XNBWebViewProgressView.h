//
//  XNBWebViewProgressView.h
//  XNBasicViewController
//
//  Created by 江红胡 on 2018/2/7.
//

#import <UIKit/UIKit.h>

@interface XNBWebViewProgressView : UIView

// lineColor:进度条颜色
- (instancetype)initWithFrame:(CGRect)frame withLineColor:(UIColor *)lineColor;

// 开始加载
- (void)startLoadingAnimation;

// 结束加载
- (void)endLoadingAnimation;

@end
