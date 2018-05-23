//
//  XNBSingletonManager.m
//  XNBasicFramework
//
//  Created by 江红胡 on 2017/9/26.
//

#import "XNBSingletonManager.h"

@interface XNBSingletonManager ()<NSCopying>

@property (nonatomic, strong) NSMutableDictionary *sharedInstanceDictionary;
@property (nonatomic, strong) NSRecursiveLock *singletonLock;

@end


@implementation XNBSingletonManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sharedInstanceDictionary = [NSMutableDictionary dictionary];
        _singletonLock = [[NSRecursiveLock alloc] init];
    }
    
    return self;
}

+ (instancetype)sharedManager
{
    static XNBSingletonManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XNBSingletonManager alloc] init];
    });
    
    return manager;
}

- (id)sharedInstaceFor:(Class)aClass
{
    NSString *aKey = NSStringFromClass(aClass);
    
    id obj = nil;
    if (aKey) {
        obj = [self.sharedInstanceDictionary objectForKey:aKey];
        if (!obj) {
            obj = [[aClass alloc] init];
            [self.singletonLock lock];
            [self.sharedInstanceDictionary setObject:obj forKey:aKey];
            [self.singletonLock unlock];
        }
    }
    
    return obj;
}

- (id)sharedInstanceFor:(Class)aClass category:(NSString *)aKey
{
    NSString *className = NSStringFromClass(aClass);
    NSString *classKey = [NSString stringWithFormat:@"%@_%@", className, aKey];
    
    id obj = nil;
    if (classKey.length) {
        obj = [self.sharedInstanceDictionary objectForKey:classKey];
        if (!obj) {
            obj = [[aClass alloc] init];
            [self.singletonLock lock];
            [self.sharedInstanceDictionary setObject:obj forKey:classKey];
            [self.singletonLock unlock];
        }
    }
    
    return obj;
}

- (void)destorySharedInstanceFor:(Class)aClass
{
    NSString *aKey = NSStringFromClass(aClass);
    
    [self.singletonLock lock];
    id obj = nil;
    if (aKey.length) {
        obj = [self.sharedInstanceDictionary objectForKey:aKey];
        if (obj) {
            [self.sharedInstanceDictionary removeObjectForKey:aKey];
        }
    }
    [self.singletonLock unlock];
}

- (void)destorySharedInstanceFor:(Class)aClass category:(NSString *)aKey
{
    NSString *className = NSStringFromClass(aClass);
    NSString *classKey = [NSString stringWithFormat:@"%@_%@", className, aKey];
    
    [self.singletonLock lock];
    id obj = nil;
    if (classKey.length) {
        obj = [self.sharedInstanceDictionary objectForKey:classKey];
        if (obj) {
            [self.sharedInstanceDictionary removeObjectForKey:classKey];
        }
    }
    [self.singletonLock unlock];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
