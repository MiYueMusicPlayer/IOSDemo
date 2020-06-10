//
//  MusicModel.h
//  MiYue
//
//  Created by 黄天宇 on 2019/7/9.
//  Copyright © 2019 黄天宇. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MusicModel : NSObject

@property (nonatomic, strong) NSString * album;
@property (nonatomic, assign) NSInteger collectTime;
@property (nonatomic, assign) NSInteger dataSrc;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) NSString * fileName;
@property (nonatomic, strong) NSString * fileUrl;
@property (nonatomic, assign) NSInteger isNetUrl;
@property (nonatomic, strong) NSString * singer;
@property (nonatomic, strong) NSString * size;
@property (nonatomic, assign) NSInteger songListId;
@property (nonatomic, assign) NSInteger songSrc;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * year;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * pic;
@property (nonatomic, strong) NSString * songId;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isPlaying;

@end

NS_ASSUME_NONNULL_END
