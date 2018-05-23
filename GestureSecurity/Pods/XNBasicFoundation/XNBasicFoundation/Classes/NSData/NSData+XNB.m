//
//  NSData+XNB.m
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/25.
//

#import "NSData+XNB.h"

@implementation NSData (XNB)

- (id)mdf_jsonObject
{
    NSError *error = nil;
    if (self.length) {
        id json = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            return nil;
        }
        return json;
    }
    
    return nil;
}

@end
