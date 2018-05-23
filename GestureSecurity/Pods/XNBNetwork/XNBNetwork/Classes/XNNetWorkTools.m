//
//  NetWorkTools.m
//  Lisheng
//
//  Created by 罗月麒 on 16/3/19.
//  Copyright © 2016年 Luo. All rights reserved.
//

#import "XNNetWorkTools.h"
#import <CommonCrypto/CommonDigest.h>


static XNNetWorkTools *tool;

@interface XNNetWorkTools ()

@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *APPID;
@property (nonatomic, copy) NSString *salt;
@property (nonatomic, copy) NSString *productiveSalt;
@property (nonatomic, assign) XNAppOrigin appOrigin;

@end

@implementation XNNetWorkTools

+ (instancetype)shareIntance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[XNNetWorkTools alloc] init];
    });
    return tool;
}

- (void)setUpWithAppName:(NSString *)xnAppName appID:(NSString *)xnAppID appVersion:(NSString *)xnVersion salt:(NSString *)xnSalt{
    self.appVersion = xnVersion;
    self.APPID = xnAppID;
    self.appName = xnAppName;
    self.salt = xnSalt;
}

- (void)setUpProductiveWithAppName:(NSString *)xnAppName appVersion:(NSString *)xnVersion appOrigin:(XNAppOrigin)xnAppOrigin salt:(NSString *)xnSalt {
    self.appVersion = xnVersion;
    self.appName = xnAppName;
    self.productiveSalt = xnSalt;
    self.appOrigin = xnAppOrigin;
}

//AFNetWorking
- (void)GetJSONDataWithUrl:(NSString *)url  success:(void (^)(id json))success fail:(void (^)(void))fail
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    manager.requestSerializer.timeoutInterval = 60.0f;
    
    
    NSString *_nversion = @"default";
    
    url = [NSString stringWithFormat:@"%@&_nversion=%@", url, _nversion];
    
    url = [self appendingPublicParamWithOrigin:self.appOrigin url:url];
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableArray *array = [self riseSortWithUrl:url];
    NSString *_nsign = [self md5ForArray:array headerKey:self.salt];
    
    [manager.requestSerializer setValue:_nversion forHTTPHeaderField:@"_nversion"];
    [manager.requestSerializer setValue:_nsign forHTTPHeaderField:@"_nsign"];
    
//    NSLog(@"get里面url:%@", url);
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        success(dic);
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
        if (fail) {
            
            fail();
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        }
        
    }];
    
}

- (void)PostData:(NSString *)urlStr Parameters:(NSDictionary *)parameters success:(void (^)(id json))success fail:(void (^)(void))fail
{
        
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString *_nversion = @"default";
    [dict setObject:_nversion forKey:@"_nversion"];
    
    dict = [self setObjectWithParam:dict origin:self.appOrigin];
    
    NSMutableArray *array = [self riseSortWithParam:dict];
    NSString *_nsign = [self md5ForArray:array headerKey:self.salt];
    
    [manager.requestSerializer setValue:_nversion forHTTPHeaderField:@"_nversion"];
    [manager.requestSerializer setValue:_nsign forHTTPHeaderField:@"_nsign"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    [manager POST:urlStr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        //        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        //
        //        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
        //        NSLog(@"Failure error serialised - %@",serializedData);
        fail();
        
    }];
}

- (void)UpLoadMutiableTask:(NSString *)url Parameters:(NSDictionary *)parameters FilePathes:(NSDictionary *)fileDict FileType:(NSString *)mimeType success:(void (^)(id responseObject))success fail:(void (^)(void))fail{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString *_nversion = @"default";
    [dict setObject:_nversion forKey:@"_nversion"];
    
    dict = [self setObjectWithParam:dict origin:self.appOrigin];
    
    NSMutableArray *array = [self riseSortWithParam:dict];
    NSString *_nsign = [self md5ForArray:array headerKey:self.salt];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                              URLString:url
                                                                                             parameters:dict
                                                                              constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                                  
                                                                                  for(NSString * fileNameInLocal in [fileDict allKeys]) {
                                                                                      NSDictionary *fileInfo  = fileDict[fileNameInLocal];
                                                                                      [formData appendPartWithFileURL:fileInfo[@"filePathURL"]
                                                                                                                 name:fileNameInLocal
                                                                                                             fileName:fileInfo[@"fileName"]
                                                                                                             mimeType:mimeType error:nil];
                                                                                  }
                                                                                  
                                                                              } error:nil];
    
    
    [request setValue:_nversion forHTTPHeaderField:@"_nversion"];
    [request setValue:_nsign forHTTPHeaderField:@"_nsign"];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager uploadTaskWithStreamedRequest:request
                                               progress:^(NSProgress * _Nonnull uploadProgress) {
                                                   // This is not called back on the main queue.
                                                   // You are responsible for dispatching to the main queue for UI updates
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       //Update the progress view
                                                       
                                                       
                                                   });
                                               }
                                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                          if (error) {
                                              
                                              NSLog(@"%@",error);
                                              fail();
                                          } else {
                                              if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                                  success(responseObject);
                                              }else{
                                                  
                                                  fail();
                                              }
                                              
                                          }
                                          
                                      }];
    
    [uploadTask resume];
    
}

- (NSMutableArray *)riseSortWithUrl:(NSString *)url {
    
    NSRange range = [url rangeOfString:@"?"];
    //获取参数列表
    NSString *propertys = [url substringFromIndex:(int)(range.location+1)];
    //进行字符串的拆分，通过&来拆分，把每个参数分开
    NSArray *subArray = [propertys componentsSeparatedByString:@"&"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:subArray];
    
    for (int i = 0; i < array.count; i++) {
        if ([array[i] isEqualToString:@"sign"]) {
            [array removeObjectAtIndex:i];
        }
    }
    
    return array;
}

- (NSMutableArray *)riseSortWithParam:(NSDictionary *)param {
    
    NSMutableArray *array = [NSMutableArray array];
    [param enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *str = [NSString stringWithFormat:@"%@=%@", key, obj];
        [array addObject:str];
    }];
    
    for (int i = 0; i < array.count; i++) {
        if ([array[i] isEqualToString:@"sign"]) {
            [array removeObjectAtIndex:i];
        }
    }
    
    return array;
}

- (int)getStamp {
    return [[NSDate date] timeIntervalSince1970];
}

/**
 *   数据加密
 *   @param string 加密前
 *   @return 加密后
 */
- (NSString *)md5:(NSString *)string {
    if(string == nil || [string length] == 0)
        return nil;
    const char *value = [string UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (int)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]]; // 32 byte
    }
    return outputString;
}


- (NSString *)upperMd5:(NSString *)string {
    NSString *md5Str = [self md5:string];
    return [md5Str uppercaseString];
}

- (NSString *)md5ForArray:(NSArray *)array key:(NSString *)key {
    
    NSArray *array1 = [array sortedArrayUsingSelector:@selector(compare:)];
    
    NSString *signStr = [NSString stringWithFormat:@"%@&%@", [array1 componentsJoinedByString:@"&"], key];
    
    NSString *sign = [self md5:signStr];

    return sign;
}


- (NSString *)md5ForArray:(NSArray *)array headerKey:(NSString *)key {
    
    NSArray *array1 = [array sortedArrayUsingSelector:@selector(compare:)];
    
    NSString *signStr = [NSString stringWithFormat:@"%@&v__s_k_=%@", [array1 componentsJoinedByString:@"&"], key];
    
    NSString *sign = [self upperMd5:signStr];
    
    return sign;
}

#pragma +++++++++++拼接不同产品所需要的URL公共参数++++++++++
- (NSString *)appendingPublicParamWithOrigin:(XNAppOrigin)origin url:(NSString *)url {
    if (origin == XNProductive) {
        return [self appdendingProductiveWithUrl:url];
    }
    return url;
}

// 产品化所需要的公共参数：
- (NSString *)appdendingProductiveWithUrl:(NSString *)url {
    if (![url containsString:@"appName"]) {
        url = [NSString stringWithFormat:@"%@&appName=%@", url, self.appName];
    }
    if (![url containsString:@"appVersion"]) {
        url = [NSString stringWithFormat:@"%@&appVersion=%@", url, self.appVersion];
    }
    if (![url containsString:@"timestamp"]) {
        url = [NSString stringWithFormat:@"%@&timestamp=%d", url, [self getStamp]];
    }
    if (![url containsString:@"deviceType"]) {
        url = [NSString stringWithFormat:@"%@&deviceType=%@", url, @"I"];
    }
    if (![url containsString:@"appUserId"]) {
        url = [NSString stringWithFormat:@"%@&appUserId=%@", url, self.appUserID];
    }
    if (![url containsString:@"bundleName"]) {
        url = [NSString stringWithFormat:@"%@&bundleName=%@", url, self.bundleName];
    }
    url = [url stringByReplacingOccurrencesOfString:@"?&" withString:@"?"];
    if (![url isEqualToString:@"sign"]) {
        NSString *sign = [self md5ForArray:[self riseSortWithUrl:url] key:self.productiveSalt];
        url = [NSString stringWithFormat:@"%@&sign=%@", url, sign];
    }
    url = [url stringByReplacingOccurrencesOfString:@"?&" withString:@"?"];
    return url;
}

#pragma +++++++++++拼接不同产品所需要的post公共参数++++++++++

-  (NSMutableDictionary *)setObjectWithParam:(NSDictionary *)param origin:(XNAppOrigin)origin {
    if (origin == XNProductive) {
        return [self setObjectProductiveWithParam:param];
    }
    return [NSMutableDictionary dictionaryWithDictionary:param];
}

- (NSMutableDictionary *)setObjectProductiveWithParam:(NSDictionary *)param {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:param];
    [dict setObject:self.appName forKey:@"appName"];
    [dict setObject:self.appVersion forKey:@"appVersion"];
    [dict setObject:[NSString stringWithFormat:@"%d", [self getStamp]] forKey:@"timestamp"];
    [dict setObject:@"I" forKey:@"deviceType"];
    [dict setObject:self.appUserID forKey:@"appUserId"];
    [dict setObject:self.bundleName forKey:@"bundleName"];
    NSString *sign = [self md5ForArray:[self riseSortWithParam:dict] key:self.productiveSalt];
    [dict setObject:sign forKey:@"sign"];
    return dict;
}

- (NSString *)appUserID {
    if (!_appUserID) {
        _appUserID = @"";
    }
    return _appUserID;
}
- (NSString *)bundleName {
    if (!_bundleName) {
        _bundleName = @"";
    }
    return _bundleName;
}

@end
