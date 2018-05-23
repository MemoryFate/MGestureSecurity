//
//  UIFont+XNB.m
//  XNBasicFramework
//
//  Created by 江红胡 on 2017/9/26.
//

#import "UIFont+XNB.h"

@implementation UIFont (XNB)

+ (UIFont *)xnb_thinFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
}

+ (UIFont *)xnb_normalFontOfSize:(CGFloat)fontSize
{
    return [UIFont systemFontOfSize:fontSize];
}

+ (UIFont *)xnb_boldFontOfSize:(CGFloat)fontSize
{
    return [UIFont boldSystemFontOfSize:fontSize];
}

+ (UIFont *)xnb_PingFangSCMediumOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize];
}

+ (UIFont *)xnb_PingFangSCRegularOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize];
}

@end
