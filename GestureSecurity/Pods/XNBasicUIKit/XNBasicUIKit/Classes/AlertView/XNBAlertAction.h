//
//  XNBActionAlert.h
//  XNBasicUIKit
//
//  Created by 王嘉倩 on 2017/12/11.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XNBAlertActionStyle) {
    XNBAlertActionStyleDefult = 0, // 只有一个按钮时
    XNBAlertActionStyleCancel // 包含取消按钮
};

@interface XNBAlertAction : UIView

@property (nonatomic, strong) UIColor *titleTextColor;
@property (nonatomic, strong) UIFont *titleTextFont;

@property (nonatomic, strong) UIColor *messageTextColor;
@property (nonatomic, strong) UIFont *messageTextFont;

@property (nonatomic, strong) UIColor *defultBtnTextColor;
@property (nonatomic, strong) UIFont *defultBtnTextFont;

@property (nonatomic, strong) UIColor *cancelBtnTextColor;
@property (nonatomic, strong) UIFont *cancelBtnTextFont;

@property (nonatomic) NSTextAlignment titleTextAlignment; // 默认左对齐

- (void)alertActionStyle:(XNBAlertActionStyle)alertActionStyle message:(NSString *)message defultTitle:(NSString *)defultTitle defultHandler:(void (^)(void))defultHandler cancelTitle:(NSString *)cancelTitle cancelHandler:(void (^)(void))cancelHandler;

- (void)alertActionStyle:(XNBAlertActionStyle)alertActionStyle title:(NSString *)title message:(NSString *)message defultTitle:(NSString *)defultTitle defultHandler:(void (^)(void))defultHandler cancelTitle:(NSString *)cancelTitle cancelHandler:(void (^)(void))cancelHandler;

@end
