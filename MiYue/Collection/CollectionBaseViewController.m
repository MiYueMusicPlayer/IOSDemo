//
//  CollectionBaseViewController.m
//  MiYue
//
//  Created by 黄天宇 on 2019/7/5.
//  Copyright © 2019 黄天宇. All rights reserved.
//

#import "CollectionBaseViewController.h"
#import "JXCategoryView.h"
#import "JXCategoryListCollectionContainerView.h"
#import "SongViewController.h"
#import "PlaylistViewController.h"
#import "RadioViewController.h"

@interface CollectionBaseViewController ()<JXCategoryViewDelegate,JXCategoryListCollectionContainerViewDataSource>

//导航指示
@property (nonatomic,strong) JXCategoryTitleView *categoryView;

//联动表
@property (nonatomic,strong) JXCategoryListCollectionContainerView *listContainerView;

@end

@implementation CollectionBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //标题
    self.titleLable.text = @"收藏";
    
    //设置颜色
    self.view.backgroundColor = BACKGROUNDCOLOR;
    
    //创建UI
    [self create_UI];
    
}

#pragma mark 懒加载
-(JXCategoryTitleView *)categoryView{
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 50*WIDTH_SCALE)];
        _categoryView.delegate = self;
    }
    return _categoryView;
}

#pragma mark 懒加载联动表
-(JXCategoryListCollectionContainerView *)listContainerView{
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListCollectionContainerView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT + 50*WIDTH_SCALE, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - 50*WIDTH_SCALE - TAB_BAR_HEIGHT)];
        _listContainerView.dataSource = self;
    }
    return _listContainerView;
}

#pragma mark 创建UI
-(void)create_UI {
    
    [self.view addSubview:self.categoryView];
    
    //设置总体颜色
    self.categoryView.backgroundColor = BACKGROUNDCOLOR;
    
    //配置titleview的属性
    self.categoryView.titles = @[@"歌曲",@"歌单",@"电台"];
    //关闭颜色渐变
    self.categoryView.titleColorGradientEnabled = YES;
    //设置字体颜色
    self.categoryView.titleColor = [UIColor colorWithHexString:@"8A8EA8"];
    self.categoryView.titleSelectedColor = TEXTCOLOR;
    self.categoryView.titleFont = [UIFont systemFontOfSize:16*WIDTH_SCALE];
    
    //添加指示器
    JXCategoryIndicatorImageView *lineView = [[JXCategoryIndicatorImageView alloc] init];
    //指示器的颜色
    lineView.indicatorImageView.image = [UIImage imageNamed:@"icon_at_present"];
    //指示器的宽度
    lineView.indicatorImageViewSize = CGSizeMake(46*WIDTH_SCALE, 12*WIDTH_SCALE);
    self.categoryView.indicators = @[lineView];
    
    //初始化联动表
    [self.view addSubview:self.listContainerView];
    //关联cotentScrollView，关联之后才可以互相联动！！！
    self.categoryView.contentScrollView = self.listContainerView.collectionView;
    
}

#pragma mark JXCategoryListContainerViewDelegate代理方法
-(NSInteger)numberOfListsInlistContainerView:(JXCategoryListCollectionContainerView *)listContainerView{
    return 3;
}

-(id<JXCategoryListCollectionContentViewDelegate>)listContainerView:(JXCategoryListCollectionContainerView *)listContainerView initListForIndex:(NSInteger)index{
    if (index == 0) {
        SongViewController *SongVC = [[SongViewController alloc] init];
        SongVC.navi = self.navigationController;
        return SongVC;
    }else if (index == 1) {
        PlaylistViewController *PlaylistVC = [[PlaylistViewController alloc] init];
        PlaylistVC.navi = self.navigationController;
        return PlaylistVC;
    }else {
        RadioViewController *RadioVC = [[RadioViewController alloc] init];
        RadioVC.navi = self.navigationController;
        return RadioVC;
    }
}

-(void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index{
    
}

@end
