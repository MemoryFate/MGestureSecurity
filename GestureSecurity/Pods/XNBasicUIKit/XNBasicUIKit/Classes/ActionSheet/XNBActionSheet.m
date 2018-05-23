//
//  XNBActionSheet.m
//  XNBasicUIKit
//
//  Created by 王嘉倩 on 2017/12/8.
//

#import "XNBActionSheet.h"
#import "PureLayout.h"
#import "UIImage+XNB.h"
#import "UIColor+XNB.h"
#import "UIFont+XNB.h"

#define kSCREENWIDTH (float)([UIScreen mainScreen].bounds.size.width)
#define kSCREENHEIGHT (float)([UIScreen mainScreen].bounds.size.height)
#define SHEETBOTTOM ((kSCREENHEIGHT- 812) ? 8.5f : (8.5f+34.f))

static CGFloat const SHEETHEIGHT = 57.f;

typedef void (^cancel)(void);
typedef void (^choose)(int index);

@interface XNBActionSheet ()

@property (nonatomic, strong) UIView *actionSheetView;
@property (nonatomic, strong) UIView *defaultActionSheetView;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat count;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, copy) choose confirmParam;
@property (nonatomic, copy) cancel cancleParam;
@property (nonatomic, strong) NSLayoutConstraint *topConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) NSArray *titleArr;

@end

@implementation XNBActionSheet

- (instancetype)init {
    
    if (self = [super init]) {
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        [self drawSubViews];
        
        [self setNeedsUpdateConstraints];
        
    }
    return self;
}

- (instancetype)initCancelActionWithTitle:(NSString *)title handler:(void (^)(void))handler {
    if (self = [super init]) {
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        [self drawSubViews];
        
        [self setNeedsUpdateConstraints];
        
        [self addCancelWithTitle:title handler:handler];
        
    }
    return self;
}

- (void)addActionWithTitleArr:(NSArray *)titleArr handler:(void (^)(int index))handler {
    
    _titleArr = titleArr;
    
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *chooseBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [chooseBtn setBackgroundImage:[UIImage xnb_imageWithColor:[UIColor whiteColor]] forState:(UIControlStateNormal)];
        [chooseBtn setBackgroundImage:[UIImage xnb_imageWithColor:[UIColor xnb_colorForKey:@"eeeeee"]] forState:(UIControlStateHighlighted)];
        chooseBtn.titleLabel.font = [UIFont xnb_normalFontOfSize:16];
        chooseBtn.tag = 1590 + i;
        [chooseBtn setTitle:titleArr[i] forState:(UIControlStateNormal)];
        [chooseBtn setTitleColor:[UIColor xnb_colorForKey:@"333333"] forState:(UIControlStateNormal)];
        [chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_defaultActionSheetView addSubview:chooseBtn];
        
        [chooseBtn autoPinEdgeToSuperviewEdge:(ALEdgeLeft) withInset:0];
        [chooseBtn autoPinEdgeToSuperviewEdge:(ALEdgeRight) withInset:0];
        [chooseBtn autoPinEdgeToSuperviewEdge:(ALEdgeTop) withInset:SHEETHEIGHT * i];
        [chooseBtn autoSetDimension:(ALDimensionHeight) toSize:SHEETHEIGHT];
    }
    
    for (int i = 0; i < titleArr.count - 1; i++) {
        
        UIView *lineView = [UIView newAutoLayoutView];
        lineView.tag = 789456+i;
        lineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.08];
        [_defaultActionSheetView addSubview:lineView];
        
        [lineView autoPinEdgeToSuperviewEdge:(ALEdgeLeft) withInset:0];
        [lineView autoPinEdgeToSuperviewEdge:(ALEdgeRight) withInset:0];
        [lineView autoPinEdgeToSuperviewEdge:(ALEdgeTop) withInset:SHEETHEIGHT * (i+1)];
        [lineView autoSetDimension:(ALDimensionHeight) toSize:0.5];
    
    }
    _count = titleArr.count;
    if (_top == 0) {
        _top = kSCREENHEIGHT - SHEETHEIGHT * _count  - SHEETBOTTOM;
    } else {
        _top = _top - SHEETHEIGHT * _count - 7;
    }
    
    _confirmParam = handler;
    
    [self show];
}


- (void)addCancelWithTitle:(NSString *)title handler:(void (^)(void))handler {
    _top = kSCREENHEIGHT - SHEETHEIGHT - SHEETBOTTOM;
    
    UIButton *cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [cancelBtn setBackgroundImage:[UIImage xnb_imageWithColor:[UIColor whiteColor]] forState:(UIControlStateNormal)];
    [cancelBtn setBackgroundImage:[UIImage xnb_imageWithColor:[UIColor xnb_colorForKey:@"eeeeee"]] forState:(UIControlStateHighlighted)];
    cancelBtn.clipsToBounds = YES;
    cancelBtn.titleLabel.font = [UIFont xnb_normalFontOfSize:16];
    [cancelBtn setTitle:title forState:(UIControlStateNormal)];
    [cancelBtn setTitleColor:[UIColor xnb_colorForKey:@"ff9f69"] forState:(UIControlStateNormal)];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [_actionSheetView addSubview:cancelBtn];
    _cancleParam = handler;
    _cancelBtn = cancelBtn;
}

- (void)show {
    __weak XNBActionSheet *weakSelf = self;
    double delayInSeconds = 0.1f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf setNeedsUpdateConstraints];
        [weakSelf updateConstraintsIfNeeded];
        [UIView animateWithDuration:0.2f animations:^{
            [weakSelf layoutIfNeeded];
        }];
    });
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)cancelBtnClick {
    [self dismiss];
    if (_cancleParam) {
        _cancleParam();
    }
}

- (void)chooseBtnClick:(UIButton *)button {
    [self dismiss];
    if (_confirmParam) {
        _confirmParam((int)button.tag - 1590);
    }
}

- (void)updateConstraints {
    if (!self.didSetupConstraints) {
        if (_cancelBtn) {
            [_cancelBtn autoSetDimension:(ALDimensionHeight) toSize:SHEETHEIGHT];
            [_cancelBtn autoPinEdgeToSuperviewEdge:(ALEdgeLeft) withInset:10];
            [_cancelBtn autoPinEdgeToSuperviewEdge:(ALEdgeRight) withInset:10];
            [_cancelBtn autoPinEdgeToSuperviewEdge:(ALEdgeBottom) withInset:SHEETBOTTOM];
        }
        if (_titleArr.count) {
            
            for (int i = 0; i < _titleArr.count; i++) {
                
                UIButton *chooseBtn = [_defaultActionSheetView viewWithTag:1590 + i];
                [chooseBtn autoPinEdgeToSuperviewEdge:(ALEdgeLeft) withInset:0];
                [chooseBtn autoPinEdgeToSuperviewEdge:(ALEdgeRight) withInset:0];
                [chooseBtn autoPinEdgeToSuperviewEdge:(ALEdgeTop) withInset:SHEETHEIGHT * i];
                [chooseBtn autoSetDimension:(ALDimensionHeight) toSize:SHEETHEIGHT];
                
                if (i > 0) {
                    UIView *lineView = [_defaultActionSheetView viewWithTag:789456+i];
                    [lineView autoPinEdgeToSuperviewEdge:(ALEdgeLeft) withInset:0];
                    [lineView autoPinEdgeToSuperviewEdge:(ALEdgeRight) withInset:0];
                    [lineView autoPinEdgeToSuperviewEdge:(ALEdgeTop) withInset:SHEETHEIGHT * (i+1)];
                    [lineView autoSetDimension:(ALDimensionHeight) toSize:0.5];
                }
                
            }
        }
        
        [_defaultActionSheetView autoPinEdgeToSuperviewEdge:(ALEdgeLeft) withInset:10];
        [_defaultActionSheetView autoPinEdgeToSuperviewEdge:(ALEdgeRight) withInset:10];
        [_defaultActionSheetView autoPinEdgeToSuperviewEdge:(ALEdgeTop) withInset:0];
        [_defaultActionSheetView autoSetDimension:(ALDimensionHeight) toSize:SHEETHEIGHT * _count];
        
        
        [_actionSheetView autoPinEdgeToSuperviewEdge:(ALEdgeLeft)];
        [_actionSheetView autoPinEdgeToSuperviewEdge:(ALEdgeRight)];
        
        CGFloat actionSheetViewHeight = kSCREENHEIGHT - _top;
        [_actionSheetView autoSetDimension:(ALDimensionHeight) toSize:actionSheetViewHeight];
        self.bottomConstraint = [_actionSheetView autoPinEdge:(ALEdgeBottom) toEdge:(ALEdgeBottom) ofView:self withOffset:actionSheetViewHeight];

        
        [self autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
        
    } else {
        self.bottomConstraint.constant = 0;
    }
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_defaultActionSheetView) {
        _defaultActionSheetView.layer.cornerRadius = 8;
    }
    if (_cancelBtn) {
        _cancelBtn.layer.cornerRadius = 8;
    }
}

- (void)drawSubViews {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
    
    _actionSheetView = [UIView newAutoLayoutView];
    _actionSheetView.backgroundColor = [UIColor clearColor];
    [self addSubview:_actionSheetView];
    
    _defaultActionSheetView = [UIView newAutoLayoutView];
    _defaultActionSheetView.backgroundColor = [UIColor whiteColor];
    _defaultActionSheetView.clipsToBounds = YES;
    [_actionSheetView addSubview:_defaultActionSheetView];
}

@end
