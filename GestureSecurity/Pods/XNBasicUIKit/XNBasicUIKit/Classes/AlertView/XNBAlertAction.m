//
//  XNBActionAlert.m
//  XNBasicUIKit
//
//  Created by 王嘉倩 on 2017/12/11.
//

#import "XNBAlertAction.h"
#import "PureLayout.h"
#import "UIColor+XNB.h"
#import "UIFont+XNB.h"
#import "UIImage+XNB.h"

typedef void (^cancel)(void);
typedef void (^choose)(void);

#define kSCREENWIDTH (float)([UIScreen mainScreen].bounds.size.width)
#define kSCREENHEIGHT (float)([UIScreen mainScreen].bounds.size.height)

@interface XNBAlertAction ()

/**
 白色背景
 */
@property (nonatomic, strong) UIView *contentView;

/**
 标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 弹框内容
 */
@property (nonatomic, strong) UILabel *messageLabel;

/**
 确定按钮
 */
@property (nonatomic, strong) UIButton *defultButton;

/**
 取消按钮
 */
@property (nonatomic, strong) UIButton *cancelButton;

/**
 有取消按钮时，分隔取消按钮与确定按钮的竖线
 */
@property (nonatomic, strong) UIView *centerLineView;

/**
 内容与按钮的分界线
 */
@property (nonatomic, strong) UIView *lineView;

/**
 alert样式
 */
@property (nonatomic, assign) XNBAlertActionStyle alertActionStyle;

@property (nonatomic, copy) choose confirmParam;
@property (nonatomic, copy) cancel cancleParam;

@end

@implementation XNBAlertAction

- (instancetype)init {
    if (self = [super init]) {
        
        [self drawAlertView];
        
    }
    return self;
}

- (void)alertActionStyle:(XNBAlertActionStyle)alertActionStyle message:(NSString *)message defultTitle:(NSString *)defultTitle defultHandler:(void (^)(void))defultHandler cancelTitle:(NSString *)cancelTitle cancelHandler:(void (^)(void))cancelHandler {
    
    _alertActionStyle = alertActionStyle;
    
    if (_alertActionStyle == XNBAlertActionStyleCancel) {
        
        [self addCancelButton];
    }
    
    [self setNeedsUpdateConstraints];
    
    _messageLabel.text = message;
    
    [_defultButton setTitle:defultTitle forState:(UIControlStateNormal)];
    _confirmParam = defultHandler;
    
    [_cancelButton setTitle:cancelTitle forState:(UIControlStateNormal)];
    _cancleParam = cancelHandler;

}

- (void)alertActionStyle:(XNBAlertActionStyle)alertActionStyle title:(NSString *)title message:(NSString *)message defultTitle:(NSString *)defultTitle defultHandler:(void (^)(void))defultHandler cancelTitle:(NSString *)cancelTitle cancelHandler:(void (^)(void))cancelHandler {
    
    _alertActionStyle = alertActionStyle;
    
    [self drawAlertViewContainsTitleLabel];
    
    _titleLabel.text = title;
    
    [self alertActionStyle:alertActionStyle message:message defultTitle:defultTitle defultHandler:defultHandler cancelTitle:cancelTitle cancelHandler:cancelHandler];
    
}

- (void)updateConstraints {
    
    [self autoPinEdgesToSuperviewEdges];
    
    [_contentView autoSetDimension:(ALDimensionWidth) toSize:kSCREENWIDTH - 80];
    [_contentView autoAlignAxisToSuperviewAxis:(ALAxisHorizontal)];
    [_contentView autoAlignAxisToSuperviewAxis:(ALAxisVertical)];
    
    if (_titleLabel) {
        
        [_titleLabel autoMatchDimension:(ALDimensionWidth) toDimension:(ALDimensionWidth) ofView:_contentView withOffset:-40];
        [_titleLabel autoAlignAxisToSuperviewAxis:(ALAxisVertical)];
        [_titleLabel autoPinEdgeToSuperviewEdge:(ALEdgeTop) withInset:16];
        
        [_messageLabel autoAlignAxis:(ALAxisVertical) toSameAxisOfView:_titleLabel];
        [_messageLabel autoMatchDimension:(ALDimensionWidth) toDimension:(ALDimensionWidth) ofView:_titleLabel];
        [_messageLabel autoPinEdge:(ALEdgeTop) toEdge:(ALEdgeBottom) ofView:_titleLabel withOffset:15];
        [_messageLabel autoPinEdgeToSuperviewEdge:(ALEdgeBottom) withInset:64];
        
    } else {
        
        [_messageLabel autoMatchDimension:(ALDimensionWidth) toDimension:(ALDimensionWidth) ofView:_contentView withOffset:-40];
        [_messageLabel autoAlignAxisToSuperviewAxis:(ALAxisVertical)];
        [_messageLabel autoPinEdgeToSuperviewEdge:(ALEdgeTop) withInset:24];
        [_messageLabel autoPinEdgeToSuperviewEdge:(ALEdgeBottom) withInset:64];
    }
    
    [_lineView autoPinEdgeToSuperviewEdge:(ALEdgeBottom) withInset:43];
    [_lineView autoMatchDimension:(ALDimensionWidth) toDimension:(ALDimensionWidth) ofView:_contentView];
    [_lineView autoAlignAxisToSuperviewAxis:(ALAxisVertical)];
    [_lineView autoSetDimension:(ALDimensionHeight) toSize:0.5];
    
    if (_alertActionStyle == XNBAlertActionStyleDefult) {
        
        [_defultButton autoMatchDimension:(ALDimensionWidth) toDimension:(ALDimensionWidth) ofView:_contentView];
        [_defultButton autoSetDimension:(ALDimensionHeight) toSize:43];
        [_defultButton autoAlignAxisToSuperviewAxis:(ALAxisVertical)];
        [_defultButton autoPinEdgeToSuperviewEdge:(ALEdgeBottom) withInset:0];
        
    } else {
        
        [_defultButton autoMatchDimension:(ALDimensionWidth) toDimension:(ALDimensionWidth) ofView:_contentView withMultiplier:0.5];
        [_defultButton autoSetDimension:(ALDimensionHeight) toSize:43];
        [_defultButton autoPinEdgeToSuperviewEdge:(ALEdgeBottom) withInset:0];
        [_defultButton autoPinEdgeToSuperviewEdge:(ALEdgeRight) withInset:0];

        [_cancelButton autoMatchDimension:(ALDimensionWidth) toDimension:(ALDimensionWidth) ofView:_defultButton];
        [_cancelButton autoMatchDimension:(ALDimensionHeight) toDimension:(ALDimensionHeight) ofView:_defultButton];
        [_cancelButton autoAlignAxis:(ALAxisHorizontal) toSameAxisOfView:_defultButton];
        [_cancelButton autoPinEdgeToSuperviewEdge:(ALEdgeLeft) withInset:0];
        
        [_centerLineView autoPinEdgeToSuperviewEdge:(ALEdgeBottom) withInset:0];
        [_centerLineView autoMatchDimension:(ALDimensionHeight) toDimension:(ALDimensionHeight) ofView:_defultButton];
        [_centerLineView autoSetDimension:(ALDimensionWidth) toSize:0.5];
        [_centerLineView autoAlignAxisToSuperviewAxis:(ALAxisVertical)];
        
    }
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _contentView.layer.cornerRadius = 6;
}


- (void)defultButtonClick {
    [self dismiss];
    if (_confirmParam) {
        _confirmParam();
    }
}

- (void)cancelButtonClick {
    [self dismiss];
    if (_cancleParam) {
        _cancleParam();
    }
}

- (void)drawAlertViewContainsTitleLabel {
        
    _titleLabel = [UILabel newAutoLayoutView];
    _titleLabel.textColor = [UIColor xnb_colorForKey:@"3d3d3d"];
    _titleLabel.font = [UIFont xnb_normalFontOfSize:16];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    [_contentView addSubview:_titleLabel];
    
    _messageLabel.font = [UIFont xnb_normalFontOfSize:14];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)addCancelButton {
    
    _cancelButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_cancelButton setTitleColor:[UIColor xnb_colorForKey:@"999999"] forState:(UIControlStateNormal)];
    _cancelButton.titleLabel.font = [UIFont xnb_normalFontOfSize:16];
    [_cancelButton setBackgroundImage:[UIImage xnb_imageWithColor:[UIColor whiteColor]] forState:(UIControlStateNormal)];
    [_cancelButton setBackgroundImage:[UIImage xnb_imageWithColor:[UIColor xnb_colorForKey:@"eeeeee"]] forState:(UIControlStateHighlighted)];
    _cancelButton.clipsToBounds = YES;
    [_contentView addSubview:_cancelButton];
    [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    _centerLineView = [UIView newAutoLayoutView];
    _centerLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.08];
    [_contentView addSubview:_centerLineView];
}

- (void)drawAlertView {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
//    [self addGestureRecognizer:tap];
    
    _contentView = [UIView newAutoLayoutView];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.clipsToBounds = YES;
    [self addSubview:_contentView];
    
    _messageLabel = [UILabel newAutoLayoutView];
    _messageLabel.textColor = [UIColor xnb_colorForKey:@"3d3d3d"];
    _messageLabel.font = [UIFont xnb_normalFontOfSize:15];
    _messageLabel.textAlignment = NSTextAlignmentLeft;
    _messageLabel.numberOfLines = 0;
    [_contentView addSubview:_messageLabel];
    
    _lineView = [UIView newAutoLayoutView];
    _lineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.08];
    [_contentView addSubview:_lineView];
    
    _defultButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_defultButton setTitleColor:[UIColor xnb_colorForKey:@"3884ff"] forState:(UIControlStateNormal)];
    _defultButton.titleLabel.font = [UIFont xnb_normalFontOfSize:16];
    [_defultButton setBackgroundImage:[UIImage xnb_imageWithColor:[UIColor whiteColor]] forState:(UIControlStateNormal)];
    [_defultButton setBackgroundImage:[UIImage xnb_imageWithColor:[UIColor xnb_colorForKey:@"eeeeee"]] forState:(UIControlStateHighlighted)];
    _defultButton.clipsToBounds = YES;
    [_contentView addSubview:_defultButton];
    [_defultButton addTarget:self action:@selector(defultButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    
}

- (void)dismiss {
    [self removeFromSuperview];
}



- (void)setTitleTextFont:(UIFont *)titleTextFont {
    if (titleTextFont && _titleLabel) {
        _titleLabel.font = titleTextFont;
    }
}

- (void)setTitleTextColor:(UIColor *)titleTextColor {
    if (titleTextColor && _titleLabel) {
        _titleLabel.textColor = titleTextColor;
    }
}

- (void)setMessageTextFont:(UIFont *)messageTextFont {
    if (messageTextFont && _messageLabel) {
        _messageLabel.font = messageTextFont;
    }
}

- (void)setMessageTextColor:(UIColor *)messageTextColor {
    if (messageTextColor && _messageLabel) {
        _messageLabel.textColor = messageTextColor;
    }
}

- (void)setDefultBtnTextFont:(UIFont *)defultBtnTextFont {
    if (defultBtnTextFont && _defultButton) {
        _defultButton.titleLabel.font = defultBtnTextFont;
    }
}

- (void)setDefultBtnTextColor:(UIColor *)defultBtnTextColor {
    if (defultBtnTextColor && _defultButton) {
        [_defultButton setTitleColor:defultBtnTextColor forState:(UIControlStateNormal)];
    }
}

- (void)setCancelBtnTextFont:(UIFont *)cancelBtnTextFont {
    if (cancelBtnTextFont && _cancelButton) {
        _cancelButton.titleLabel.font = cancelBtnTextFont;
    }
}

- (void)setCancelBtnTextColor:(UIColor *)cancelBtnTextColor {
    if (cancelBtnTextColor && _cancelButton) {
        [_cancelButton setTitleColor:cancelBtnTextColor forState:(UIControlStateNormal)];
    }
}

- (void)setTitleTextAlignment:(NSTextAlignment)titleTextAlignment {
    _titleLabel.textAlignment = titleTextAlignment;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
