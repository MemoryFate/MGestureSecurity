//
//  XNBBaseItem.h
//  XNBasicFramework
//
//  Created by 江红胡 on 2017/9/27.
//

#import "XNBAutoSerializationItem.h"

@protocol XNBBaseItemUnAutoParseProperty <NSObject>
@end


@interface NSObject (AdapterForBaseItem)<XNBBaseItemUnAutoParseProperty>
@end


@interface XNBBaseItem : XNBAutoSerializationItem

// Json解析
- (void)parseJSONValue:(NSDictionary *)jsonValue;

// 如果子类中的元素有数组类型的话，通过重载这个方法返回解析后数组元素类型
- (Class)classForObject:(id)arrayElement inArrayWithPropertyName:(NSString *)propertyName;

// 通过属性名称相对应返回Json串中的key，默认与属性名称一样
- (NSString *)JSONKeyForProperty:(NSString *)propertyKey;

- (void)willAutoParse;  // 开始解析之前
- (void)afterAutoParse; // 解析结束回调

@end
