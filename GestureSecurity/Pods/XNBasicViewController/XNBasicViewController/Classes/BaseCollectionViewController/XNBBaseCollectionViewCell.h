//
//  XNBBaseCollectionViewCell.h
//  XNBasicViewController
//
//  Created by 江红胡 on 2017/10/9.
//

#import <UIKit/UIKit.h>

@interface XNBBaseCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) id cellItem;

// 初始化所有subView
- (void)setupSubViews;

// 指定Cell高度
+ (CGFloat)heightForCellItem:(id)item;

@end
