//
//  ViewController.m
//  GestureSecurity
//
//  Created by MemoryFate on 2018/5/5.
//  Copyright © 2018年 MemoryFate. All rights reserved.
//

#import "ViewController.h"
#import "MGestureSecurityView.h"

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MGestureSecurityView *view = [[MGestureSecurityView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    view.center = self.view.center;
    [self.view addSubview: view];
    
    UILabel *showCode = [UILabel newAutoLayoutView];
    [self.view addSubview: showCode];
    [showCode autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:50];
    [showCode autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [showCode autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [showCode autoSetDimension:ALDimensionHeight toSize:40];
    showCode.font = [UIFont systemFontOfSize:25];
    showCode.textColor = [UIColor blackColor];
    showCode.textAlignment = NSTextAlignmentCenter;
    
    view.didFinishBlock = ^(NSString *str) {
        showCode.text = str;
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
