//
//  NetWorkTools.h
//  Lisheng
//
//  Created by 罗月麒 on 16/3/19.
//  Copyright © 2016年 Luo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger, XNAppOrigin) {
    XNCredit = 100,
    XNProductive,  // 供产品化使用
};

@interface XNNetWorkTools : NSObject

@property (nonatomic, copy) NSString *appUserID;
@property (nonatomic, copy) NSString *bundleName;

+ (instancetype)shareIntance;

- (void)setUpWithAppName:(NSString *)xnAppName appID:(NSString *)xnAppID appVersion:(NSString *)xnVersion salt:(NSString *)xnSalt;

// 产品化网络框架初始化
- (void)setUpProductiveWithAppName:(NSString *)xnAppName
                        appVersion:(NSString *)xnVersion
                         appOrigin:(XNAppOrigin)xnAppOrigin
                              salt:(NSString *)xnSalt ;

- (void)GetJSONDataWithUrl:(NSString *)url  success:(void (^)(id json))success fail:(void (^)(void))fail;

- (void)PostData:(NSString *)urlStr Parameters:(NSDictionary *)parameters success:(void (^)(id json))success fail:(void (^)(void))fail;

- (void)UpLoadMutiableTask:(NSString *)url
                Parameters:(NSDictionary *)parameters
                FilePathes:(NSDictionary *)fileDict
                  FileType:(NSString *)mimeType
                   success:(void (^)(id responseObject))success
                      fail:(void (^)(void))fail;

@end
