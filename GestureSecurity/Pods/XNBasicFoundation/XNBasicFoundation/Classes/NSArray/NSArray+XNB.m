//
//  NSArray+XNB.m
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/25.
//

#import "NSArray+XNB.h"

@implementation NSArray (XNB)

- (NSString *)xnb_jsonValue
{
    NSData *data = [self xnb_jsonData];
    if (data.length) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return nil;
}

- (id)xnb_jsonData
{
    if (self) {
        return  [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions
                                                  error:nil];
    }
    
    return nil;
}

- (id)xnb_safeObjectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self objectAtIndex:index];
    }
    
    return nil;
}

- (id)xnb_safeSubarrayWithRange:(NSRange)range
{
    if (range.location + range.length <= self.count) {
        return [self subarrayWithRange:range];
    }
    
    return nil;
}

- (NSInteger)xnb_safeIndexOfObject:(id)object
{
    if (object) {
        return [self indexOfObject:object];
    }
    
    return NSNotFound;
}

@end
