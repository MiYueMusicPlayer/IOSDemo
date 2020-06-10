//
//  RadioViewController.m
//  MiYue
//
//  Created by 黄天宇 on 2019/7/5.
//  Copyright © 2019 黄天宇. All rights reserved.
//

#import "RadioViewController.h"
#import "MusicModel.h"
#import "radioTableViewCell.h"

@interface RadioViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

//完整数据
@property (nonatomic,strong) NSString *completeStr;

//暂存完整数据model
@property (nonatomic,strong) ReturnBodyModel *temporaryModel;

//完整数据model
@property (nonatomic,strong) ReturnBodyModel *completeModel;

//电台列表
@property (nonatomic,strong) UITableView *radioTableView;

@end

@implementation RadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化数据
    self.completeStr = @"";
    
    //背景颜色
    self.view.backgroundColor = BACKGROUNDCOLOR;
    
    //添加tableview
    [self.view addSubview:self.radioTableView];
    
    self.radioTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getListInfomation];
    }];
    
}

#pragma mark - 请求收藏电台列表
-(void)getListInfomation{
    //将请求接口转化成data
    NSDictionary *requestDic = @{@"action":@"action.request.collectedRadios"};
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
            if ([weakSelf.temporaryModel.action isEqualToString:@"action.request.collectedRadios"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.temporaryModel.result == 200) {
                        NSMutableArray *arr = [NSMutableArray array];
                        for (NSDictionary *dic in weakSelf.temporaryModel.infos) {
                            MusicModel *radioModel = [MusicModel yy_modelWithDictionary:dic];
                            [arr addObject:radioModel];
                        }
                        weakSelf.temporaryModel.infos = arr;
                        
                        weakSelf.completeModel = weakSelf.temporaryModel;
                        
                        //缓存
                        [[CacheWriteAndRead shareInstance]writeCacheArray:arr Type:@"collectRadio"];
                        
                        [weakSelf.radioTableView reloadData];
                        
                    }else{
                        [MBProgressHUD showOnlyTextToView:weakSelf.view title:@"请求失败"];
                    }
                });
            }
        }
        
    };
    
    //结束刷新
    [self.radioTableView.mj_header endRefreshing];
    
}

#pragma mark 懒加载
-(UITableView *)radioTableView{
    if (!_radioTableView) {
        _radioTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - 50*WIDTH_SCALE)];
        _radioTableView.delegate = self;
        _radioTableView.dataSource = self;
        _radioTableView.emptyDataSetSource = self;
        _radioTableView.emptyDataSetDelegate = self;
        [_radioTableView registerClass:[radioTableViewCell class] forCellReuseIdentifier:@"radioTableViewCell"];
        _radioTableView.backgroundColor = BACKGROUNDCOLOR;
        _radioTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _radioTableView.rowHeight = UITableViewAutomaticDimension;
        _radioTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _radioTableView;
}

#pragma mark tableview的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.completeModel.infos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80*WIDTH_SCALE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = @"radioTableViewCell";
    radioTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[radioTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.musicModel = self.completeModel.infos[indexPath.row];
    
    if (self.type == 2) {
        cell.type = 2;
    }
    
    return cell;
}

#pragma mark 替换当前播放列表
-(void)replaceAllModel:(NSMutableArray *)musicArray Index:(NSInteger)index{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (MusicModel *model in musicArray) {
        [arr addObject:[self JSONStringToDictionaryWithData:[model yy_modelToJSONData]]];
    }
    //将请求接口转化成data
    NSDictionary *requestDic = @{@"action":@"action.request.music",@"infos":arr,@"musicIndex":[NSString stringWithFormat:@"%ld",(long)index]};
    //发送请求
    [[GeneralSocket shareInstance] sendMessage:requestDic];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self replaceAllModel:self.completeModel.infos Index:indexPath.row];
    
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
    self.radioTableView.contentOffset = CGPointZero;
}

#pragma mark json转字典
-(NSDictionary *) JSONStringToDictionaryWithData:(NSData *)data{
    NSError * error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    return dict;
}


@end
