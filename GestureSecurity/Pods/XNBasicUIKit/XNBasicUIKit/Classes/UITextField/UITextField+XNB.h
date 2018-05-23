//
//  UITextField+XNB.h
//  XNBasicUIKit
//
//  Created by 江红胡 on 2017/9/30.
//

#import <UIKit/UIKit.h>

@interface UITextField (XNB)

// 快速设置placeholder
- (void)xnb_setPlaceholder:(NSString *)placeholder placeholderFont:(UIFont *)placeholderFont placeholderColor:(UIColor *)placeholderColor;

@end
