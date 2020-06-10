//
//  SongViewController.h
//  MiYue
//
//  Created by 黄天宇 on 2019/7/5.
//  Copyright © 2019 黄天宇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SongViewController : UIViewController<JXCategoryListCollectionContentViewDelegate>

//传导控制器
@property (nonatomic,strong) UINavigationController *navi;

@end

NS_ASSUME_NONNULL_END
