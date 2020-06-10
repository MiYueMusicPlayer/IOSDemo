//
//  radioTableViewCell.h
//  MiYue
//
//  Created by 黄天宇 on 2019/7/9.
//  Copyright © 2019 黄天宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface radioTableViewCell : UITableViewCell

//电台数据
@property (nonatomic,strong) MusicModel *musicModel;

//type(2选择提示音)
@property (nonatomic,assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
