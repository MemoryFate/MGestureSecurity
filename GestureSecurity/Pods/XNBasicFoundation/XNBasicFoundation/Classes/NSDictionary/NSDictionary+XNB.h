//
//  NSDictionary+XNB.h
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/25.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (XNB)

#pragma mark - Json
// 转换成Json字符串
- (NSString *)xnb_jsonString;

// 转成key=value&key=value
- (NSString *)xnb_parameterString;

// 转换成json NSData
- (NSData *)xnb_jsonData;

#pragma mark - Safe
- (id)xnb_safeObjectForKey:(id<NSCopying>)aKey;

@end
