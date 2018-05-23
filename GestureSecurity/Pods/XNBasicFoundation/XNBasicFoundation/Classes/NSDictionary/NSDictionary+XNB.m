//
//  NSDictionary+XNB.m
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/25.
//

#import "NSDictionary+XNB.h"

@implementation NSDictionary (XNB)

- (NSString *)xnb_jsonString
{
    if (self) {
        NSData *data = [self xnb_jsonData];
        if (data.length) {
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }
    
    return nil;
}

- (NSString *)xnb_parameterString {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *key in [self allKeys]) {
        NSString *content = [NSString stringWithFormat:@"%@=%@", key, [self xnb_safeObjectForKey:key]];
        [tempArray addObject:content];
    }
    NSString *resultStr = [tempArray componentsJoinedByString:@"&"];
    resultStr = [NSString stringWithFormat:@"%@\n", resultStr];
    return resultStr;
}

- (NSData *)xnb_jsonData
{
    if (self) {
        return  [NSJSONSerialization dataWithJSONObject:self
                                                options:NSJSONWritingPrettyPrinted
                                                  error:nil];
    }
    
    return nil;
}

- (id)xnb_safeObjectForKey:(id<NSCopying>)aKey
{
    if (aKey) {
        return [self objectForKey:aKey];
    }
    
    return nil;
}

@end
