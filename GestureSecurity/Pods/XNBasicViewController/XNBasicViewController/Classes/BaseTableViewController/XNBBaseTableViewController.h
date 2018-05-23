//
//  XNBBaseTableViewController.h
//  XNBasicViewController
//
//  Created by 江红胡 on 2017/10/9.
//

#import "XNBBaseViewController.h"
#import "XNBBaseTableViewCell.h"
#import "MJRefreshHeader.h"
#import "MJRefreshAutoFooter.h"
#import "XNBTableViewSectionObject.h"
#import "XNBBaseCellItem.h"

@protocol XNBBaseTableViewDelegate <UITableViewDelegate>

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


@interface XNBBaseTableViewController : XNBBaseViewController
<XNBBaseTableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MJRefreshHeader *refreshHeader;

@property (nonatomic, strong) MJRefreshFooter *refreshFooter;

#pragma mark - Property
// tableview数据源
@property (nonatomic, strong) NSMutableArray *sectionArray;

// 选中索引
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

// 是否需要下拉刷新
@property (nonatomic, assign) BOOL needPullDownRefresh;

// 是否需要上拉加载更多
@property (nonatomic, assign) BOOL needPullUpLoadMore;

#pragma mark - Method
// 初始化TableView的style
- (instancetype)initWithStyle:(UITableViewStyle)style;

// 初始化Cell类型
+ (Class)cellClsForCellItem:(id)item;

// 配置cell的回调
- (void)configForCell:(XNBBaseTableViewCell *)cell item:(id)item;

@end
