//
//  XNBIconFontInfo.m
//  XNBasicUIKit
//
//  Created by 江红胡 on 2018/3/14.
//  Copyright © 2018年 江红胡. All rights reserved.
//

#import "XNBIconFontInfo.h"

@implementation XNBIconFontInfo

- (instancetype)initWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color
{
    if (self = [super init]) {
        self.text = text;
        self.size = size;
        self.color = color;
    }
    
    return self;
}

+ (instancetype)iconInfoWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color
{
    return [[XNBIconFontInfo alloc] initWithText:text size:size color:color];
}

@end
