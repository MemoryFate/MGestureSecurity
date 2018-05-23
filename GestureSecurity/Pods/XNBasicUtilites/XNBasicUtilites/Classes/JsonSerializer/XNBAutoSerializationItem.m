//
//  XNBAutoSerializationItem.m
//  XNBasicFramework
//
//  Created by 江红胡 on 2017/9/27.
//

#import "XNBAutoSerializationItem.h"
#import "XNBasicMacros.h"
#import "XNBRunTimeUtilites.h"
#import "NSString+XNB.h"
#import "NSArray+XNB.h"
#import "NSMutableArray+XNB.h"
#import "NSMutableDictionary+XNB.h"

static NSString * const kUnSerializationProperty = @"XNBUnSerializationProperty";

@implementation XNBAutoSerializationItem

#pragma mark - NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        unsigned int propertyCount = 0;
        Class cls = self.class;
        
        while (cls != [NSObject class]) {
            objc_property_t *propertyList = class_copyPropertyList(cls, &propertyCount);
            for (unsigned i = 0; i < propertyCount; i++) {
                objc_property_t property = propertyList[i];
                const char *attrs = property_getAttributes(property);
                NSString *propertyAttributes = @(attrs);
                if (![propertyAttributes xnb_contains:kUnSerializationProperty]) {
                    NSArray *attributeItems = [propertyAttributes componentsSeparatedByString:@","];
                    if ([attributeItems containsObject:@"R"]) {
                        continue;
                    }
                    NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
                    @try {
                        id value = [aDecoder decodeObjectForKey:propertyName];
                        if (value) {
                            [self setValue:value forKey:value];
                        }
                    }
                    @catch (NSException *exception) {
                        XNBLog(@"%@", exception);
                    }
                    @finally {
                    }
                }
            }
            
            free(propertyList);
            propertyCount = 0;
            propertyList = 0;
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int propertyCount = 0;
    Class cls = self.class;
    
    while (cls != [NSObject class]) {
        objc_property_t *propertyList = class_copyPropertyList(cls, &propertyCount);
        for (unsigned i = 0; i < propertyCount; i++) {
            objc_property_t property = propertyList[i];
            const char *attrs = property_getAttributes(property);
            NSString *propertyAttributes = @(attrs);
            if (![propertyAttributes xnb_contains:kUnSerializationProperty]) {
                NSArray *attributeItems = [propertyAttributes componentsSeparatedByString:@","];
                if ([attributeItems containsObject:@"R"]) {
                    continue;
                }
                NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
                @try {
                    id value = [self valueForKey:propertyName];
                    if (value) {
                        [aCoder encodeObject:value forKey:propertyName];
                    }
                }
                @catch (NSException *exception) {
                    XNBLog(@"%@", exception);
                }
                @finally {
                }
            }
        }
        
        free(propertyList);
        cls = class_getSuperclass(cls);
        propertyList = 0;
        propertyCount = 0;
    }
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    XNBAutoSerializationItem *item = [[self class] allocWithZone:zone];
    unsigned int propertyCount = 0;
    
    Class cls = self.class;
    while (cls != [NSObject class]) {
        objc_property_t *propertyList = class_copyPropertyList(cls, &propertyCount);
        for (unsigned i = 0; i < propertyCount; i++) {
            objc_property_t property = propertyList[i];
            if ([XNBRunTimeUtilites propertyIsReadOnly:property]) {
                continue;
            }
            NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
            @try {
                id value = [self valueForKey:propertyName];
                if (value) {
                    [item  setValue:value forKey:propertyName];
                }
            }
            @catch (NSException *exception) {
                XNBLog(@"%@", exception);
            }
            @finally {
            }
        }
        
        free(propertyList);
        cls = class_getSuperclass(cls);
        propertyList = 0;
        propertyCount = 0;
    }
    
    return item;
}

- (NSDictionary *)propertyToDictionary
{
    uint count = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *pName = property_getName(property);
        if (pName) {
            id value = [self valueForKey:[NSString stringWithUTF8String:pName]];
            if (value) {
                if ([value isKindOfClass:[XNBAutoSerializationItem class]]) {
                    NSDictionary *valueDict = [value propertyToDictionary];
                    [properties xnb_safeSetObject:valueDict forKey:[NSString stringWithUTF8String:pName]];
                } else if ([value isKindOfClass:[NSArray class]]) {
                    NSArray *valueArr = (NSArray *)value;
                    NSString *arrayType = [XNBRunTimeUtilites propertyTypeName:property];
                    if (![arrayType xnb_contains:@"XNBPropertyToDictionaryArrayToJson"]) {
                        NSMutableArray *tempArray = [NSMutableArray array];
                        for (XNBAutoSerializationItem *item in valueArr) {
                            if ([item isKindOfClass:[XNBAutoSerializationItem class]]) {
                                NSDictionary *tempDict = [item propertyToDictionary];
                                if (tempDict) {
                                    [tempArray xnb_safeAddObject:tempDict];
                                }
                            } else {
                                [tempArray xnb_safeAddObject:item];
                            }
                        }
                        
                        [properties xnb_safeSetObject:tempArray forKey:[NSString stringWithUTF8String:pName]];
                    } else {
                        [properties xnb_safeSetObject:[valueArr xnb_jsonValue] forKey:[NSString stringWithUTF8String:pName]];
                    }
                } else {
                    [properties xnb_safeSetObject:value forKey:[NSString stringWithUTF8String:pName]];
                }
            }
        }
    }
    
    free(propertyList);
    propertyList = nil;
    count = 0;
    
    return properties;
}

@end
