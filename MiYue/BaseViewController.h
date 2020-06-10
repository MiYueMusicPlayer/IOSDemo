//
//  BaseViewController.h
//  CommandSystem
//
//  Created by hty on 2019/5/24.
//  Copyright © 2019 Mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

//左侧按钮
@property (nonatomic, strong) UIButton *leftBtn;

//右侧按钮
@property (nonatomic, strong) UIButton *rightBtn;

//标题
@property (nonatomic, strong) UILabel *titleLable;

//导航栏
@property (nonatomic,strong) UIView *naviView;

-(void)didClickLeftBtn:(UIButton *)sender;

-(void)didClickRightBtn:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
