//
//  HomeTabBarViewController.m
//  MiYue
//
//  Created by 黄天宇 on 2019/7/5.
//  Copyright © 2019 黄天宇. All rights reserved.
//

#import "HomeTabBarViewController.h"
#import "BaseNaviViewController.h"
#import "CollectionBaseViewController.h"

@interface HomeTabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation HomeTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化控制器页面
    [self initAndAddViewController];
    
    //配置
    self.view.backgroundColor = [UIColor clearColor];
    self.tabBar.alpha = 1.0;
    
    //设置tabbar的颜色
    [[UITabBar appearance] setBarTintColor:BACKGROUNDCOLOR];
    [UITabBar appearance].translucent = NO;
    
    //设置字体颜色
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TEXTCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:10*WIDTH_SCALE]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TEXTCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:10*WIDTH_SCALE]} forState:UIControlStateSelected];
    
    self.tabBar.backgroundColor = [UIColor blackColor];
    self.delegate = self;
    
    //播放进度通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(again:) name:@"again" object:nil];
    
}

#pragma mark 当前连接设备失去连接
-(void)again:(NSNotification *)noti{
    //allin表示是否是全选按钮
    NSString *info = [noti object];
    
    if ([info isEqualToString:@"1"]) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提醒" message:@"当前连接设备失去连接,请重新连接,或连接其他设备!" preferredStyle:UIAlertControllerStyleAlert];
            
            //默认只有标题 没有操作的按钮:添加操作的按钮 UIAlertAction
            UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"tiao"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }];
            //将action添加到控制器
            [alertVc addAction:albumAction];
            //展示
            [weakSelf presentViewController:alertVc animated:YES completion:nil];
        });
    }
    
}

#pragma mark 禁止滑动手势
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self popGestureClose:self];
}

#pragma mark 打开滑动手势
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self popGestureOpen:self];
}

#pragma mark 初始化控制器页面
-(void)initAndAddViewController
{
    
    CollectionBaseViewController *collectionVC = [[CollectionBaseViewController alloc] init];
    [self addViewController:collectionVC withImage:@"tab_icon_collect" WithSelectImage:@"tab_icon_collect_select" WithTitle:@"收藏"];
    
}

#pragma mark 添加控制器方法
-(void)addViewController:(UIViewController *)viewController withImage:(NSString *)imageName WithSelectImage:(NSString *)selectImage WithTitle:(NSString *)title {
    
    viewController.title = title;
    
    UIImage *tempImage = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    viewController.tabBarItem.image = tempImage;
    
    UIImage *selectTempImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = selectTempImage;
    
    BaseNaviViewController *navi = [[BaseNaviViewController alloc]initWithRootViewController:viewController];
    
    [self addChildViewController:navi];
    
}

#pragma mark 代理方法
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSLog(@"%lu",(unsigned long)tabBarController.selectedIndex);
}

-(void)popGestureClose:(UIViewController *)VC
{
    // 禁用侧滑返回手势
    if ([VC.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //这里对添加到右滑视图上的所有手势禁用
        for (UIGestureRecognizer *popGesture in VC.navigationController.interactivePopGestureRecognizer.view.gestureRecognizers) {
            popGesture.enabled = NO;
        }
    }
}

-(void)popGestureOpen:(UIViewController *)VC
{
    // 启用侧滑返回手势
    if ([VC.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //这里对添加到右滑视图上的所有手势启用
        for (UIGestureRecognizer *popGesture in VC.navigationController.interactivePopGestureRecognizer.view.gestureRecognizers) {
            popGesture.enabled = YES;
        }
    }
}

@end
