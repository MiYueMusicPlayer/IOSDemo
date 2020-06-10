//
//  EquipmentListViewController.m
//  MiYue
//
//  Created by 黄天宇 on 2019/7/4.
//  Copyright © 2019 黄天宇. All rights reserved.
//

#import "EquipmentListViewController.h"
#import "HomeTabBarViewController.h"

@interface EquipmentListViewController ()


//完整数据
@property (nonatomic,strong) NSString *completeStr;

//完整数据model
@property (nonatomic,strong) ReturnBodyModel *completeModel;

@property (nonatomic,strong) UITextField *text;


@end

@implementation EquipmentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //背景色
    self.view.backgroundColor = BACKGROUNDCOLOR;
    
    self.completeStr = @"";
    
    self.text = [UITextField new];
    self.text.backgroundColor = [UIColor whiteColor];
    self.text.placeholder = @"输入ip进行连接";
    [self.view addSubview:self.text];
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.mas_offset(50);
        make.top.equalTo(self.view).with.offset(100);
    }];
    
    UIButton *btn = [UIButton new];
    [btn addTarget:self action:@selector(connection) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"连接" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_offset(50);
        make.width.mas_offset(200);
        make.top.equalTo(self.text.mas_bottom).with.offset(10);
    }];
    
}

-(void)connection{
    __weak typeof(self) weakSelf = self;
    
    [[GeneralSocket shareInstance] connectToServerWithHostStr:self.text.text];
    
    [GeneralSocket shareInstance].ConnectionBlock = ^(NSInteger index) {
        if (index == 1){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                            //跳转主界面
                HomeTabBarViewController *vc = [[HomeTabBarViewController alloc] init];
                [UIView beginAnimations:@"View Flip"context:nil];
                [UIView setAnimationDuration:0.5];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                [weakSelf.navigationController pushViewController:vc animated:YES];
                [UIView commitAnimations];
            });
            
        }else if (index == 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showOnlyTextToView:weakSelf.view title:@"连接失败"];
            });
        }
    };
}


@end
