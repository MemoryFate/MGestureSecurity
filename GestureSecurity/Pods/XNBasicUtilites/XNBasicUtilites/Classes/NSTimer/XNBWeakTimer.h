//
//  XNBWeakTimer.h
//  XNBasicUtilites
//
//  Created by 江红胡 on 2017/10/24.
//

#import <Foundation/Foundation.h>

@interface XNBWeakTimer : NSObject

// 参照NSTimer穿参
+ (NSTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(id)userInfo
                                     repeats:(BOOL)repeats;

@end
