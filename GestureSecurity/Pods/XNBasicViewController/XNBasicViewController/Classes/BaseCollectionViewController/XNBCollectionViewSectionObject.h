//
//  XNBCollectionViewSectionObject.h
//  XNBasicViewController
//
//  Created by 江红胡 on 2017/10/9.
//

#import <Foundation/Foundation.h>

@interface XNBCollectionViewSectionObject : NSObject

// 指定该section内cell的点击selector
@property (nonatomic, copy) NSString *didSelectSelector;

@property (nonatomic, assign) CGFloat headerHeight;      // header的头部高度
@property (nonatomic, assign) CGFloat footerHeight;      // footer的高度

@property (nonatomic, assign) BOOL openFlow;             // 是否瀑布流

// 仅开启瀑布流时有效
@property (nonatomic, assign) CGFloat horizontalSpacing; // 水平间隙
@property (nonatomic, assign) CGFloat verticalSpacing;   // 垂直间隙

@property (nonatomic, copy) NSString *identifier;        //标识符

@property (nonatomic, assign) CGSize cellItemSize;       // cell大小

// section下的数据源
@property (nonatomic, strong) NSMutableArray *items;

@end
