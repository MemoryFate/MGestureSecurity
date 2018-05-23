//
//  UIView+Frame.h
//  XNBasicFramework
//
//  Created by 江红胡 on 2017/9/26.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

// x y
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

// width height
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

// center
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

// margin
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;

@end
