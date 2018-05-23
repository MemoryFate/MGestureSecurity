//
//  XNBBaseTableViewController.m
//  XNBasicViewController
//
//  Created by 江红胡 on 2017/10/9.
//

#import "XNBBaseTableViewController.h"
#import "NSMutableArray+XNB.h"
#import "NSArray+XNB.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"

@interface XNBBaseTableViewController ()

@property (nonatomic, assign) UITableViewStyle tableViewStyle;

@end


@implementation XNBBaseTableViewController

#pragma mark - Life Circle
- (void)dealloc
{
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super init]) {
        _tableViewStyle = style;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}

- (void)setupTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.tableViewStyle];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.sectionHeaderHeight = 0.f;
    self.tableView.sectionFooterHeight = 0.f;
    
    [self.view addSubview:self.tableView];
}

#pragma mark - TableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    XNBTableViewSectionObject *sectionObj = [self.sectionArray xnb_safeObjectAtIndex:section];
    return sectionObj.items.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    XNBTableViewSectionObject *sectionObj = [self.sectionArray xnb_safeObjectAtIndex:section];
    return sectionObj.headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    XNBTableViewSectionObject *sectionObj = [self.sectionArray xnb_safeObjectAtIndex:section];
    return sectionObj.footerTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    XNBTableViewSectionObject *sectionObj = [self.sectionArray xnb_safeObjectAtIndex:section];
    if (sectionObj.headerHeight != 0.0f) {
        return sectionObj.headerHeight;
    }
    return tableView.sectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    XNBTableViewSectionObject *sectionObj = [self.sectionArray xnb_safeObjectAtIndex:section];
    if (sectionObj.footerHeight != 0.0f) {
        return sectionObj.footerHeight;
    }
    return tableView.sectionFooterHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self getItemAtIndexPath:indexPath];
    Class cellCls = [[self class] cellClsForCellItem:item];
    if ([cellCls isSubclassOfClass:[XNBBaseTableViewCell class]]) {
        return [cellCls heightForCellItem:item];
    }
    
    return self.tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cellItem = [self getItemAtIndexPath:indexPath];
    Class cls = [[self class] cellClsForCellItem:cellItem];
    NSString *cellID = [NSString stringWithFormat:@"%@_%@", NSStringFromClass([cellItem class]), NSStringFromClass(cls)];
    
    XNBBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[cls alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [self configForCell:cell item:cellItem];
    [cell setCellItem:cellItem];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    
    id cellItem = [self getItemAtIndexPath:indexPath];
    XNBTableViewSectionObject *secionObj = [self.sectionArray xnb_safeObjectAtIndex:indexPath.section];
    
    if (([cellItem isKindOfClass:[XNBBaseCellItem class]] && ((XNBBaseCellItem *)cellItem).didSelectSelector.length) || secionObj.didSelectSelector.length) {
        NSString *itemSelectorString = ((XNBBaseCellItem *)cellItem).didSelectSelector.length ? ((XNBBaseCellItem *)cellItem).didSelectSelector : @"";
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
                
                if (self.selectedIndexPath) {
                    [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
                }
            }
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    XNBTableViewSectionObject *sectionObj = [self.sectionArray xnb_safeObjectAtIndex:section];
    if (sectionObj.headerView) {
        return sectionObj.headerView;
    } else {
        UIView *sectionView = [[UIView alloc] init];
        sectionView.backgroundColor = [UIColor clearColor];
        
        return sectionView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    XNBTableViewSectionObject *sectionObj = [self.sectionArray xnb_safeObjectAtIndex:section];
    if (sectionObj.footerView) {
        return sectionObj.footerView;
    } else {
        UIView *sectionView = [[UIView alloc] init];
        sectionView.backgroundColor = [UIColor clearColor];
        
        return sectionView;
    }
}

#pragma mark - Refresh & Load More...
- (void)setNeedPullDownRefresh:(BOOL)isNeedPullDownRefresh
{
    _needPullDownRefresh = isNeedPullDownRefresh;
    if (_needPullDownRefresh) {
        if (!_refreshHeader) {
            self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownToRefreshAction)];
        }
        
        self.tableView.mj_header = self.refreshHeader;
    } else {
        [self.tableView.mj_header removeFromSuperview];
    }
}

- (void)setNeedPullUpLoadMore:(BOOL)isNeedPullUpLoadMore
{
    _needPullUpLoadMore = isNeedPullUpLoadMore;
    if (_needPullUpLoadMore) {
        if (!_refreshFooter) {
            self.refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpToRefreshAction)];
        }
        
        self.tableView.mj_footer = self.refreshFooter;
    } else {
        [self.tableView.mj_footer removeFromSuperview];
    }
}

- (void)pullDownToRefreshAction
{}

- (void)pullUpToRefreshAction
{}

#pragma mark - Config
+ (Class)cellClsForCellItem:(id)item
{
    return [XNBBaseTableViewCell class];
}

- (void)configForCell:(XNBBaseTableViewCell *)cell item:(id)item
{
    
}

#pragma marj - Others
- (id)getItemAtIndexPath:(NSIndexPath *)indexPath
{
    XNBTableViewSectionObject *sectionObj = [self.sectionArray xnb_safeObjectAtIndex:indexPath.section];
    id item = [sectionObj.items xnb_safeObjectAtIndex:indexPath.row];
    return item;
}

@end
