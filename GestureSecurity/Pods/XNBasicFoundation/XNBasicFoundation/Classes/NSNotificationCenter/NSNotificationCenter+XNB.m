//
//  NSNotificationCenter+XNB.m
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/25.
//

#import "NSNotificationCenter+XNB.h"

@implementation NSNotificationCenter (XNB)

- (void)xnb_safeAddObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject
{
    [self removeObserver:observer name:aName object:anObject];
    [self addObserver:observer selector:aSelector name:aName object:anObject];
}

@end
