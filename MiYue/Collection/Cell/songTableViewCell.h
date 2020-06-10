//
//  songTableViewCell.h
//  MiYue
//
//  Created by 黄天宇 on 2019/7/9.
//  Copyright © 2019 黄天宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"

typedef void(^ClickMoreBlock)(MusicModel *musicModel);

NS_ASSUME_NONNULL_BEGIN

@interface songTableViewCell : UITableViewCell

//编辑状态
@property (nonatomic,assign) NSInteger isEdit;

//歌曲数据
@property (nonatomic,strong) MusicModel *musicModel;

//点击更多block
@property (copy, nonatomic) ClickMoreBlock ClickMoreBlock;

//选中按钮
@property (nonatomic,strong) UIButton *selectBtn;

@end

NS_ASSUME_NONNULL_END
