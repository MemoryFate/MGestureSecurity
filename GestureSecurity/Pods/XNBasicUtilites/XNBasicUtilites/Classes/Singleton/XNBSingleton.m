//
//  XNBSingleton.m
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/26.
//

#import "XNBSingleton.h"
#import "XNBSingletonManager.h"

#undef    DECLARE_SINGLETON
#define DECLARE_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef    DEFINE_SINGLETON
#define DEFINE_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

@implementation XNBSingleton

+ (instancetype)sharedInstance
{
    return [[XNBSingletonManager sharedManager] sharedInstaceFor:[self class]];
}

+ (void)destorySharedInstance
{
    [[XNBSingletonManager sharedManager] destorySharedInstanceFor:[self class]];
}

@end
