//
//  BaseNaviViewController.m
//  MiYue
//
//  Created by 黄天宇 on 2019/7/5.
//  Copyright © 2019 黄天宇. All rights reserved.
//

#import "BaseNaviViewController.h"

@interface BaseNaviViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //隐藏系统自带的navibar
    self.navigationBar.hidden = YES;
    self.interactivePopGestureRecognizer.enabled = YES;
    self.interactivePopGestureRecognizer.delegate = (id)self;
    
}

#pragma mark 手势代理
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.viewControllers.count == 1) {
        return NO;
    }else{
        return YES;
    }
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:YES];
}


@end
