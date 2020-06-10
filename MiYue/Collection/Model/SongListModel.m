//
//  SongListModel.m
//  MiYue
//
//  Created by 黄天宇 on 2019/7/9.
//  Copyright © 2019 黄天宇. All rights reserved.
//

#import "SongListModel.h"

@implementation SongListModel

- (NSString *)description {
    return [self yy_modelDescription];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    //前面是model中的名字,后面是json中的名字
    return @{@"idField":@"id"};
}

@end
