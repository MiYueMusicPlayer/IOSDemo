//
//  listTableViewCell.h
//  MiYue
//
//  Created by 黄天宇 on 2019/7/9.
//  Copyright © 2019 黄天宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface listTableViewCell : UITableViewCell

//榜单数据
@property (nonatomic,strong) ListModel *listModel;

//更多操作
@property (nonatomic,strong) UIButton *moreBtn;

//type
@property (nonatomic,assign) NSInteger type;

//名字
@property (nonatomic,copy) NSString *name;

//types(2选择提示音)
@property (nonatomic,assign) NSInteger types;


@end

NS_ASSUME_NONNULL_END
