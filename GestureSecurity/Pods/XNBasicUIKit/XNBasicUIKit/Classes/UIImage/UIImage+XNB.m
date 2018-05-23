//
//  UIImage+XNB.m
//  XNBasicUIKit
//
//  Created by 江红胡 on 2017/9/30.
//

#import "UIImage+XNB.h"

@implementation UIImage (XNB)

+ (UIImage *)xnb_imageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
