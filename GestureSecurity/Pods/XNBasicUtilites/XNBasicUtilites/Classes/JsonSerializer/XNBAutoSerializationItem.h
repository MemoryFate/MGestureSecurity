//
//  XNBAutoSerializationItem.h
//  XNBasicFramework
//
//  Created by 江红胡 on 2017/9/27.
//

#import <Foundation/Foundation.h>

@protocol XNBUnSerializationProperty <NSObject>
@end


@protocol XNBPropertyToDictionaryArrayToJson <NSObject>
@end


@interface NSArray (PropertyAdpaterToJson)<XNBPropertyToDictionaryArrayToJson>
@end


@interface NSObject (AdapterForUnSerializationItem)<XNBUnSerializationProperty>
@end


@interface XNBAutoSerializationItem : NSObject<NSCopying, NSCoding>

- (NSDictionary *)propertyToDictionary;

@end
