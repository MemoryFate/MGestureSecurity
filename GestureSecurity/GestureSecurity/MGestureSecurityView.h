//
//  XNBGestureSecurityView.h
//  GestureSecurity
//
//  Created by MemoryFate on 2018/5/16.
//  Copyright © 2018年 MemoryFate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGestureSecurityView : UIView

/**
 *  返回手势的密码
 */
@property (nonatomic, copy) void (^didFinishBlock)(NSString *str);

@end
