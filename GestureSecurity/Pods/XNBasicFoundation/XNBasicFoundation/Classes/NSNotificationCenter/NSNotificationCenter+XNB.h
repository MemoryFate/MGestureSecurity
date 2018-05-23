//
//  NSNotificationCenter+XNB.h
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/25.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (XNB)

// 安全添加
- (void)xnb_safeAddObserver:(id)observer
                   selector:(SEL)aSelector
                       name:(NSString *)aName
                     object:(id)anObject;

@end
