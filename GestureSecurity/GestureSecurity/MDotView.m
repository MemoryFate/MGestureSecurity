//
//  MDotView.m
//  GestureSecurity
//
//  Created by MemoryFate on 2018/5/16.
//  Copyright © 2018年 MemoryFate. All rights reserved.
//

#import "MDotView.h"

@interface MDotView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation MDotView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.layer.cornerRadius = self.height / 2;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor blueColor].CGColor;
    self.layer.borderWidth = 2;
    self.viewEnabled = YES;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:self.height / 4 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.path = bezierPath.CGPath;
    self.shapeLayer.fillColor = [UIColor blueColor].CGColor;
    
    [self.layer addSublayer: self.shapeLayer];
}

- (void)viewEnabled:(BOOL)viewEnabled {
    _viewEnabled = viewEnabled;
    if (viewEnabled) {
        self.shapeLayer.fillColor = [UIColor blueColor].CGColor;
    }else {
        self.shapeLayer.fillColor = [UIColor redColor].CGColor;
    }
}

@end
