//
//  NSDateFormatter+XNB.m
//  XNBasicFramework
//
//  Created by 江红胡 on 2017/9/26.
//

#import "NSDateFormatter+XNB.h"

static NSMutableDictionary *formatters = nil;

@implementation NSDateFormatter (XNB)

+ (NSDateFormatter *)xnb_dateFormatterWithFormat:(NSString *)formmat
{
    return [self xnb_dateFormatterWithKey:[NSString stringWithFormat:@"<%@>", formmat] configBlock: ^(NSDateFormatter *formatter) {
        if (formatter) {
            [formatter setDateFormat:formmat];
        }
    }];
}

+ (NSDateFormatter *)xnb_dateFormatterWithKey:(NSString *)key configBlock:(XNBDateFormmaterConfigBlock)cofigBlock
{
    NSString *strKey = nil;
    if (!key) {
        strKey = @"defaultFormatter";
    } else {
        strKey = [key copy];
    }
    
    @synchronized(self) {
        NSDateFormatter *dateFormatter = [[self formatters] objectForKey:strKey];
        if (!dateFormatter) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [[self formatters] setObject:dateFormatter forKey:strKey];
            
            if (cofigBlock) {
                cofigBlock(dateFormatter); //配置它
            }
            return dateFormatter;
        }
        
        return dateFormatter;
    }
}

+ (NSMutableDictionary *)formatters
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!formatters) {
            formatters = [[NSMutableDictionary alloc] init];
        }
    });
    
    return formatters;
}

@end
