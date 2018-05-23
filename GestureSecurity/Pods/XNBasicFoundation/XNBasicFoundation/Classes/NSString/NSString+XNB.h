//
//  NSString+XNB.h
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/25.
//

#import <Foundation/Foundation.h>

@interface NSString (XNB)

#pragma mark - Json
// 转换成Json字典
- (id)xnb_jsonValue;

// url参数转换成Json字典
- (id)xnb_urlConvertJson;

// 将URL参数转换成字典
- (NSDictionary *)xnb_urlConvertDictionary;

#pragma mark - BOOL
// 是否包含指定字符串
- (BOOL)xnb_contains:(NSString *)string;

// 是否以某字符串结尾
// caseInsensitive 不区分大小写
- (BOOL)xnb_endWith:(NSString *)endString caseInsensitive:(BOOL)caseInsensitive;

// 判断字符串是否为空或者长度为0
- (BOOL)xnb_nilOrEmpty;

// 验证邮箱格式
- (BOOL)xnb_validEmail;

// 验证电话格式
- (BOOL)xnb_validMobile;

// 验证手机格式
- (BOOL)xnb_validFixPhone;

// 验证身份证格式
- (BOOL)xnb_validIDCard;

// 是否全部是数字
- (BOOL)xnb_allNumbers;

// 是否全部为数字，且可以包含小数点
- (BOOL)xnb_allDecimalDigit;

// 是否包含中文 英文 数字 下划线
- (BOOL)xnb_validContainsChiEng;

// 是否包含英文 数字
- (BOOL)xnb_validContainsNumEng;

// 是否包含中文
- (BOOL)xnb_hasChinese;

// 是否为图片链接
- (BOOL)xnb_imageURLString;

// 是否为JavaScript文件链接
- (BOOL)xnb_javascriptURLString;

// 是否为URL链接
- (BOOL)xnb_urlString;

// 是否为gif图片链接
- (BOOL)xnb_gifImageUrl;

// 是否包含emoji表情
- (BOOL)xnb_containsEmoji;

@end
