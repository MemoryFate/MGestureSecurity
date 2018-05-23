//
//  XNBBaseRequestModel.h
//  XNBBaseModel
//
//  Created by 江红胡 on 2017/11/8.
//

#import <Foundation/Foundation.h>

#import "XNBNetworkManager.h"
#import "XNBBaseItem.h"

typedef NS_ENUM(NSInteger, XNBRequestModelLoadingState) {
    XNBRequestModelLoadingStateUnSet,
    XNBRequestModelLoadingStateLoading,
    XNBRequestModelLoadingStateFail,
    XNBRequestModelLoadingStateSuccess,
    XNBRequestModelLoadingStateCancel,
    XNBRequestModelLoadingStatePause
};


typedef NS_ENUM(NSInteger, XNBRequestErrorType) {
    XNBRequestErrorTypeNormal,    // 接口错误
    XNBRequestErrorTypeNetwork    // 网络异常
};


@protocol XNBRequestModelProtocol <NSObject>

// 请求
- (void)load;

// 取消
- (void)cancel;

// 是否正在请求中
- (BOOL)isLoading;

@end


typedef void(^XNBRequestModelCompletionBlock)(id<XNBRequestModelProtocol> model);


@interface XNBBaseRequestModel : NSObject<XNBRequestModelProtocol>

#pragma mark - Property
// 请求Url
@property (nonatomic, copy) NSString *requestUrl;

// 请求类型 GET/POST
@property (nonatomic, assign) XNBNetworkRequestType requestType;

// 请求参数字典集合
@property (nonatomic, strong) NSMutableDictionary *requestParams;

/**
 添加需要上传的图片集合, key为fileName value为filePathURL
 @{
    @"图片1" : @{
                @"fileName" : @"图片名称",
                @"filePathURL" : @"图片地址"
                },
    @"图片2" : @{
                @"fileName" : @"图片名称",
                @"filePathURL" : @"图片地址"
                }
 }
 */
@property (nonatomic, strong) NSMutableDictionary *requestPictParams;

// 返回数据
@property (nonatomic, copy) XNBBaseItem *parsedItem;

// 返回Model Class类型
@property (nonatomic, assign) Class parsedCls;

// 是否附加公共请求参数
@property (nonatomic, assign) BOOL needCommonParams;

// 是否附加图片集合
@property (nonatomic, assign) BOOL needPictParams;

// 数据回调
@property (nonatomic, copy) XNBRequestModelCompletionBlock completionBlock;

// 失败类型
@property (nonatomic, assign, readonly) XNBRequestErrorType errorType;

#pragma mark - Method
// 获取公共请求参数 字典集合  继承该类  要重写该方法
+ (NSMutableDictionary *)commonParams;

// 即将开始解析返回数据
- (void)willBeginParseData;

// 返回数据解析完成
- (void)didEndParsedData;

// 数据获取是否成功
- (BOOL)requestDataSuccess;

#pragma mark - Other
+ (NSMutableArray *)riseSortWithParam:(NSDictionary *)param;

+ (NSString *)md5ForArray:(NSArray *)array key:(NSString *)key;

@end
