//
//  ReturnBodyModel.h
//  MiYue
//
//  Created by 黄天宇 on 2019/7/8.
//  Copyright © 2019 黄天宇. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReturnBodyModel : NSObject

@property (nonatomic, strong) NSString * action;
@property (nonatomic, strong) NSString * pauseTime;
@property (nonatomic, strong) NSMutableArray * infos;
@property (nonatomic, assign) NSInteger result;
@property (nonatomic, assign) NSInteger flag;

@end

NS_ASSUME_NONNULL_END
