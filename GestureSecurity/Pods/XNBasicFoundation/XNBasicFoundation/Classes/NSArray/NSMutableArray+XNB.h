//
//  NSMutableArray+XNB.h
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/25.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (XNB)

#pragma mark - Safe
#pragma mark Add
- (void)xnb_safeAddObject:(id)obj;
- (void)xnb_safeAddObjectsFromArray:(NSArray *)otherArray;

- (BOOL)xnb_addObject:(id)obj;

#pragma mark Insert
- (void)xnb_safeInsertObject:(id)obj atIndex:(NSUInteger)index;
- (void)xnb_safeInsertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes;

#pragma mark Remove
- (void)xnb_safeRemoveObject:(id)anObject;
- (void)xnb_safeRemoveLastObject;
- (void)xnb_safeRemoveObject:(id)anObject inRange:(NSRange)aRange;
- (void)xnb_safeRemoveObjectAtIndex:(NSUInteger)index;
- (void)xnb_safeRemoveObjectIdenticalTo:(id)anObject inRange:(NSRange)aRange;
- (void)xnb_safeRemoveObjectsAtIndexex:(NSIndexSet *)indexes;

#pragma mark Replace
- (void)xnb_safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
- (void)xnb_safeReplaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects;

@end
