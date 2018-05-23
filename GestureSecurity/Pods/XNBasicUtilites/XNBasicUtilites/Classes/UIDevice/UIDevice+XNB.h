//
//  UIDevice+XNB.h
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/26.
//

#import <UIKit/UIKit.h>

// 手机网络类型
typedef NS_ENUM(NSInteger, XNBNetworkType) {
    XNBNetworkTypeUnReachable,
    XNBNetworkTypeWifi,
    XNBNetworkTypeOther,
    XNBNetworkType2G,
    XNBNetworkType3G,
    XNBNetworkType4G
};

@interface UIDevice (XNB)

// 获取手机网络类型
- (XNBNetworkType)xnb_networkType;

// 手机型号
- (NSString *)xnb_phoneType;

// 运营商
- (NSString *)xnb_OperatorInfo;

// 获取idfa
- (NSString *)xnb_idfaString;

// 获取idfv
- (NSString *)xnb_idfvString;

// mac地址
- (NSString *)xnb_macAddress;

@end
