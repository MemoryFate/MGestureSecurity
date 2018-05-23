//
//  NSMutableDictionary+XNB.h
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/25.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (XNB)

#pragma mark - Safe
- (void)xnb_safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey;
- (void)xnb_safeRemoveObjectForKey:(id<NSCopying>)aKey;
- (void)xnb_safeAppendDictionary:(NSDictionary *)dictionary;

@end
