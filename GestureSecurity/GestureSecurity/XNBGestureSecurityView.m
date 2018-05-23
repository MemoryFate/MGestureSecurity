//
//  XNBGestureSecurityView.m
//  GestureSecurity
//
//  Created by MemoryFate on 2018/5/16.
//  Copyright © 2018年 MemoryFate. All rights reserved.
//

#import "XNBGestureSecurityView.h"
#import "XNBDotView.h"

@interface XNBGestureSecurityView ()

/**
 *  用于存放视图的数组
 */
@property (nonatomic, copy) NSMutableArray *viewAry;

/**
 *  用于存放选中视图的数组
 */
@property (nonatomic, copy) NSMutableArray *sequenceAry;

/**
 *  密码手势设置完成之后返回一组密码
 */
@property (nonatomic, strong) NSString *pwdStr;

@end

@implementation XNBGestureSecurityView
{
    //  当前坐标点
    CGPoint _currentPoint;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

//  每次移动手指时候都调用此方法
- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor whiteColor];
    
    if (self.sequenceAry.count == 0) return;
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 5;
    [[UIColor blueColor] set];
    for (int i = 0; i < self.sequenceAry.count; i++) {
        XNBDotView *view = (XNBDotView *)self.sequenceAry[i];
        if (i == 0) {
            [path moveToPoint:view.center];
        }else {
            [path addLineToPoint:view.center];
        }
    }
    [path addLineToPoint:_currentPoint];
    path.lineJoinStyle = kCGLineJoinRound;
    [path stroke];
}

- (void)setupViews {
    self.backgroundColor = [UIColor whiteColor];
    int k = 0;
    for (int i = 0; i < 3; i ++) {
        for (int j = 0; j < 3; j ++) {
            k ++;
            XNBDotView *view = [[XNBDotView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            view.center = CGPointMake(self.width / 6 + self.width / 3 * j, self.height / 6 + self.height / 3 * i);
            view.tag = 1000000 + k;
            [self addSubview: view];
            [self.viewAry addObject:view];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 获取当前触摸点的坐标
    UITouch *touch = (UITouch *)[touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    for (int i = 0; i < self.viewAry.count; i++) {
        
        XNBDotView *view = (XNBDotView *)self.viewAry[i];
        
        //  开始时候判断初始手势是否在点的范围内
        if (CGRectContainsPoint(view.frame, point)) {
            view.viewEnabled = NO;
            [self.sequenceAry addObject:view];
            self.pwdStr = [NSString stringWithFormat:@"%ld",view.tag - 1000000];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = (UITouch *)[touches anyObject];
    CGPoint point = [touch locationInView:self];
    _currentPoint = point;
    for (int i = 0; i < self.viewAry.count; i++) {
        XNBDotView *view = (XNBDotView *)self.viewAry[i];
        if (CGRectContainsPoint(view.frame, point) && view.viewEnabled) {
            view.viewEnabled = NO;
            [self.sequenceAry addObject:view];
            self.pwdStr = [NSString stringWithFormat:@"%@%ld",self.pwdStr,view.tag - 1000000];
        }
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //  手势绘画完成后返回密码的字符串
    if (self.didFinishBlock) {
        self.didFinishBlock(self.pwdStr);
    }
    XNBDotView *view = (XNBDotView *)[self.sequenceAry lastObject];
    _currentPoint = view.center;
    [self setNeedsDisplay];
    [self removeAllPath];
}

/**
 *  移除所有路径,初始化状态
 */
- (void)removeAllPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0; i < self.viewAry.count; i++) {
            XNBDotView *view = (XNBDotView *)self.viewAry[i];
            view.viewEnabled = YES;
        }
        [self.sequenceAry removeAllObjects];
        self.pwdStr = @"";
        [self setNeedsDisplay];
    });
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

#pragma mark - 懒加载
- (NSMutableArray *)viewAry {
    if (!_viewAry) {
        _viewAry = [NSMutableArray array];
    }
    return _viewAry;
}

- (NSMutableArray *)sequenceAry {
    if (!_sequenceAry) {
        _sequenceAry = [NSMutableArray array];
    }
    return _sequenceAry;
}

@end
