//
//  ListModel.h
//  MiYue
//
//  Created by 黄天宇 on 2019/7/9.
//  Copyright © 2019 黄天宇. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListModel : NSObject

@property (nonatomic, assign) NSInteger collectTime;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger dataSrc;
@property (nonatomic, strong) NSString * descriptionField;
@property (nonatomic, strong) NSString * iconUrl;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) BOOL isCollected;
@property (nonatomic, assign) NSInteger songNum;
@property (nonatomic, strong) NSString * songlistId;
@property (nonatomic, assign) NSInteger songlistSrc;
@property (nonatomic, strong) NSString * songlistTitle;
@property (nonatomic, strong) NSString * wangyiUpdateTime;
@property (nonatomic, strong) NSMutableArray *songDetail;

@end

NS_ASSUME_NONNULL_END
