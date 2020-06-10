//
//  playListTableViewCell.h
//  MiYue
//
//  Created by 黄天宇 on 2019/7/8.
//  Copyright © 2019 黄天宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongListModel.h"

typedef void(^ClickMoreBlock)(SongListModel *playModel);

NS_ASSUME_NONNULL_BEGIN

@interface playListTableViewCell : UITableViewCell

//歌单数据
@property (nonatomic,strong) SongListModel *playModel;

//点击更多block
@property (copy, nonatomic) ClickMoreBlock ClickMoreBlock;

//type(2选择提示音)
@property (nonatomic,assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
