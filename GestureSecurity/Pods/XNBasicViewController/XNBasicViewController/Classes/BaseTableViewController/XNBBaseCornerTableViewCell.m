//
//  XNBBaseCornerTableViewCell.m
//  AFNetworking
//
//  Created by 江红胡 on 2018/1/19.
//

#import "XNBBaseCornerTableViewCell.h"
#import "ALView+PureLayout.h"

@interface XNBBaseCornerTableViewCell ()

@property (nonatomic, strong) UIView *cornerView;

@property (nonatomic, strong) UIView *highlightedView;

@end


@implementation XNBBaseCornerTableViewCell

- (void)setupSubViews
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (UIView *)setupCornerView:(UIEdgeInsets)marginInsets
           withCornerRadius:(CGFloat)cornerRadius
            backgroundColor:(UIColor *)backgroundColor
           highlightedColor:(UIColor *)highlightedColor
{
    _cornerView = [[UIView alloc] initForAutoLayout];
    self.cornerView.clipsToBounds = YES;
    self.cornerView.layer.cornerRadius = cornerRadius;
    self.cornerView.layer.backgroundColor = backgroundColor.CGColor;
    [self.contentView addSubview:self.cornerView];
    [self.cornerView autoPinEdgesToSuperviewEdgesWithInsets:marginInsets];
    
    _highlightedView = [[UIView alloc] initForAutoLayout];
    self.highlightedView.hidden = YES;
    self.highlightedView.backgroundColor = highlightedColor;
    [self.cornerView addSubview:self.highlightedView];
    [self.highlightedView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    return self.cornerView;
}

#pragma mark - Highlighted
- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.highlightedView.hidden = NO;
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.highlightedView.hidden = YES;
        });
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self setHighlighted:YES];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self setHighlighted:NO];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setHighlighted:NO];
}

@end
