//
//  GeneralSocket.h
//  MiYue
//
//  Created by 黄天宇 on 2019/7/4.
//  Copyright © 2019 黄天宇. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ConnectionBlock)(NSInteger index);

typedef void(^InfomationBlock)(NSMutableString * _Nullable str);

NS_ASSUME_NONNULL_BEGIN

@interface GeneralSocket : NSObject

//是否改变音量
@property (nonatomic,assign) BOOL isChange;

+(instancetype)shareInstance;

//连接服务器
-(void)connectToServerWithHostStr:(NSString *)host;

//断开服务器
-(void)disconnect;

//判断是否连接
-(BOOL)distinguishIsConnect;

//读取数据
-(void)readMessage;

//发送数据给服务端
-(void)sendMessage:(NSDictionary *)dic;

//连接成功block
@property (copy, nonatomic) ConnectionBlock ConnectionBlock;

//返回数据block
@property (copy, nonatomic) InfomationBlock InfomationBlock;

@end

NS_ASSUME_NONNULL_END
