//
//  RadioViewController.h
//  MiYue
//
//  Created by 黄天宇 on 2019/7/5.
//  Copyright © 2019 黄天宇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickPromptBlock)(NSString *playlistId,NSInteger type,NSString *listName);

NS_ASSUME_NONNULL_BEGIN

@interface RadioViewController : UIViewController<JXCategoryListCollectionContentViewDelegate>

//传导控制器
@property (nonatomic,strong) UINavigationController *navi;

//type(2选择提示音)
@property (nonatomic,assign) NSInteger type;

//回传ID block
@property (copy, nonatomic) ClickPromptBlock ClickPromptBlock;

@end

NS_ASSUME_NONNULL_END
