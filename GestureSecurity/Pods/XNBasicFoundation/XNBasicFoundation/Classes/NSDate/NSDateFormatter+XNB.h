//
//  NSDateFormatter+XNB.h
//  XNBasicFramework
//
//  Created by 江红胡 on 2017/9/26.
//

#import <Foundation/Foundation.h>

typedef void (^XNBDateFormmaterConfigBlock)(NSDateFormatter *dateFormmater);

@interface NSDateFormatter (XNB)

+ (NSDateFormatter *)xnb_dateFormatterWithFormat:(NSString *)format;

// key 唯一标识
// block 配置formmater的格式
+ (NSDateFormatter *)xnb_dateFormatterWithKey:(NSString *)key configBlock:(XNBDateFormmaterConfigBlock)block;

@end
