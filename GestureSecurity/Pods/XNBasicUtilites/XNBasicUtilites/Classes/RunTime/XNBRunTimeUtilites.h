//
//  XNBRunTimeUtilites.h
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/26.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/**
 *  替换实现
 *
 *  @param aClass         类
 *  @param originSelector 待替换方法
 *  @param swizzSelector  替换的方法
 */
FOUNDATION_EXPORT void MDFSwizzMethod(Class aClass, SEL originSelector, SEL swizzSelector);

@interface XNBRunTimeUtilites : NSObject

+ (NSDictionary *)propertiesForClass:(Class)aClass;

+ (NSString *)propertyTypeName:(objc_property_t)property;

#pragma mark - BOOL
+ (BOOL)propertyIsObject:(objc_property_t)property;
+ (BOOL)propertyIsWeak:(objc_property_t)property;
+ (BOOL)propertyIsStrong:(objc_property_t)property;
+ (BOOL)propertyIsCopy:(objc_property_t)property;
+ (BOOL)propertyIsAssign:(objc_property_t)property;
+ (BOOL)propertyIsReadOnly:(objc_property_t)property;

@end
