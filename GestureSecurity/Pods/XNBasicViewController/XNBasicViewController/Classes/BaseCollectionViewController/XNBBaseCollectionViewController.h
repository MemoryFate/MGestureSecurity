//
//  XNBBaseCollectionViewController.h
//  XNBasicViewController
//
//  Created by 江红胡 on 2017/10/9.
//

#import "XNBBaseViewController.h"
#import "XNBBaseCollectionViewCell.h"
#import "XNBBaseCollectionCellItem.h"
#import "XNBCollectionViewSectionObject.h"
#import "MJRefreshHeader.h"
#import "MJRefreshFooter.h"

@protocol XNBBaseCollectionViewDelegate <UICollectionViewDelegate>

@optional
/**
 * 下拉刷新触发的方法
 */
- (void)pullDownToRefreshAction;

/**
 * 上拉刷新触发的方法
 */
- (void)pullUpToRefreshAction;

@end


@interface XNBBaseCollectionViewController : XNBBaseViewController
<UICollectionViewDataSource, XNBBaseCollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) MJRefreshHeader *refreshHeader;

@property (nonatomic, strong) MJRefreshFooter *refreshFooter;

#pragma mark - Property
// CollectionView数据源
@property (nonatomic, strong) NSMutableArray *sectionArray;

// 是否需要下拉刷新
@property (nonatomic, assign) BOOL needPullDownRefresh;

// 是否需要上拉加载更多
@property (nonatomic, assign) BOOL needPullUpLoadMore;

// 一行有几列,默认两列
@property (nonatomic, assign) NSInteger columnNumber;

#pragma mark - Method

// 初始化Cell类型
+ (Class)cellClsForCellItem:(id)item;

// 配置cell的回调
- (void)configForCell:(XNBBaseCollectionViewCell *)cell item:(id)item;

@end
