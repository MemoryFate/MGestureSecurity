//
//  XNBNetworkManager.h
//  XNBasicFramework
//
//  Created by 江红胡 on 2017/9/26.
//

#import "XNBSingleton.h"

typedef NS_ENUM(NSInteger, XNBNetworkRequestType) {
    XNBNetworkRequestTypeGet = 0,      // GET
    XNBNetworkRequestTypePost,         // POST
    XNBNetworkRequestTypeDownload,     // 下载
    XNBNetworkRequestTypeUpload        // 上传
};


typedef NS_ENUM(NSInteger, XNBNetworkCommonParamsType) {
    XNBNetworkCommonParamsTypeHeader = 0,   // Header
    XNBNetworkCommonParamsTypeBody,         // Body
};

// 请求成功 回调
typedef void(^XNBNetworkRequestSuccessBlock)(id responseObject);
// 请求失败 回调
typedef void(^XNBNetworkRequestFailedBlock)(NSError *error);


@interface XNBNetworkManager : XNBSingleton

// 添加公共请求参数(Header)  type：公共参数是放在Header里面，还是请求body
- (void)xnb_addCommonRequestHeaderParams:(NSDictionary *)commonParams withType:(XNBNetworkCommonParamsType)paramsType;

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
- (void)xnb_addUploadRequestPictureParams:(NSMutableDictionary *)requestPictParams;

// 发起请求 [仅限于GET/POST/Upload]
- (NSURLSessionDataTask *)request:(NSString *)urlString
                             type:(XNBNetworkRequestType)requstType
                       parameters:(NSMutableDictionary *)parameters
                     successBlock:(XNBNetworkRequestSuccessBlock)successBlock
                      failedBlock:(XNBNetworkRequestFailedBlock)failedBlock;

// 取消所有请求
- (void)cancleAllOperations;

@end
