//
//  NSArray+XNB.h
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/25.
//

#import <Foundation/Foundation.h>

@interface NSArray (XNB)

#pragma mark - Json
// Array转换成Json
- (NSString *)xnb_jsonValue;

// Array转换成Json NSData
- (id)xnb_jsonData;

#pragma mark - Safe
- (id)xnb_safeObjectAtIndex:(NSUInteger)index;
- (id)xnb_safeSubarrayWithRange:(NSRange)range;

- (NSInteger)xnb_safeIndexOfObject:(id)object;

@end
