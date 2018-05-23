//
//  XNBNetworkManager.m
//  XNBasicFramework
//
//  Created by 江红胡 on 2017/9/26.
//

#import "XNBNetworkManager.h"
#import "AFNetworking.h"
#import "NSArray+XNB.h"
#import "NSDictionary+XNB.h"
#import "NSMutableDictionary+XNB.h"

@interface XNBNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong) NSMutableDictionary *paramsDictionary;

@property (nonatomic ,strong) NSMutableDictionary *requestPictParams;

@end


@implementation XNBNetworkManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    }
    
    return self;
}

// 添加公共请求参数(Header)
- (void)xnb_addCommonRequestHeaderParams:(NSDictionary *)commonParams withType:(XNBNetworkCommonParamsType)paramsType
{
    switch (paramsType) {
        case XNBNetworkCommonParamsTypeHeader: {
            [self.paramsDictionary removeAllObjects];
            self.paramsDictionary = nil;
            
            for (int i = 0; i < commonParams.allKeys.count; i++) {
                NSString *key = [commonParams.allKeys xnb_safeObjectAtIndex:i];
                NSString *value = [commonParams xnb_safeObjectForKey:key];
                
                if (key.length && value.length) {
                    [self.sessionManager.requestSerializer setValue:value forHTTPHeaderField:key];
                }
            }
        }
            break;
        case XNBNetworkCommonParamsTypeBody:{
            for (int i = 0; i < commonParams.allKeys.count; i++) {
                NSString *key = [commonParams.allKeys xnb_safeObjectAtIndex:i];
                
                if (key.length) {
                    [self.sessionManager.requestSerializer setValue:@"" forHTTPHeaderField:key];
                }
            }
            
            self.paramsDictionary = [commonParams mutableCopy];
        }
            break;
        default:
            break;
    }
    
}

- (void)xnb_addUploadRequestPictureParams:(NSMutableDictionary *)requestPictParams{
    [self.requestPictParams removeAllObjects];
    self.requestPictParams = nil;
    if (requestPictParams) {
        self.requestPictParams = [requestPictParams mutableCopy];
    }
}

- (NSURLSessionDataTask *)request:(NSString *)urlString
                             type:(XNBNetworkRequestType)requstType
                       parameters:(NSMutableDictionary *)parameters
                     successBlock:(XNBNetworkRequestSuccessBlock)successBlock
                      failedBlock:(XNBNetworkRequestFailedBlock)failedBlock
{
    NSURLSessionDataTask *operation = nil;
    
    if (!urlString.length) {
        return operation;
    }
    
    if (self.paramsDictionary) {
        [parameters xnb_safeAppendDictionary:self.paramsDictionary];
    }
    
    switch (requstType) {
        case XNBNetworkRequestTypeGet: {
            NSString *requestURLString = [XNBNetworkManager baseURL:urlString withParams:parameters];
            operation = [self.sessionManager GET:requestURLString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                if (successBlock) {
                    successBlock(responseObject);
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                if (failedBlock) {
                    failedBlock(error);
                }
            }];
            
            break;
        }
        case XNBNetworkRequestTypePost: {
            operation = [self.sessionManager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (successBlock) {
                    successBlock(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failedBlock) {
                    failedBlock(error);
                }
            }];
            
            break;
        }
        case XNBNetworkRequestTypeUpload:{
            NSMutableURLRequest *request = [self.sessionManager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                for (NSString *fileName in [self.requestPictParams allKeys]) {
                    NSDictionary *fileInfo  = [self.requestPictParams xnb_safeObjectForKey:fileName];
                    [formData appendPartWithFileURL:[fileInfo xnb_safeObjectForKey:@"filePathURL"] name:fileName fileName:[fileInfo xnb_safeObjectForKey:@"fileName"] mimeType:@"image/png" error:nil];
                }
            } error:nil];
            operation = [self.sessionManager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                if (error) {
                    if (failedBlock) {
                        failedBlock(error);
                    }
                } else {
                    if (successBlock) {
                        successBlock(responseObject);
                    }
                }
            }];
            [operation resume];
        }break;
            
        default:
            break;
    }
    
    return operation;
}

- (void)cancleAllOperations
{
    [[self.sessionManager operationQueue] cancelAllOperations];
}

#pragma mark - Others

+ (NSString *)baseURL:(NSString *)url withParams:(NSDictionary *)paramsDict
{
    if (paramsDict && paramsDict.allKeys.count) {
        NSString *urlString = [NSString stringWithFormat:@"%@?", url];
        for (int i = 0; i < paramsDict.allKeys.count; i++) {
            NSString *key = [paramsDict.allKeys xnb_safeObjectAtIndex:i];
            
            if (i == (paramsDict.allKeys.count - 1)) {
                urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"%@=%@", key, paramsDict[key]]];
            } else {
                urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", key, paramsDict[key]]];
            }
            url = urlString;
        }
    }
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
