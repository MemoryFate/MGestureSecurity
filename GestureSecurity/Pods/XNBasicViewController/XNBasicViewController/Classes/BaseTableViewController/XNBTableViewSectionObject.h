//
//  XNBTableViewSectionObject.h
//  XNBasicViewController
//
//  Created by 江红胡 on 2017/10/9.
//

#import <Foundation/Foundation.h>

@interface XNBTableViewSectionObject : NSObject

// 指定该section内cell的点击selector
@property (nonatomic, copy) NSString *didSelectSelector;

@property (nonatomic, assign) CGFloat headerHeight; // header的头部高度
@property (nonatomic, copy) NSString *headerTitle;  // section的header
@property (nonatomic, strong) UIView *headerView;   // section的headerView

@property (nonatomic, assign) CGFloat footerHeight; // footer的高度
@property (nonatomic, copy) NSString *footerTitle;  // section的footer
@property (nonatomic, strong) UIView *footerView;   // section的footerView

@property (nonatomic, copy) NSString *identifier;   // 标识符

// 该section下的数据源
@property (nonatomic, strong) NSMutableArray *items;

@end
