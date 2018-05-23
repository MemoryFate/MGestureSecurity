//
//  NSMutableArray+XNB.m
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/25.
//

#import "NSMutableArray+XNB.h"

@implementation NSMutableArray (XNB)

- (void)xnb_safeAddObject:(id)obj
{
    if (obj) {
        [self addObject:obj];
    }
}

- (BOOL)xnb_addObject:(id)obj
{
    if (!obj) {
        return NO;
    }
    [self addObject:obj];
    return YES;
}

- (void)xnb_safeAddObjectsFromArray:(NSArray *)otherArray
{
    if (otherArray.count) {
        [self addObjectsFromArray:otherArray];
    }
}

- (void)xnb_safeInsertObject:(id)obj atIndex:(NSUInteger)index
{
    if (obj && index <= self.count) {
        [self insertObject:obj atIndex:index];
    }
}

- (void)xnb_safeInsertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes
{
    if (objects.count && indexes) {
        [self insertObjects:objects atIndexes:indexes];
    }
}

- (void)xnb_safeRemoveObject:(id)anObject
{
    if (anObject && [self containsObject:anObject]) {
        [self removeObject:anObject];
    }
}

- (void)xnb_safeRemoveLastObject
{
    if (self.count) {
        [self removeLastObject];
    }
}

- (void)xnb_safeRemoveObject:(id)anObject inRange:(NSRange)aRange
{
    if (anObject && aRange.location + aRange.length < self.count) {
        [self removeObject:anObject inRange:aRange];
    }
}

- (void)xnb_safeRemoveObjectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        [self removeObjectAtIndex:index];
    }
}

- (void)xnb_safeRemoveObjectIdenticalTo:(id)anObject inRange:(NSRange)aRange
{
    if (anObject && aRange.location + aRange.length < self.count) {
        [self removeObjectIdenticalTo:anObject inRange:aRange];
    }
}

- (void)xnb_safeRemoveObjectsAtIndexex:(NSIndexSet *)indexes
{
    if (indexes) {
        [self removeObjectsAtIndexes:indexes];
    }
}

- (void)xnb_safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (anObject && index < self.count) {
        [self replaceObjectAtIndex:index withObject:anObject];
    }
}

- (void)xnb_safeReplaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects
{
    if (objects.count && indexes) {
        [self replaceObjectsAtIndexes:indexes withObjects:objects];
    }
}

@end
