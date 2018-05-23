//
//  XNBSingleton.h
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/26.
//

#import <Foundation/Foundation.h>

@interface XNBSingleton : NSObject

+ (instancetype)sharedInstance;

+ (void)destorySharedInstance;

@end
