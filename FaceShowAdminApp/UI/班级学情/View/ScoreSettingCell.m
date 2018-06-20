//
//  ScoreSettingCell.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ScoreSettingCell.h"

@interface ScoreSettingCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UIImageView *enterImageView;
@end

@implementation ScoreSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.enterImageView.image = [UIImage imageNamed:@"进入页面按钮点击态"];
    }
    else{
        self.enterImageView.image = [UIImage imageNamed:@"进入页面按钮正常态"];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    self.enterImageView = [[UIImageView alloc]init];
    self.enterImageView.image = [UIImage imageNamed:@"进入页面按钮正常态"];
    [self.contentView addSubview:self.enterImageView];
    [self.enterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.mas_equalTo(0);
    }];
    self.scoreLabel = [[UILabel alloc]init];
    self.scoreLabel.font = [UIFont systemFontOfSize:14];
    self.scoreLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.scoreLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.scoreLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.enterImageView.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(0);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    // mock mock
    self.titleLabel.text = @"评价";
    self.scoreLabel.text = @"16";
}

@end
