//
//  CacheWriteAndRead.h
//  MiYue
//
//  Created by 黄天宇 on 2019/7/24.
//  Copyright © 2019 黄天宇. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ReadCacheBlock)(NSMutableArray * _Nullable infoArr);

typedef void(^ReadDicCacheBlock)(NSDictionary * _Nullable infoDic);

NS_ASSUME_NONNULL_BEGIN

@interface CacheWriteAndRead : NSObject

+(instancetype)shareInstance;

//缓存
-(void)writeCacheArray:(NSMutableArray *)array Type:(NSString *)type;
-(void)writeCacheDic:(NSDictionary *)dic Type:(NSString *)type;
//缓存设备信息
-(void)writeEquipCacheArray:(NSMutableArray *)array;

//读取缓存
-(void)readCacheType:(NSString *)type;
-(void)readCacheDicType:(NSString *)type;

//清除缓存
-(void)delteCache:(NSString *)key;

//返回缓存block
@property (copy, nonatomic) ReadCacheBlock ReadCacheBlock;
@property (copy, nonatomic) ReadDicCacheBlock ReadDicCacheBlock;

@end

NS_ASSUME_NONNULL_END
