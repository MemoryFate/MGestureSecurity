//
//  UITextField+XNB.m
//  XNBasicUIKit
//
//  Created by 江红胡 on 2017/9/30.
//

#import "UITextField+XNB.h"

@implementation UITextField (XNB)

- (void)xnb_setPlaceholder:(NSString *)placeholder placeholderFont:(UIFont *)placeholderFont placeholderColor:(UIColor *)placeholderColor
{
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName :  placeholderColor, NSFontAttributeName : placeholderFont}];
}

@end
