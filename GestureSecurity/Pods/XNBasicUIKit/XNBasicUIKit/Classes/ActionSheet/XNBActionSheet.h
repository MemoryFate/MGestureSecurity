//
//  XNBActionSheet.h
//  XNBasicUIKit
//
//  Created by 王嘉倩 on 2017/12/8.
// 自定义 ActionSheet

#import <UIKit/UIKit.h>

@interface XNBActionSheet : UIView

/**
 没有取消按钮样式时（ActionSheet的样式均一样，没有特别样式），直接调用init方法即可
 @return 返回 ActionSheet
 */
- (instancetype)init;

/**
 有取消按钮样式的ActionSheet (最底部有单独一个按钮的样式，通常都是取消)

 @param title 按钮的标题
 @param handler 点击按钮执行的方法
 @return 返回 ActionSheet
 */
- (instancetype)initCancelActionWithTitle:(NSString *)title handler:(void (^)(void))handler;

/**
 初始化后添加选项需要执行的方法

 @param titleArr 按钮标题数组，按照从上到下的顺序传
 @param handler 点击按钮后执行的方法，index从0开始
 */
- (void)addActionWithTitleArr:(NSArray *)titleArr handler:(void (^)(int index))handler;

@end
