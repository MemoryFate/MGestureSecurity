//
//  UILabel+XNB.h
//  Pods-XNBasicUIKit_Example
//
//  Created by 王嘉倩 on 2018/3/12.
//

#import <UIKit/UIKit.h>

@interface UILabel (XNB)

+ (void)xnb_changeLineSpaceForLabel:(UILabel *)label lineSpace:(float)lineSpace;
+ (void)xnb_changeWordSpaceForLabel:(UILabel *)label lineSpace:(float)lineSpace;
+ (void)xnb_changeSpaceForLabel:(UILabel *)label lineSpace:(float)lineSpace wordSpace:(float)wordSpace;
@end
