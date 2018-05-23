//
//  XNBSingletonManager.h
//  XNBasicFramework
//
//  Created by 江红胡 on 2017/9/26.
//

#import <Foundation/Foundation.h>

@interface XNBSingletonManager : NSObject

+ (instancetype)sharedManager;

- (id)sharedInstaceFor:(Class)aClass;
- (id)sharedInstanceFor:(Class)aClass category:(NSString *)aKey;

- (void)destorySharedInstanceFor:(Class)aClass;
- (void)destorySharedInstanceFor:(Class)aClass category:(NSString *)aKey;

@end
