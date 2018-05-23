//
//  XNBBaseCellItem.h
//  XNBasicViewController
//
//  Created by 江红胡 on 2017/10/9.
//

#import "XNBBaseItem.h"

@interface XNBBaseCellItem : XNBBaseItem

// 指定该cell的点击selector
@property (nonatomic, copy) NSString *didSelectSelector;

// 缓存Cell高度
@property (nonatomic, assign) CGFloat cellHeight;

@end
