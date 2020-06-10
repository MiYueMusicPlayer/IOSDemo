//
//  GeneralSocket.m
//  MiYue
//
//  Created by 黄天宇 on 2019/7/4.
//  Copyright © 2019 黄天宇. All rights reserved.
//

#import "GeneralSocket.h"
#import <MediaPlayer/MediaPlayer.h>

@interface GeneralSocket ()<GCDAsyncSocketDelegate>

@property (nonatomic,strong) GCDAsyncSocket *socket;

//完整数据
@property (nonatomic,strong) NSString *completeStr;

//暂存返回数据
@property (nonatomic,strong) NSString *temporaryStr;

//音量界面
@property (nonatomic,strong) MPVolumeView *volumeView;

@end

@implementation GeneralSocket

static GeneralSocket *_mySocket = nil;

#pragma mark 单例加载
+(instancetype)shareInstance{
    if (_mySocket == nil) {
        _mySocket = [[GeneralSocket alloc] init];
    }
    return _mySocket;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mySocket = [super allocWithZone:zone];
    });
    return _mySocket;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        self.completeStr = @"";
        self.temporaryStr = @"";
    }
    return self;
}

#pragma mark 连接服务器
-(void)connectToServerWithHostStr:(NSString *)host{
    
    NSError *error = nil;
    [_socket connectToHost:host onPort:60001 withTimeout:5 error:&error];
    
    if (error) {
        NSLog(@"_connect error:%@",error.userInfo);
    }
    
}

#pragma mark 断开服务器
-(void)disconnect{
    [_socket disconnect];
}

#pragma mark 判断是否连接
-(BOOL)distinguishIsConnect{
    return _socket.isConnected;
}

#pragma mark 读取数据
-(void)readMessage{
    Byte byte[] = {10,11,12,13};
    NSData *byteData = [[NSData alloc]initWithBytes:byte length:4];
    [self.socket readDataToData:byteData withTimeout:-1 tag:0];
}

#pragma mark 发送数据给服务端
-(void)sendMessage:(NSDictionary *)dic{
    //dic转化成data
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *str  = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSMutableString *nsstrmutable = [[NSMutableString alloc] initWithString:str];
    [nsstrmutable replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,nsstrmutable.length)];
    NSData *data = [nsstrmutable dataUsingEncoding:NSUTF8StringEncoding];
    //增加byte数组
    Byte byte[] = {10,11,12,13};
    NSData *byteData = [[NSData alloc]initWithBytes:byte length:4];
    //发送请求
    [self.socket writeData:data withTimeout:-1 tag:0];
    [self.socket writeData:byteData withTimeout:-1 tag:0];
    
    //接收数据
    [self.socket readDataToData:byteData withTimeout:-1 tag:0];
}

#pragma mark - Socket Delegate
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    self.ConnectionBlock(1);
    Byte byte[] = {10,11,12,13};
    NSData *byteData = [[NSData alloc]initWithBytes:byte length:4];
    [self.socket readDataToData:byteData withTimeout:-1 tag:0];
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    if (err) {
        self.ConnectionBlock(0);
    }else{
        self.ConnectionBlock(2);
    }
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    //解析数据
    NSString *str  = [data convertedToUtf8String];
    
    [self handleInfo:str];
    
    [self readMessage];
    
}

#pragma mark 处理黏包数据
-(void)handleInfo:(NSString *)infoStr{
    NSMutableString *nsstrmutable = [[NSMutableString alloc] initWithString:infoStr];
    [nsstrmutable replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,nsstrmutable.length)];
    [nsstrmutable replaceOccurrencesOfString:@"\r" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,nsstrmutable.length)];
    [nsstrmutable replaceOccurrencesOfString:@"\v" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,nsstrmutable.length)];
    [nsstrmutable replaceOccurrencesOfString:@"\f" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,nsstrmutable.length)];
    [nsstrmutable replaceOccurrencesOfString:@"�" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,nsstrmutable.length)];
    [nsstrmutable replaceOccurrencesOfString:@"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,nsstrmutable.length)];
    
    if ([nsstrmutable containsString:@"action.response.playerposition"]) {
        Byte byte[] = {10,11,12,13};
        NSData *byteData = [[NSData alloc]initWithBytes:byte length:4];
        [self.socket readDataToData:byteData withTimeout:-1 tag:0];
        return;
    }
        
    //发送数据的block
    self.InfomationBlock(nsstrmutable);
        
    Byte byte[] = {10,11,12,13};
    NSData *byteData = [[NSData alloc]initWithBytes:byte length:4];
    [self.socket readDataToData:byteData withTimeout:-1 tag:0];
        
}

@end
