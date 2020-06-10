//
//  radioTableViewCell.m
//  MiYue
//
//  Created by 黄天宇 on 2019/7/9.
//  Copyright © 2019 黄天宇. All rights reserved.
//

#import "radioTableViewCell.h"

@interface radioTableViewCell ()

//电台图片
@property (nonatomic,strong) UIImageView *radioImage;

//更多操作
@property (nonatomic,strong) UIButton *moreBtn;

//电台名称
@property (nonatomic,strong) UILabel *nameLabel;

//主播
@property (nonatomic,strong) UILabel *hostLabel;

@end

@implementation radioTableViewCell

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
        
        //歌曲图片
        self.radioImage = [UIImageView new];
        [self addSubview:self.radioImage];
        [self.radioImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_offset(44*WIDTH_SCALE);
            make.left.equalTo(self).with.offset(20*WIDTH_SCALE);
            make.centerY.equalTo(self);
        }];
        
        //更多操作
        self.moreBtn = [UIButton new];
        [self.moreBtn setImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
        [self addSubview:self.moreBtn];
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_offset(30*WIDTH_SCALE);
            make.centerY.equalTo(self);
            make.right.equalTo(self).with.offset(-15*WIDTH_SCALE);
        }];
        
        //歌曲名称
        self.nameLabel = [UILabel new];
        self.nameLabel.font = [UIFont systemFontOfSize:17*WIDTH_SCALE];
        self.nameLabel.textColor = TEXTCOLOR;
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.radioImage.mas_right).with.offset(12*WIDTH_SCALE);
            make.right.equalTo(self.moreBtn.mas_left).with.offset(-30*WIDTH_SCALE);
            make.top.equalTo(self).with.offset(19*WIDTH_SCALE);
            make.height.mas_offset(21*WIDTH_SCALE);
        }];
        
        //歌手
        self.hostLabel = [UILabel new];
        self.hostLabel.font = [UIFont systemFontOfSize:14*WIDTH_SCALE];
        self.hostLabel.textColor = [UIColor colorWithHexString:@"9DA1AF"];
        [self addSubview:self.hostLabel];
        [self.hostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self.nameLabel);
            make.bottom.equalTo(self).with.offset(-18*WIDTH_SCALE);
            make.height.mas_offset(18*WIDTH_SCALE);
        }];
        
    }
    return self;
}

#pragma mark 配置数据
-(void)setMusicModel:(MusicModel *)musicModel{
    
    _musicModel = musicModel;
    
    [self.radioImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",musicModel.pic]] placeholderImage:[UIImage imageNamed:@"icon_default_song"]];
    
    self.nameLabel.text = musicModel.title;
    
    self.hostLabel.text = musicModel.singer;
    
}

-(void)setType:(NSInteger)type{
    if (type == 2) {
        self.moreBtn.hidden = YES;
    }
}

@end
