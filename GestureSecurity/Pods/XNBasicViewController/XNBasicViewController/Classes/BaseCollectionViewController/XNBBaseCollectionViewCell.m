//
//  XNBBaseCollectionViewCell.m
//  XNBasicViewController
//
//  Created by 江红胡 on 2017/10/9.
//

#import "XNBBaseCollectionViewCell.h"

@implementation XNBBaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    
    return self;
}

- (void)setupSubViews
{
    
}

- (void)setCellItem:(id)cellItem
{
    _cellItem = cellItem;
}

+ (CGFloat)heightForCellItem:(id)item
{
    return 45.f;
}

@end
