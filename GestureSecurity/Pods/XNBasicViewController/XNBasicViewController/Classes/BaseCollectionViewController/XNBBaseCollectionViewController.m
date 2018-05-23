//
//  XNBBaseCollectionViewController.m
//  XNBasicViewController
//
//  Created by 江红胡 on 2017/10/9.
//

#import "XNBBaseCollectionViewController.h"
#import "MJRefreshNormalHeader.h"
#import "XNBasicMacros.h"
#import "NSMutableArray+XNB.h"
#import "NSArray+XNB.h"
#import "UIView+Frame.h"
#import "MJRefreshAutoNormalFooter.h"

@interface XNBBaseCollectionViewController ()

@end


@implementation XNBBaseCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupCollectionView];
}

- (void)setupCollectionView
{
    self.columnNumber = 2;
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [self.flowLayout setMinimumInteritemSpacing:0.5f];
    [self.flowLayout setMinimumLineSpacing:1.f];
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.flowLayout.itemSize = CGSizeMake(80, 80);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sectionArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    XNBCollectionViewSectionObject *sectionObj = [self.sectionArray xnb_safeObjectAtIndex:section];
    return sectionObj.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id cellItem = [self getItemAtIndexPath:indexPath];
    Class cls = [[self class] cellClsForCellItem:cellItem];
    NSString *cellID = [NSString stringWithFormat:@"%@_%@", NSStringFromClass([cellItem class]), NSStringFromClass(cls)];
    
    XNBBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[cls alloc] init];
    }
    
    // 瀑布流
    XNBCollectionViewSectionObject *sectionObj = [self.sectionArray xnb_safeObjectAtIndex:indexPath.section];
    if (sectionObj.openFlow) {
        NSInteger currentColumn = indexPath.row % self.columnNumber;
        NSInteger currentRow = indexPath.row / self.columnNumber;
        
        CGFloat positionX = 0;
        CGFloat positionY = 0;
        if (currentColumn > 0 || currentRow > 0) {
            if (currentColumn == 0) {
                positionX = 0;
            } else {
                positionX = (self.flowLayout.itemSize.width + sectionObj.horizontalSpacing) *currentColumn;
            }
            
            for (NSInteger i = 0; i < currentRow; i++) {
                NSInteger position = currentColumn + i * self.columnNumber;
                XNBBaseCollectionCellItem *lastCellItem = [self getItemAtIndexPath:[NSIndexPath indexPathForRow:position inSection:indexPath.section]];
                if (currentRow > 0) {
                    positionY += sectionObj.verticalSpacing;
                }
                positionY += lastCellItem.cellItemSize.height;
            }
        }
        
        cell.x = positionX;
        cell.y = positionY;
    }
    
    [self configForCell:cell item:cellItem];
    [cell setCellItem:cellItem];
    
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id cellItem = [self getItemAtIndexPath:indexPath];
    XNBCollectionViewSectionObject *secionObj = [self.sectionArray xnb_safeObjectAtIndex:indexPath.section];
    
    if (([cellItem isKindOfClass:[XNBBaseCellItem class]] && ((XNBBaseCellItem *)cellItem).didSelectSelector.length) || secionObj.didSelectSelector.length) {
        NSString *itemSelectorString = ((XNBBaseCellItem *)cellItem).didSelectSelector;
        NSString *sectionSelectorString = [secionObj didSelectSelector];
        
        NSString *selectorString = itemSelectorString.length ? itemSelectorString : sectionSelectorString;
        if (selectorString.length) {
            SEL selector = NSSelectorFromString(selectorString);
            if (selector != NULL && [self respondsToSelector:selector]) {
                NSMethodSignature *ms = [self methodSignatureForSelector:selector];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                if ([ms numberOfArguments] == 2) { //至少2个,self 与 _cmd
                    [self performSelector:selector];
                } else if ([ms numberOfArguments] == 3) {
                    [self performSelector:selector withObject:cellItem];
                } else if ([ms numberOfArguments] == 4) {
                    [self performSelector:selector withObject:cellItem withObject:indexPath];
                } else {
                    //
                }
#pragma clang diagnostic pop
            }
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    XNBCollectionViewSectionObject *sectionObj = [self.sectionArray xnb_safeObjectAtIndex:section];
    return CGSizeMake(kXNBScreenWidth, sectionObj.headerHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    XNBCollectionViewSectionObject *sectionObj = [self.sectionArray xnb_safeObjectAtIndex:section];
    return CGSizeMake(kXNBScreenWidth, sectionObj.footerHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    XNBCollectionViewSectionObject *sectionObj = [self.sectionArray xnb_safeObjectAtIndex:section];
    return sectionObj.horizontalSpacing > 0 ? sectionObj.horizontalSpacing : 0.5f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    XNBCollectionViewSectionObject *sectionObj = [self.sectionArray xnb_safeObjectAtIndex:section];
    return sectionObj.verticalSpacing > 0 ? sectionObj.verticalSpacing : 1.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XNBCollectionViewSectionObject *sectionObj = [self.sectionArray xnb_safeObjectAtIndex:indexPath.section];
    if (sectionObj.cellItemSize.width > 0 && sectionObj.cellItemSize.height > 0) {
        return sectionObj.cellItemSize;
    } else {
        XNBBaseCollectionCellItem *cellItem = [self getItemAtIndexPath:indexPath];
        
        if (cellItem.cellItemSize.width == 0 && cellItem.cellItemSize.height == 0) {
            cellItem.cellItemSize = self.flowLayout.itemSize;
        }
        
        return cellItem.cellItemSize;
    }
}

#pragma mark - Config

+ (Class)cellClsForCellItem:(id)item
{
    return [XNBBaseCollectionViewCell class];
}

- (void)configForCell:(XNBBaseCollectionViewCell *)cell item:(id)item
{
    
}

#pragma mark - Refresh & Loading More
- (void)setNeedPullDownRefresh:(BOOL)isNeedPullDownRefresh
{
    _needPullDownRefresh = isNeedPullDownRefresh;
    if (_needPullDownRefresh) {
        if (!_refreshHeader) {
            self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownToRefreshAction)];
        }
        
        self.collectionView.mj_header = self.refreshHeader;
    } else {
        [self.collectionView.mj_header removeFromSuperview];
    }
}

- (void)setNeedPullUpLoadMore:(BOOL)isNeedPullUpLoadMore
{
    _needPullUpLoadMore = isNeedPullUpLoadMore;
    if (_needPullUpLoadMore) {
        if (!_refreshFooter) {
            self.refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpToLoadMoreAction)];
        }
        
        self.collectionView.mj_footer = self.refreshFooter;
    } else {
        [self.collectionView.mj_footer removeFromSuperview];
    }
}

- (void)pullDownToRefreshAction
{}

- (void)pullUpToLoadMoreAction
{}

#pragma mark - Others
- (id)getItemAtIndexPath:(NSIndexPath *)indexPath
{
    XNBCollectionViewSectionObject *sectionObj = [self.sectionArray xnb_safeObjectAtIndex:indexPath.section];
    id item = [sectionObj.items xnb_safeObjectAtIndex:indexPath.row];
    
    return item;
}

@end
