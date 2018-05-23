//
//  XNBRunTimeUtilites.m
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/26.
//

#import "XNBRunTimeUtilites.h"

void MDFSwizzMethod(Class aClass, SEL originSelector, SEL swizzSelector)
{
    Method systemMethod = class_getInstanceMethod(aClass, originSelector);
    Method swizzMethod = class_getInstanceMethod(aClass, swizzSelector);
    BOOL isAdd = class_addMethod(aClass,
                                 originSelector,
                                 method_getImplementation(swizzMethod),
                                 method_getTypeEncoding(swizzMethod));
    if (isAdd) {
        class_replaceMethod(aClass,
                            swizzSelector,
                            method_getImplementation(systemMethod),
                            method_getTypeEncoding(systemMethod));
    } else {
        method_exchangeImplementations(systemMethod, swizzMethod);
    }
}

@implementation XNBRunTimeUtilites

+ (NSDictionary *)propertiesForClass:(Class)aClass
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(aClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [self propertyName:property];
        NSString *propertyType = [self propertyTypeName:property];
        if (propertyName.length && propertyType.length) {
            [dict setObject:propertyType forKey:propertyName];
        }
    }
    
    free(properties);
    return dict;
}

+ (NSString *)propertyTypeName:(objc_property_t)property
{
    char *propertyType = property_copyAttributeValue(property, "T");
    
    if (!property) {
        return nil;
    }
    
    NSString *className = nil;
    if (propertyType[0] == '@') {
        if (propertyType[1] == '\0') {
            className = NSStringFromClass([NSObject class]);
        } else {
            long stringLength = strlen(propertyType);
            if (stringLength > 3) {
                // 去除@"
                char *classString = propertyType + 2;
                stringLength -= 2;
                // 去除"
                classString[stringLength - 1] = '\0';
                className = [[NSString alloc] initWithCString:classString encoding:NSASCIIStringEncoding];
            }
        }
    } else {
        className = [[NSString alloc] initWithCString:propertyType encoding:NSASCIIStringEncoding];
    }
    
    free(propertyType);
    return className;
}

+ (BOOL)propertyIsObject:(objc_property_t)property
{
    char *attribute = property_copyAttributeValue(property, "T");
    BOOL isObject = attribute[0] == '@';
    
    free(attribute);
    return isObject;
}

+ (BOOL)propertyIsWeak:(objc_property_t)property
{
    return [self property:property hasPropertyType:"W"];
}

+ (BOOL)propertyIsStrong:(objc_property_t)property
{
    return [self property:property hasPropertyType:"&"];
}

+ (BOOL)propertyIsCopy:(objc_property_t)property
{
    return [self property:property hasPropertyType:"C"];
}

+ (BOOL)propertyIsReadOnly:(objc_property_t)property
{
    return [self property:property hasPropertyType:"R"];
}

+ (BOOL)propertyIsAssign:(objc_property_t)property
{
    BOOL isWeak = [self propertyIsWeak:property];
    BOOL isObject = [self propertyIsObject:property];
    BOOL isStrongOrCopy = [self propertyIsStrong:property];
    
    return isObject && !isWeak && !isStrongOrCopy;
}

#pragma mark - Others
+ (NSString *)propertyName:(objc_property_t)property
{
    const char *propertyName = property_getName(property);
    if (propertyName) {
        return [[NSString alloc] initWithCString:propertyName encoding:NSASCIIStringEncoding];
    }
    
    return nil;
}

+ (BOOL)property:(objc_property_t)property hasPropertyType:(char *)encoding
{
    char *attribute = property_copyAttributeValue(property, encoding);
    BOOL hasEncoding = attribute != NULL;
    
    free(attribute);
    return hasEncoding;
}

@end
