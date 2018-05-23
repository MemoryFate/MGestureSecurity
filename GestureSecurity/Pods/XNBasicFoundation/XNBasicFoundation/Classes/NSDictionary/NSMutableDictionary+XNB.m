//
//  NSMutableDictionary+XNB.m
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/25.
//

#import "NSMutableDictionary+XNB.h"

@implementation NSMutableDictionary (XNB)

- (void)xnb_safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (!aKey) {
        return;
    }
    if (!anObject) {
        [self removeObjectForKey:aKey];
        return;
    }
    [self setObject:anObject forKey:aKey];
}

- (void)xnb_safeRemoveObjectForKey:(id<NSCopying>)aKey
{
    if (aKey) {
        [self removeObjectForKey:aKey];
    }
}

- (void)xnb_safeAppendDictionary:(NSDictionary *)dictionary
{
    __weak typeof(self) weakSelf = self;
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf xnb_safeSetObject:obj forKey:key];
    }];
}

@end
