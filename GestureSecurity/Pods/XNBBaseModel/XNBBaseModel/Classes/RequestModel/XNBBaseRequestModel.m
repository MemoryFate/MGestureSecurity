//
//  XNBBaseRequestModel.m
//  XNBBaseModel
//
//  Created by 江红胡 on 2017/11/8.
//

#import "XNBBaseRequestModel.h"
#import "XNBBaseResponseModel.h"
#import "UIDevice+XNB.h"
#import "NSMutableDictionary+XNB.h"
#import "NSMutableArray+XNB.h"
#import "NSString+MD5.h"
#import "XNBasicMacros.h"

@interface XNBBaseRequestModel ()

// 网络请求
@property (nonatomic, strong) NSURLSessionDataTask *requestTask;

@property (nonatomic, assign) XNBRequestErrorType errorType;

@property (nonatomic, assign) XNBRequestModelLoadingState state;

@property (nonatomic, strong) id responseObject;
@property (nonatomic, strong) NSError *error;

@end

static NSString * const kXNBHeaderKey = @"xinyong234@21@#$fasd";

@implementation XNBBaseRequestModel

- (void)dealloc
{
    [_requestTask cancel];
    _requestTask = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _needCommonParams = YES;
        _needPictParams = NO;
    }
    
    return self;
}

+ (NSMutableDictionary *)commonParams
{
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
//    [paramsDict xnb_safeSetObject:[UserInfo shareUserInfo].user_id forKey:@"userId"];
//    [paramsDict xnb_safeSetObject:appName forKey:@"appName"];
//    [paramsDict xnb_safeSetObject:kXNBClientVersion forKey:@"appVersion"];
//    [paramsDict xnb_safeSetObject:@"AppStore" forKey:@"appChannel"];
//    [paramsDict xnb_safeSetObject:[[MobilePhoneInfomation shareInstance] UUIDString] forKey:@"deviceId"];
//    [paramsDict xnb_safeSetObject:[[UIDevice currentDevice] xnb_phoneType] forKey:@"phoneType"];
//    [paramsDict xnb_safeSetObject:@"I" forKey:@"phoneSystem"];
//    [paramsDict xnb_safeSetObject:kXNBCurrentSystemVersion forKey:@"phoneVersion"];
//    [paramsDict xnb_safeSetObject:[[UIDevice currentDevice] xnb_idfaString] forKey:@"idfa"];
//    NSString *sign = [self md5ForArray:[self riseSortWithParam:paramsDict] key:@"2B6FE62A63AFE561"];
//    [paramsDict xnb_safeSetObject:sign forKey:@"sign"];

    return paramsDict;
}

- (void)willBeginParseData
{}

- (void)didEndParsedData
{}

- (BOOL)requestDataSuccess
{
    XNBBaseResponseModel *responseModel = (XNBBaseResponseModel *)self.parsedItem;
    if (responseModel && responseModel.result && responseModel.result.success) {
        return YES;
    }
    
    return NO;
}

#pragma mark - XNCashCatRequestModelProtocol
- (void)load
{
    if (!self.requestUrl.length) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _onNetworkFailed];
        });
        
        return;
    }
    
    self.responseObject = nil;
    self.error = nil;
    
    self.parsedItem = nil;
    
    [self.requestTask cancel];
    self.requestTask = nil;
    
    // 请求参数+公共请求参数
    NSMutableDictionary *allparams = [self _mergeAllParams];
    
    NSMutableDictionary *headerParams = [NSMutableDictionary dictionary];
    NSMutableArray *array = [XNBBaseRequestModel riseSortWithParam:allparams];
    
    NSString *_nsign = [XNBBaseRequestModel md5ForArray:array key:kXNBHeaderKey];
    NSString *_nversion = @"default";
    
    [headerParams xnb_safeSetObject:_nsign forKey:@"_nsign"];
    [headerParams xnb_safeSetObject:_nversion forKey:@"_nversion"];
    
    [[XNBNetworkManager sharedInstance] xnb_addCommonRequestHeaderParams:headerParams withType:(XNBNetworkCommonParamsTypeHeader)];
    
    // 添加需要上传的图片集合
    if (self.needPictParams) {
        NSMutableDictionary *requestPictParam = self.requestPictParams ? self.requestPictParams : [@{} mutableCopy];
        [[XNBNetworkManager sharedInstance] xnb_addUploadRequestPictureParams:requestPictParam];
    }
    
    __weak typeof(self) weakSelf = self;
    self.state = XNBRequestModelLoadingStateLoading;
    self.requestTask = [[XNBNetworkManager sharedInstance] request:self.requestUrl type:self.requestType parameters:allparams successBlock:^(id responseObject) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf.responseObject = responseObject;
            [strongSelf _onNetworkSuccess];
        }
    } failedBlock:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf.error = error;
            [strongSelf _onNetworkFailed];
        }
    }];
}

- (void)cancel
{
    self.state = XNBRequestModelLoadingStateCancel;
    
    [self.requestTask cancel];
}

- (BOOL)isLoading
{
    return (self.state == XNBRequestModelLoadingStateLoading);
}

#pragma mark - Others
- (void)_onNetworkSuccess
{
    self.state = XNBRequestModelLoadingStateSuccess;
    
    if (self.parsedCls && [self.parsedCls isSubclassOfClass:[XNBBaseResponseModel class]] && [self.responseObject isKindOfClass:[NSDictionary class]]) {
        [self willBeginParseData];
        
        NSDictionary *responseObjDict = [self _autoParseObjectWithResponseObject:self.responseObject];
        NSDictionary *resultDict = [self.responseObject objectForKey:@"result"];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            BOOL success = false;
            XNBBaseResponseModel *responseModel = nil;
            
            if ([resultDict isKindOfClass:[NSDictionary class]]) {
                
                success = [[resultDict objectForKey:@"success"] boolValue];
                
                if (success) {
                    responseModel = [[self.parsedCls alloc] init];
                    [responseModel parseJSONValue:responseObjDict];
                    responseModel.result.success = success;
                    
                } else {
                    responseModel = [[XNBBaseResponseModel alloc] init];
                    responseModel.result = [[XNBResponseResultModel alloc] init];
                    responseModel.result.success = [[resultDict objectForKey:@"success"] boolValue];
                    responseModel.result.message = [NSString stringWithFormat:@"%@", resultDict[@"message"]];
                    responseModel.result.code = [NSString stringWithFormat:@"%@", resultDict[@"code"]];
                }
                
            }
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSDictionary *resultDict = [responseObjDict objectForKey:@"result"];
                
                BOOL success = false;
                XNBBaseResponseModel *responseModel = nil;
                
                if ([resultDict isKindOfClass:[NSDictionary class]]) {
                    
                    success = [[resultDict objectForKey:@"success"] boolValue];
                    if (success) {
                        responseModel = [[self.parsedCls alloc] init];
                        [responseModel parseJSONValue:responseObjDict];
                        responseModel.result.success = success;
                        
                    } else {
                        responseModel = [[XNBBaseResponseModel alloc] init];
                        responseModel.result = [[XNBResponseResultModel alloc] init];
                        responseModel.result.success = [[resultDict objectForKey:@"success"] boolValue];
                        responseModel.result.message = [NSString stringWithFormat:@"%@", resultDict[@"message"]];
                        responseModel.result.code = [NSString stringWithFormat:@"%@", resultDict[@"code"]];
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    _parsedItem = responseModel;
                    
                    [self didEndParsedData];
                    
                    __strong typeof(self) strongSelf = self;
                    if (self.completionBlock) {
                        self.completionBlock(strongSelf);
                    }
                });
            });
        });
      
    } else {
        self.errorType = XNBRequestErrorTypeNormal;
        if (self.completionBlock) {
            self.completionBlock(self);
        }
    }
}

- (void)_onNetworkFailed
{
    self.state = XNBRequestModelLoadingStateFail;
    self.parsedItem = nil;
    
    if (self.error.code == -1009) {
        self.errorType = XNBRequestErrorTypeNetwork;
        if (self.completionBlock) {
            self.completionBlock(self);
        }
    } else {
        self.errorType = XNBRequestErrorTypeNormal;
        if (self.completionBlock) {
            self.completionBlock(self);
        }
    }
}

- (NSDictionary *)_autoParseObjectWithResponseObject:(NSDictionary *)dictionary
{
    NSMutableDictionary *newDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    NSDictionary *dataDict = [newDictionary objectForKey:@"data"];
    if (dataDict && [dataDict isKindOfClass:[NSDictionary class]]) {
        [newDictionary xnb_safeAppendDictionary:dataDict];
        
        [newDictionary xnb_safeRemoveObjectForKey:@"data"];
    }
    
    return [newDictionary copy];
}

- (NSMutableDictionary *)_mergeAllParams
{
    NSMutableDictionary *requestParam = self.requestParams ? self.requestParams : [@{} mutableCopy];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:requestParam];
    
    if (self.needCommonParams) {
        NSMutableDictionary *commonParams = [[self class] commonParams];
        [dict addEntriesFromDictionary:commonParams];
    }
    
    return dict;
}

#pragma mark - Other
+ (NSMutableArray *)riseSortWithParam:(NSDictionary *)param
{
    NSMutableArray *array = [NSMutableArray array];
    [param enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *str = [NSString stringWithFormat:@"%@=%@", key, obj];
        [array xnb_safeAddObject:str];
    }];
    
    for (int i = 0; i < array.count; i++) {
        if ([array[i] isEqualToString:@"sign"]) {
            [array xnb_safeRemoveObjectAtIndex:i];
        }
    }
    
    return array;
}

+ (NSString *)md5ForArray:(NSArray *)array key:(NSString *)key
{
    NSArray *array1 = [array sortedArrayUsingSelector:@selector(compare:)];
    
    NSString *signStr = [NSString stringWithFormat:@"%@&v__s_k_=%@", [array1 componentsJoinedByString:@"&"], key];
    
    NSString *sign = [signStr xnb_md5:signStr];
    
    return sign;
}

@end
