//
//  UIColor+XNB.m
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/26.
//

#import "UIColor+XNB.h"

@implementation UIColor (XNB)

+ (UIColor *)xnb_colorForKey:(NSString *)key
{
    return [self xnb_colorForKey:key alpha:1.0f];
}

+ (UIColor *)xnb_colorForKey:(NSString *)key alpha:(CGFloat)alpha
{
    return [UIColor xnb_colourWithHexString:key alpha:alpha];
}

+ (UIImage *)xnb_imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIColor *)xnb_randomColor
{
    CGFloat r = arc4random() % 256 / 255.0;
    CGFloat g = arc4random() % 256 / 255.0;
    CGFloat b = arc4random() % 256 / 255.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

#pragma mark - Others
+ (UIColor *)xnb_colourWithRGBHex:(UInt32)hex alpha:(CGFloat)alpha
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:alpha];
}

+ (UIColor *)xnb_colourWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha
{
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) {
        return nil;
    }
    
    return [UIColor xnb_colourWithRGBHex:hexNum alpha:alpha];
}

@end
