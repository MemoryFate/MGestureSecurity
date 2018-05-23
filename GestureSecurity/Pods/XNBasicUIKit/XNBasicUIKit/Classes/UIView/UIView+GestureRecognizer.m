//
//  UIView+GestureRecognizer.m
//  XNBasicFramework
//
//  Created by 江红胡 on 2017/9/26.
//

#import "UIView+GestureRecognizer.h"
#import <objc/runtime.h>

static char kWhenTappedBlockKey;
static char kWhenDoubleTappedBlockKey;
static char kWhenLongPressedBlockKey;

@implementation UIView (GestureRecognizer)

- (void)xnb_removeAllGestures
{
    for (UITapGestureRecognizer *gesture in self.gestureRecognizers) {
        [self removeGestureRecognizer:gesture];
    }
}

- (void)xnb_whenSingleTapped:(XNBGestureRecognizerActionBlock)block
{
    UITapGestureRecognizer *gesture = [self addTapGestureRecognizerWithTaps:1 touches:1 selector:@selector(_viewWasTapped:)];
    gesture.cancelsTouchesInView = NO;
    gesture.delaysTouchesBegan = NO;
    gesture.delaysTouchesEnded = NO;
    [self _addRequiredToDoubleTapsRecognizer:gesture];
    [self _setBlock:block forKey:&kWhenTappedBlockKey];
}

- (void)xnb_whenDoubleTapped:(XNBGestureRecognizerActionBlock)block
{
    UITapGestureRecognizer *gesture = [self addTapGestureRecognizerWithTaps:1 touches:1 selector:@selector(_viewWasDoubleTapped:)];
    gesture.cancelsTouchesInView = NO;
    [self _addRequiredToDoubleTapsRecognizer:gesture];
    [self _setBlock:block forKey:&kWhenTappedBlockKey];
}

- (void)xnb_whenLongPressed:(XNBGestureRecognizerActionBlock)block
{
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_longPressed:)];
    gesture.cancelsTouchesInView = NO;
    [self addGestureRecognizer:gesture];
    [self _setBlock:block forKey:&kWhenLongPressedBlockKey];
}

- (void)_longPressed:(UILongPressGestureRecognizer *)longGesture
{
    [self _runBlockForKey:&kWhenLongPressedBlockKey forGesture:longGesture];
}

- (void)_viewWasDoubleTapped:(UITapGestureRecognizer *)tap
{
    [self _runBlockForKey:&kWhenDoubleTappedBlockKey forGesture:tap];
}

- (void)_viewWasTapped:(UITapGestureRecognizer *)tap
{
    [self _runBlockForKey:&kWhenTappedBlockKey forGesture:tap];
}

#pragma mark - Others

- (void)_runBlockForKey:(void *)blockKey forGesture:(UIGestureRecognizer *)tapGesture
{
    XNBGestureRecognizerActionBlock block = objc_getAssociatedObject(self, blockKey);
    if (block) {
        block(tapGesture);
    }
}

- (void)_setBlock:(XNBGestureRecognizerActionBlock)block forKey:(void *)blockKey
{
    self.userInteractionEnabled = YES;
    objc_setAssociatedObject(self, blockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UITapGestureRecognizer*)addTapGestureRecognizerWithTaps:(NSUInteger)taps touches:(NSUInteger)touches selector:(SEL)selector
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    tapGesture.numberOfTapsRequired = taps;
    tapGesture.numberOfTouchesRequired = touches;
    [self addGestureRecognizer:tapGesture];
    
    return tapGesture;
}

- (void)_addRequirementToSingleTapsRecognizer:(UIGestureRecognizer*) recognizer
{
    for (UIGestureRecognizer *gesture in [self gestureRecognizers]) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)gesture;
            if (tapGesture.numberOfTouchesRequired == 1 && tapGesture.numberOfTapsRequired == 1) {
                [tapGesture requireGestureRecognizerToFail:recognizer];
            }
        }
    }
}

- (void)_addRequiredToDoubleTapsRecognizer:(UIGestureRecognizer*) recognizer
{
    for (UIGestureRecognizer *gesture in [self gestureRecognizers]) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)gesture;
            if (tapGesture.numberOfTouchesRequired == 2 && tapGesture.numberOfTapsRequired == 1) {
                [recognizer requireGestureRecognizerToFail:tapGesture];
            }
        }
    }
}

@end
