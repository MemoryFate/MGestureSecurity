//
//  XNBBaseTableViewCell.m
//  XNBasicViewController
//
//  Created by 江红胡 on 2017/10/9.
//

#import "XNBBaseTableViewCell.h"
#import "XNBBaseCellItem.h"

@implementation XNBBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
    if ([item isKindOfClass:[XNBBaseCellItem class]]) {
        CGFloat height = ((XNBBaseCellItem *)item).cellHeight;
        if (height > 0) {
            return height;
        }
    }
    
    return 45.f;
}

@end
