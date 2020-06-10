//
//  BaseViewController.m
//  CommandSystem
//
//  Created by hty on 2019/5/24.
//  Copyright © 2019 Mac1. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    //导航栏
    self.naviView = [UIView new];
    self.naviView.userInteractionEnabled = YES;
    self.naviView.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_offset(NAVIGATION_BAR_HEIGHT);
    }];
    
    //左侧按钮
    self.leftBtn = [UIButton new];
    [self.leftBtn addTarget:self action:@selector(didClickLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn setImage:[UIImage imageNamed:@"base_back"] forState:UIControlStateNormal];
    [self.naviView addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(35*WIDTH_SCALE);
        make.height.mas_offset(NAVIGATION_BAR_HEIGHT - StateBarHeight);
        make.left.equalTo(self.naviView).with.offset(3);
        make.top.equalTo(self.naviView).with.offset(StateBarHeight);
    }];
    
    //右侧按钮
    self.rightBtn = [UIButton new];
    [self.rightBtn addTarget:self action:@selector(didClickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(40*WIDTH_SCALE);
        make.height.mas_offset(NAVIGATION_BAR_HEIGHT - StateBarHeight);
        make.right.equalTo(self.naviView).with.offset(-13*WIDTH_SCALE);
        make.top.equalTo(self.naviView).with.offset(StateBarHeight);
    }];
    
    //标题
    self.titleLable = [UILabel new];
    self.titleLable.textColor = [UIColor colorWithHexString:@"FFFFFF"];
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    self.titleLable.font = [UIFont systemFontOfSize:18*WIDTH_SCALE];
    [self.naviView addSubview:self.titleLable];
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.naviView).with.offset(50*WIDTH_SCALE);
        make.height.mas_offset(NAVIGATION_BAR_HEIGHT - StateBarHeight);
        make.top.equalTo(self.naviView).with.offset(StateBarHeight);
        make.width.mas_offset(SCREEN_WIDTH - 100);
    }];
    
}

#pragma mark 隐藏系统的navigationbar
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark 返回
-(void)didClickLeftBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 右侧点击事件
-(void)didClickRightBtn:(UIButton *)sender{
    
}


@end
