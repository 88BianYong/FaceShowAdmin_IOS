//
//  TrainingProjectCell.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "TrainingProjectCell.h"

@interface TrainingProjectCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation TrainingProjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
    }];
    self.bottomLine = [[UIView alloc]init];
    self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"d7dde0"];
    [self.contentView addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(1);
    }];
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
}

- (void)setLineHidden:(BOOL)lineHidden {
    _lineHidden = lineHidden;
    self.bottomLine.hidden = lineHidden;
}

@end
