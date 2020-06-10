//
//  PlaylistViewController.m
//  MiYue
//
//  Created by 黄天宇 on 2019/7/5.
//  Copyright © 2019 黄天宇. All rights reserved.
//

#import "PlaylistViewController.h"
#import "playListTableViewCell.h"
#import "SongListModel.h"
#import "SongInternalViewController.h"

@interface PlaylistViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

//歌单列表
@property (nonatomic,strong) UITableView *playListTableView;

//完整数据
@property (nonatomic,strong) NSString *completeStr;

//暂存完整数据model
@property (nonatomic,strong) ReturnBodyModel *temporaryModel;

//完整数据model
@property (nonatomic,strong) ReturnBodyModel *completeModel;

@end

@implementation PlaylistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化数据
    self.completeStr = @"";
    
    //背景颜色
    self.view.backgroundColor = BACKGROUNDCOLOR;
    
    //添加tableview
    [self.view addSubview:self.playListTableView];
    
    self.playListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getListInfomation];
    }];
    
}

#pragma mark - 请求歌单的列表
-(void)getListInfomation{
    //将请求接口转化成data
    NSDictionary *requestDic = @{@"action":@"action.request.collectedSonglist"};
    //发送请求
    [[GeneralSocket shareInstance] sendMessage:requestDic];
    //接收数据
    __weak typeof(self) weakSelf = self;
    [GeneralSocket shareInstance].InfomationBlock = ^(NSMutableString *str) {
        if ([str isEqualToString:@"-1"]) {
            return;
        }
        
        weakSelf.completeStr = [NSString stringWithFormat:@"%@%@",weakSelf.completeStr,str];
        
        weakSelf.temporaryModel = [ReturnBodyModel yy_modelWithJSON:weakSelf.completeStr];
        
        if (weakSelf.temporaryModel != nil) {
            weakSelf.completeStr = @"";
            if ([weakSelf.temporaryModel.action isEqualToString:@"action.request.collectedSonglist"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.temporaryModel.result == 200) {
                        NSMutableArray *arr = [NSMutableArray array];
                        for (NSDictionary *dic in weakSelf.temporaryModel.infos) {
                            SongListModel *playModel = [SongListModel yy_modelWithDictionary:dic];
                            [arr addObject:playModel];
                        }
                        weakSelf.temporaryModel.infos = arr;
                        
                        weakSelf.completeModel = weakSelf.temporaryModel;
                        
                        [weakSelf.playListTableView reloadData];
                    }else{
                        [MBProgressHUD showOnlyTextToView:weakSelf.view title:@"请求失败"];
                    }
                });
            }
        }
        
    };
    
    //结束刷新
    [self.playListTableView.mj_header endRefreshing];
    
}

#pragma mark - JXCategoryListCollectionContentViewDelegate
- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    //请求数据
    [self getListInfomation];
}

- (void)listDidDisappear {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

#pragma mark 懒加载
-(UITableView *)playListTableView{
    if (!_playListTableView) {
        _playListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - 50*WIDTH_SCALE)];
        _playListTableView.delegate = self;
        _playListTableView.dataSource = self;
        _playListTableView.emptyDataSetSource = self;
        _playListTableView.emptyDataSetDelegate = self;
        [_playListTableView registerClass:[playListTableViewCell class] forCellReuseIdentifier:@"playListTableViewCell"];
        _playListTableView.backgroundColor = BACKGROUNDCOLOR;
        _playListTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _playListTableView.rowHeight = UITableViewAutomaticDimension;
        _playListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _playListTableView;
}

#pragma mark tableview的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.completeModel.infos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80*WIDTH_SCALE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = @"playListTableViewCell";
    playListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[playListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.playModel = self.completeModel.infos[indexPath.row];
    
    if (self.type == 2) {
        cell.type = 2;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SongInternalViewController *songVc = [[SongInternalViewController alloc]init];
    songVc.idStr = [NSString stringWithFormat:@"%ld",(long)[self.completeModel.infos[indexPath.row] idField]];
    [self.navi pushViewController:songVc animated:YES];
}

#pragma mark 空白页的代理
//图片
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"pic_no_collect"];
}

//重试按钮
-(NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    // 设置按钮标题
    NSString *buttonTitle = @"没有收藏癖的你，去哪里找回忆";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:15*WIDTH_SCALE],
                                 NSForegroundColorAttributeName:NOTEXTCOLOR
                                 };
    return [[NSAttributedString alloc] initWithString:buttonTitle attributes:attributes];
}

//重试按钮点击事件
-(void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    [self getListInfomation];
}

-(void)emptyDataSetWillAppear:(UIScrollView *)scrollView{
    self.playListTableView.contentOffset = CGPointZero;
}

@end
