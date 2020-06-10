//
//  CacheWriteAndRead.m
//  MiYue
//
//  Created by 黄天宇 on 2019/7/24.
//  Copyright © 2019 黄天宇. All rights reserved.
//

#import "CacheWriteAndRead.h"
@interface CacheWriteAndRead ()

//缓存主体
@property (nonatomic,strong) YYCache *cache;

@end

@implementation CacheWriteAndRead

static CacheWriteAndRead *_MyCacheWriteAndRead = nil;

#pragma mark 单例加载
+(instancetype)shareInstance{
    if (_MyCacheWriteAndRead == nil) {
        _MyCacheWriteAndRead = [[CacheWriteAndRead alloc] init];
    }
    return _MyCacheWriteAndRead;
}

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        if (!_cache) {
            //初始化缓存主体
            _cache = [YYCache cacheWithName:@"allLocalMusic"];
        }
    }
    return self;
}

#pragma mark 清除缓存
-(void)delteCache:(NSString *)key{
    [_cache removeObjectForKey:key];
}

#pragma mark 缓存
-(void)writeCacheArray:(NSMutableArray *)array Type:(NSString *)type{
    // 异步缓存
    __weak typeof(self) weakSelf = self;
    [_cache setObject:array forKey:type withBlock:^{
        // 异步回调
        NSLog(@"%@", [NSThread currentThread]);
        NSLog(@"array缓存完成....");
        
        if ([type isEqualToString:@"collectRadio"]) {
            [weakSelf sendCollectMessage:1];
        }
    }];
}

#pragma mark 缓存设备信息
-(void)writeEquipCacheArray:(NSMutableArray *)array{
    // 异步缓存
    [_cache setObject:array forKey:@"equipment" withBlock:^{
        NSLog(@"设备信息缓存完成....");
    }];
}

-(void)writeCacheDic:(NSDictionary *)dic Type:(NSString *)type{
    // 异步缓存
    [_cache setObject:dic forKey:type withBlock:^{
        // 异步回调
        NSLog(@"%@", [NSThread currentThread]);
        NSLog(@"array缓存完成....");
    }];
}

#pragma mark 读取缓存
-(void)readCacheType:(NSString *)type{
    // 异步读取
    [_cache objectForKey:type withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
        // 异步回调
        NSLog(@"%@", [NSThread currentThread]);
        NSLog(@"%@", object);
        self.ReadCacheBlock((NSMutableArray *)object);
    }];
}

-(void)readCacheDicType:(NSString *)type{
    // 异步读取
    [_cache objectForKey:type withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
        // 异步回调
        NSLog(@"%@", [NSThread currentThread]);
        NSLog(@"%@", object);
        self.ReadDicCacheBlock((NSDictionary *)object);
    }];
}

-(void)sendCollectMessage:(NSInteger)type{
    NSString *dic = [NSString stringWithFormat:@"%ld",(long)type];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"collectList" object:dic];
}

@end
