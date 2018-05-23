//
//  XNBBaseNavigationController.m
//  XNBasicViewController
//
//  Created by 江红胡 on 2017/10/9.
//

#import "XNBBaseNavigationController.h"

@interface XNBBaseNavigationController ()

@end


@implementation XNBBaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.transferNavigationBarAttributes = YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
