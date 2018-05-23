//
//  XNBAutoScrollLabel.h
//  XNBasicUIKit
//
//  Created by 江红胡 on 2018/3/27.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XNBAutoScrollDirectionType){
    XNBAutoScrollDirectionType_Right,       // 向右滚动
    XNBAutoScrollDirectionType_Left,        // 向左滚动
    XNBAutoScrollDirectionType_Top,         // 向上滚动
    XNBAutoScrollDirectionType_Bottom       // 向下滚动
};

@interface XNBAutoScrollLabel : UIView

@property (nonatomic, assign) XNBAutoScrollDirectionType direction;
@property (nonatomic, assign) CGFloat scrollSpeed;              // 滚动速度, 默认30
@property (nonatomic, assign) NSTimeInterval autoScrollInterval;// 自动滚动的时间间隔，默认1.5
@property (nonatomic, assign) NSUInteger labelSpacing;          // 滚动的label的间距，默认20

@property (nonatomic, assign, readonly) BOOL scrolling;         // 是否滚动

@property (nonatomic, copy, nullable) NSString *text;
@property (nonatomic, copy, nullable) NSAttributedString *attributedText;
@property (nonatomic, strong, nonnull) UIColor *textColor;
@property (nonatomic, strong, nonnull) UIFont *font;
@property (nonatomic, strong, nullable) UIColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) NSTextAlignment textAlignment;

- (void)setText:(NSString * __nullable)text refreshLabels:(BOOL)refresh;

- (void)setAttributedText:(NSAttributedString * __nullable)theText refreshLabels:(BOOL)refresh;

@end
