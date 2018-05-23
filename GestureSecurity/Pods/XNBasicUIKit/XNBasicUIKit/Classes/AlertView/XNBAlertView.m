//
//  XNBAlertView.m
//  XNBasicUIKit
//
//  Created by 江红胡 on 2017/9/30.
//

#import "XNBAlertView.h"
#import <objc/runtime.h>

@interface UIAlertAction (MDFAlertAction)

@property (nonatomic, copy) XNBAlertViewOnDismiss onDismiss;

@end


@implementation UIAlertAction (MDFAlertAction)

@dynamic onDismiss;

- (void)setOnDismiss:(XNBAlertViewOnDismiss)onDismiss
{
    objc_setAssociatedObject(self, @selector(setOnDismiss:), onDismiss, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (XNBAlertViewOnDismiss)onDismiss
{
    return objc_getAssociatedObject(self, @selector(setOnDismiss:));
}

@end


@implementation XNBAlertView

+ (void)mdf_showWithTitle:(NSString *)title
                  message:(NSString *)message
                onDismiss:(void(^)(void))onDismiss
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissButtonAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (onDismiss) {
            onDismiss();
        }
    }];
    [alertController addAction:dismissButtonAction];
    [[XNBAlertView stackTopViewController] presentViewController:alertController animated:YES completion:nil];
}


+ (void)mdf_showWithTitle:(NSString *)title
                  message:(NSString *)message
                    delay:(float)delayInSeconds
                onDismiss:(void(^)(void))onDismiss
{
    // 0.0代表默认延时，即2s
    if (delayInSeconds <= 0.0) {
        delayInSeconds = 2.0;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [[XNBAlertView stackTopViewController] presentViewController:alertController animated:YES completion:^{
        // 延时关闭消息框，并执行用户自定义操作
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*delayInSeconds), dispatch_get_main_queue(),
                       ^{
                           // 自动被block retain
                           [alertController dismissViewControllerAnimated:YES completion:^{
                               // 允许为nil
                               if (onDismiss) {
                                   onDismiss();
                               }
                           }];
                           
                       });
    }];
}

+ (void)mdf_showWithTitle:(NSString *)title
                  message:(NSString *)message
      buttonsAndOnDismiss:(NSString *)cancelButtonTitle, ...
{
    va_list args;
    id arg = nil;
    XNBAlertViewOnDismiss onDismiss = nil;
    // iOS8以上使用UIAlertController
    // num记录action的位置
    int num = 0;
    // 用一个临时数组存放action，方便调换位置
    NSMutableArray *actionArray = [NSMutableArray array];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    // 先把第一个压入数组
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
                                                             if (action.onDismiss) {
                                                                 action.onDismiss(num);
                                                             }
                                                             
                                                         }];
    [actionArray addObject:cancelAction];
    
    // 扫描参数列表
    va_start(args, cancelButtonTitle);
    //        UIAlertAction *action;
    while ((arg = va_arg(args, id))) {
        if ([arg isKindOfClass:[NSString class]]) {
            num ++ ;
            // 建立action
            cancelAction = [UIAlertAction actionWithTitle:arg
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *action) {
                                                      if (action.onDismiss) {
                                                          action.onDismiss(num);
                                                      }
                                                  }];
            [actionArray addObject:cancelAction];
        } else {
            onDismiss = arg;
            break;
        }
    }
    va_end(args);
    
    // 设置回调
    if (onDismiss) {
        for (UIAlertAction *tempAction in actionArray) {
            tempAction.onDismiss = onDismiss;
        }
    }
    
    // 如果元素个数大于等于3个，把第一个元素放到最后面
    if (actionArray.count >= 3) {
        UIAlertAction *temp = [actionArray objectAtIndex:0];
        [actionArray removeObjectAtIndex:0];
        [actionArray addObject:temp];
    }
    for (UIAlertAction *action in actionArray) {
        [alertController addAction:action];
    }
    [[XNBAlertView stackTopViewController] presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Others
+ (UIViewController *)stackTopViewController
{
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = rootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

@end
