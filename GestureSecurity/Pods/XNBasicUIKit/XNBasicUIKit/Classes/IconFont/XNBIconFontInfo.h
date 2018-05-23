//
//  XNBIconFontInfo.h
//  XNBasicUIKit
//
//  Created by 江红胡 on 2018/3/14.
//  Copyright © 2018年 江红胡. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XNBIconFontInfoMake(text, imageSize, imageColor) [XNBIconFontInfo iconInfoWithText:text size:imageSize color:imageColor]

@interface XNBIconFontInfo : NSObject

@property (nonatomic, strong) NSString *text;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, strong) UIColor *color;

- (instancetype)initWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color;

+ (instancetype)iconInfoWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color;

@end
