//
//  XNBBaseViewController.m
//  XNBasicViewController
//
//  Created by 江红胡 on 2017/9/30.
//

#import "XNBBaseViewController.h"
#import "UIColor+XNB.h"
#import "NSString+XNB.h"
#import "UIFont+XNB.h"
#import "ALView+PureLayout.h"
#import "NSMutableArray+XNB.h"

@interface XNBBaseViewController ()

@property (nonatomic, strong) NSMutableArray *models;

@property (nonatomic, assign) BOOL isDefaultBackBtn;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSLayoutConstraint *activityViewConstraint;

@end


@implementation XNBBaseViewController

- (void)dealloc
{
    if (_models) {
        [_models enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[XNBBaseRequestModel class]]) {
                [(XNBBaseRequestModel *)obj cancel];
            }
        }];
    }
    [_models removeAllObjects];
    _models = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor xnb_colorForKey:@"ffffff"];
    self.edgesForExtendedLayout = UIRectEdgeAll;
}

// 通用式返回操作
- (void)backToLastViewController
{
    if (self.navigationController && self.navigationController.viewControllers.count > 0 && self.navigationController.viewControllers.firstObject != self.navigationController.topViewController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] init];
//        _activityIndicatorView.hidesWhenStopped = YES;
        [self.view addSubview:_activityIndicatorView];
        [self.view bringSubviewToFront:_activityIndicatorView];
        [_activityIndicatorView autoAlignAxisToSuperviewAxis:ALAxisVertical];
//        [_activityIndicatorView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        self.activityViewConstraint = [_activityIndicatorView autoAlignAxis:ALAxisHorizontal
                                                           toSameAxisOfView:self.view
                                                                 withOffset:0];
    }
    
    return _activityIndicatorView;
}

@end


@implementation XNBBaseViewController (NavigationBar)

- (void)setNavBarTitle:(NSString *)title textColor:(UIColor *)textColor fontSize:(CGFloat)font
{
    if ([title xnb_nilOrEmpty]) {
        self.navigationItem.titleView = nil;
    } else {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = textColor;
        titleLabel.font = [UIFont xnb_normalFontOfSize:font];
        titleLabel.text = title;
        [titleLabel sizeToFit];
        
        self.navigationItem.titleView = titleLabel;
    }
}

- (void)setNavBarTitle:(UIImage *)titleImage
{
    if (titleImage) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, titleImage.size.width, titleImage.size.height)];
        imageView.image = titleImage;
        
        self.navigationItem.titleView = imageView;
    } else {
        self.navigationItem.titleView = nil;
    }
}

- (void)setNavBarLeftItem:(NSString *)title textColor:(UIColor *)textColor
{
    if ([title xnb_nilOrEmpty]) {
        return;
    }
    
    self.isDefaultBackBtn = NO;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 60, 20);
    [leftButton setTitle:title forState:UIControlStateNormal];
    [leftButton setTitleColor:textColor forState:UIControlStateNormal];
    [leftButton.titleLabel setFont:[UIFont xnb_normalFontOfSize:15]];
    [leftButton addTarget:self action:@selector(onPressedLeftBarItem) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setNavBarRightItem:(NSString *)title textColor:(UIColor *)textColor
{
    if ([title xnb_nilOrEmpty]) {
        return;
    }
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 60, 20);
    [rightButton setTitle:title forState:UIControlStateNormal];
    [rightButton setTitleColor:textColor forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont xnb_normalFontOfSize:15]];
    [rightButton addTarget:self action:@selector(onPressedRightBarItem) forControlEvents:UIControlEventTouchUpInside];
    [rightButton sizeToFit];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setNavBarLeftItem:(UIImage *)normalImage hightedImage:(UIImage *)hightedImage
{
    self.isDefaultBackBtn = NO;
    
    CGSize buttonSize = CGSizeMake(24.f, 24.f);
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, buttonSize.width, buttonSize.height);
    [leftButton setImage:normalImage forState:UIControlStateNormal];
    [leftButton setImage:hightedImage forState:UIControlStateHighlighted];
    leftButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [leftButton addTarget:self action:@selector(onPressedLeftBarItem) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setNavBarRightItem:(UIImage *)normalImage hightedImage:(UIImage *)hightedImage
{
    CGSize buttonSize = CGSizeMake(24.f, 24.f);
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, buttonSize.width, buttonSize.height);
    [rightButton setImage:normalImage forState:UIControlStateNormal];
    [rightButton setImage:hightedImage forState:UIControlStateHighlighted];
    rightButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [rightButton addTarget:self action:@selector(onPressedRightBarItem) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setDefaultBackBarItem
{
    self.isDefaultBackBtn = YES;
   
}

- (void)onPressedBackBarButton
{
    [self backToLastViewController];
}

- (void)onPressedLeftBarItem
{}

- (void)onPressedRightBarItem
{}

@end


@implementation XNBBaseViewController (Loading)

- (BOOL)isPageLoading
{
    return self.activityIndicatorView.isAnimating;
}

- (void)showCommonLoading
{
    [self showCommonLoading:XNBViewControllerLoadingTypeNormal];
}

- (void)showCommonLoading:(XNBViewControllerLoadingType)loadingType {
    [self showCommonLoading:loadingType offsetY:0];
}

- (void)showCommonLoading:(XNBViewControllerLoadingType)loadingType offsetY:(CGFloat)offsetY
{
    [self.view bringSubviewToFront:self.activityIndicatorView];
    self.activityViewConstraint.constant = offsetY;
    [self.activityIndicatorView startAnimating];
    
    switch (loadingType) {
        case XNBViewControllerLoadingTypeFullScreen:
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            break;
        case XNBViewControllerLoadingTypeView:
            self.view.userInteractionEnabled = NO;
            break;
        default:
            break;
    }
}

- (void)dismissLoading
{
    [self.view sendSubviewToBack:self.activityIndicatorView];
    [self.activityIndicatorView stopAnimating];
    
    self.view.userInteractionEnabled = YES;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

@end


@implementation XNBBaseViewController (Network)

- (XNBBaseRequestModel *)produceModel:(Class)modelClass
{
    XNBBaseRequestModel *reqModel = [[modelClass alloc] init];
    if (reqModel) {
        [self.models xnb_safeAddObject:reqModel];
    }
    
    __weak typeof(self) weakSelf = self;
    [reqModel setCompletionBlock:^(id<XNBRequestModelProtocol> model) {
        XNBBaseRequestModel *xncashcatModel = (XNBBaseRequestModel *)model;
        if (xncashcatModel && [xncashcatModel requestDataSuccess]) {
            [weakSelf handleDataModelSuccess:xncashcatModel];
        } else {
            // 网络错误
            if (xncashcatModel.errorType == XNBRequestErrorTypeNetwork) {
                [self handleNetworkError:xncashcatModel];
            } else {
                [weakSelf handleDataModelError:xncashcatModel];
            }
        }
    }];
    
    return reqModel;
}

- (void)handleDataModelSuccess:(XNBBaseRequestModel *)xncashcatModel
{}

- (void)handleDataModelError:(XNBBaseRequestModel *)xncashcatModel
{}

- (void)handleNetworkError:(XNBBaseRequestModel *)xncashcatModel
{}

@end

