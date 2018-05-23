//
//  UIDevice+XNB.m
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/26.
//

#import "UIDevice+XNB.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <AdSupport/AdSupport.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <sys/utsname.h>

@implementation UIDevice (XNB)

- (XNBNetworkType)xnb_networkType
{
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    switch (status) {
        case AFNetworkReachabilityStatusUnknown: {
            return XNBNetworkTypeOther;
            break;
        }
        case AFNetworkReachabilityStatusNotReachable: {
            return XNBNetworkTypeUnReachable;
            break;
        }
        case AFNetworkReachabilityStatusReachableViaWWAN: {
            CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
            if ([networkInfo respondsToSelector:@selector(currentRadioAccessTechnology)]) {
                NSString *currRadioAccessTech = networkInfo.currentRadioAccessTechnology;
                if ([currRadioAccessTech isEqualToString:CTRadioAccessTechnologyGPRS] ||
                    [currRadioAccessTech isEqualToString:CTRadioAccessTechnologyEdge]) {
                    return XNBNetworkType2G;
                } else if ([currRadioAccessTech isEqualToString:CTRadioAccessTechnologyWCDMA] ||
                           [currRadioAccessTech isEqualToString:CTRadioAccessTechnologyHSDPA] ||
                           [currRadioAccessTech isEqualToString:CTRadioAccessTechnologyHSUPA] ||
                           [currRadioAccessTech isEqualToString:CTRadioAccessTechnologyCDMA1x] ||
                           [currRadioAccessTech isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0] ||
                           [currRadioAccessTech isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA] ||
                           [currRadioAccessTech isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB] ||
                           [currRadioAccessTech isEqualToString:CTRadioAccessTechnologyeHRPD]) {
                    return XNBNetworkType3G;
                } else if ([currRadioAccessTech isEqualToString:CTRadioAccessTechnologyLTE]) {
                    return XNBNetworkType4G;
                } else {
                    return XNBNetworkType4G;
                }
            }
            return XNBNetworkTypeOther;
            break;
        }
        case AFNetworkReachabilityStatusReachableViaWiFi: {
            return XNBNetworkTypeWifi;
            break;
        }
    }
}

- (NSString *)xnb_phoneType
{
    NSString *str = [self currentDeviceModel];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return str;
}

- (NSString *)xnb_OperatorInfo
{
    // 获取运营商信息
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    NSString *carrierStr = carrier.carrierName;
    if (carrierStr) {
        return carrierStr;
    }
    return @"";
}

- (NSString *)xnb_idfaString
{
    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    if (adSupportBundle == nil) {
        return @"";
    } else {
        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
        if(asIdentifierMClass == nil) {
            return @"";
        } else {
            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
            if (asIM == nil) {
                return @"";
            } else {
                if(asIM.advertisingTrackingEnabled) {
                    return [asIM.advertisingIdentifier UUIDString];
                } else {
                    return [asIM.advertisingIdentifier UUIDString];
                }
            }
        }
    }
}

- (NSString *)xnb_idfvString
{
    if([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    return @"";
}

- (NSString *)xnb_macAddress
{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return macString;
}

#pragma mark - Others
//获取设备信号
- (NSString *)currentDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus(A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone 5SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
}

@end
