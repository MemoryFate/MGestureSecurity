//
//  XNBWebViewProgressView.m
//  XNBasicViewController
//
//  Created by 江红胡 on 2018/2/7.
//

#import "XNBWebViewProgressView.h"
#import "UIView+Frame.h"
#import "XNBasicMacros.h"

@implementation XNBWebViewProgressView

- (instancetype)initWithFrame:(CGRect)frame withLineColor:(UIColor *)lineColor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.backgroundColor = lineColor;
    }
    
    return self;
}

- (void)startLoadingAnimation
{
    self.hidden = NO;
    self.width = 0.f;
    
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        weakSelf.width = kXNBScreenWidth * 0.6;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            weakSelf.width = kXNBScreenWidth * 0.8;
        }];
    }];
}

- (void)endLoadingAnimation
{
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.width = kXNBScreenWidth;
    } completion:^(BOOL finished) {
        weakSelf.hidden = YES;
    }];
}

@end
