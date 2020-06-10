//
//  SongInternalViewController.m
//  MiYue
//
//  Created by 黄天宇 on 2019/7/17.
//  Copyright © 2019 黄天宇. All rights reserved.
//

#import "SongInternalViewController.h"
#import "songTableViewCell.h"
#import "HomeTabBarViewController.h"

@interface SongInternalViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

//列表
@property (nonatomic,strong) UITableView *ListTableView;

//完整数据
@property (nonatomic,strong) NSString *completeStr;

//暂存完整数据model
@property (nonatomic,strong) ReturnBodyModel *temporaryModel;

//完整数据model
@property (nonatomic,strong) ReturnBodyModel *completeModel;


@end

@implementation SongInternalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置左侧返回按钮
    [self.leftBtn setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
    
    //设置导航栏背景色
    self.naviView.backgroundColor = [UIColor colorWithHexString:@"131525"];
    
    //初始化数据
    self.completeStr = @"";
    self.completeModel = [[ReturnBodyModel alloc]init];
    
    //背景颜色
    self.view.backgroundColor = BACKGROUNDCOLOR;
    
    //添加tableview
    [self.view addSubview:self.ListTableView];
    
    //请求数据
    [self getListInfomation];
    
}

#pragma mark - 页面出现
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

#pragma mark - 请求歌单内数据列表
-(void)getListInfomation{
    //将请求接口转化成data
    NSDictionary *requestDic = @{@"action":@"action.request.boardMusicInfos",@"id":_idStr};
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
            if ([weakSelf.temporaryModel.action isEqualToString:@"action.request.boardMusicInfos"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.temporaryModel.result == 200) {
                        NSMutableArray *arr = [NSMutableArray array];
                        for (NSDictionary *dic in weakSelf.temporaryModel.infos) {
                            MusicModel *radioModel = [MusicModel yy_modelWithDictionary:dic];
                            [arr addObject:radioModel];
                        }
                        weakSelf.temporaryModel.infos = arr;
                        
                        weakSelf.completeModel = weakSelf.temporaryModel;
                        
                        [weakSelf.ListTableView reloadData];
                    }else{
                        [MBProgressHUD showOnlyTextToView:weakSelf.view title:@"请求失败"];
                    }
                });
            }
        }
        
    };
    
}

#pragma mark 懒加载
-(UITableView *)ListTableView{
    if (!_ListTableView) {
        _ListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - 80*WIDTH_SCALE)];
        _ListTableView.delegate = self;
        _ListTableView.dataSource = self;
        _ListTableView.emptyDataSetSource = self;
        _ListTableView.emptyDataSetDelegate = self;
        [_ListTableView registerClass:[songTableViewCell class] forCellReuseIdentifier:@"songTableViewCell"];
        _ListTableView.backgroundColor = BACKGROUNDCOLOR;
        _ListTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _ListTableView.rowHeight = UITableViewAutomaticDimension;
        _ListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _ListTableView;
}

#pragma mark tableview的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.completeModel.infos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80*WIDTH_SCALE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = @"songTableViewCell";
    songTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[songTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //设置状态
    cell.isEdit = 0;
    
    cell.musicModel = self.completeModel.infos[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self replaceAllModel:self.completeModel.infos Index:indexPath.row];
}

#pragma mark 替换当前播放列表
-(void)replaceAllModel:(NSMutableArray *)musicArray Index:(NSInteger)index{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (MusicModel *model in musicArray) {
        [arr addObject:[self JSONStringToDictionaryWithData:[model yy_modelToJSONData]]];
    }
    __weak typeof(self) weakSelf = self;
    //将请求接口转化成data
    NSDictionary *requestDic = @{@"action":@"action.request.music",@"infos":arr,@"musicIndex":[NSString stringWithFormat:@"%ld",(long)index]};
    
    //发送请求
    [[GeneralSocket shareInstance] sendMessage:requestDic];
    
}

#pragma mark 空白页的代理
//图片
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"pic_no_collect"];
}

//重试按钮
-(NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    // 设置按钮标题
    NSString *buttonTitle = @"该歌单没有歌曲哟!";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:15*WIDTH_SCALE],
                                 NSForegroundColorAttributeName:NOTEXTCOLOR
                                 };
    return [[NSAttributedString alloc] initWithString:buttonTitle attributes:attributes];
}

//重试按钮点击事件
-(void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    //请求数据
    [self getListInfomation];
}

-(void)emptyDataSetWillAppear:(UIScrollView *)scrollView{
    self.ListTableView.contentOffset = CGPointZero;
}
#pragma mark json转字典
-(NSDictionary *) JSONStringToDictionaryWithData:(NSData *)data{
    NSError * error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    return dict;
}

@end
