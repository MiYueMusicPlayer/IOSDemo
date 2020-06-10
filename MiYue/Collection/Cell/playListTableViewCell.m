//
//  playListTableViewCell.m
//  MiYue
//
//  Created by 黄天宇 on 2019/7/8.
//  Copyright © 2019 黄天宇. All rights reserved.
//

#import "playListTableViewCell.h"

@interface playListTableViewCell ()

//歌单图片
@property (nonatomic,strong) UIImageView *listImage;

//更多操作
@property (nonatomic,strong) UIButton *moreBtn;

//歌单名称
@property (nonatomic,strong) UILabel *nameLabel;

//歌曲数量
@property (nonatomic,strong) UILabel *numLabel;

@end

@implementation playListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        //背景颜色
        self.backgroundColor = BACKGROUNDCOLOR;
        
        //线
        UILabel *line = [UILabel new];
        line.backgroundColor = LINECOLOR;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_offset(.5*WIDTH_SCALE);
        }];
        
        //歌单图片
        self.listImage = [UIImageView new];
        [self addSubview:self.listImage];
        [self.listImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_offset(44*WIDTH_SCALE);
            make.left.equalTo(self).with.offset(20*WIDTH_SCALE);
            make.centerY.equalTo(self);
        }];
        
        //更多操作
        self.moreBtn = [UIButton new];
        [self.moreBtn setImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
//        [self.moreBtn addTarget:self action:@selector(clickMore:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.moreBtn];
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_offset(30*WIDTH_SCALE);
            make.centerY.equalTo(self);
            make.right.equalTo(self).with.offset(-15*WIDTH_SCALE);
        }];
        
        //歌单名称
        self.nameLabel = [UILabel new];
        self.nameLabel.font = [UIFont systemFontOfSize:17*WIDTH_SCALE];
        self.nameLabel.textColor = TEXTCOLOR;
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.listImage.mas_right).with.offset(12*WIDTH_SCALE);
            make.right.equalTo(self.moreBtn.mas_left).with.offset(-30*WIDTH_SCALE);
            make.top.equalTo(self).with.offset(19*WIDTH_SCALE);
            make.height.mas_offset(21*WIDTH_SCALE);
        }];
        
        //歌曲数量
        self.numLabel = [UILabel new];
        self.numLabel.font = [UIFont systemFontOfSize:14*WIDTH_SCALE];
        self.numLabel.textColor = [UIColor colorWithHexString:@"9DA1AF"];
        [self addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self.nameLabel);
            make.bottom.equalTo(self).with.offset(-18*WIDTH_SCALE);
            make.height.mas_offset(18*WIDTH_SCALE);
        }];
        
        
    }
    return self;
}

#pragma mark 配置数据
-(void)setPlayModel:(SongListModel *)playModel{
    
    _playModel = playModel;
    
    [self.listImage setImage:[UIImage imageNamed:@"icon_default_song_list"]];
    
    self.nameLabel.text = playModel.songlistTitle;
    
    self.numLabel.text = [NSString stringWithFormat:@"共%ld首歌曲",(long)playModel.songNum];
    
}

#pragma mark 点击更多
-(void)clickMore:(UIButton *)sender{
    self.ClickMoreBlock(_playModel);
}

-(void)setType:(NSInteger)type{
    if (type == 2) {
        self.moreBtn.hidden = YES;
    }
}

@end
