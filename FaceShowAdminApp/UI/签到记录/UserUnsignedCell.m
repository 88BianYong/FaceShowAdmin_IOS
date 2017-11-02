//
//  UserUnsignedCell.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserUnsignedCell.h"

@interface UserUnsignedCell()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@end

@implementation UserUnsignedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    self.phoneLabel = [[UILabel alloc]init];
    self.phoneLabel.font = [UIFont systemFontOfSize:14];
    self.phoneLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.phoneLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    UIButton *signButton = [[UIButton alloc]init];
    [signButton setTitle:@"补签" forState:UIControlStateNormal];
    [signButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    signButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [signButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:signButton];
    [signButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.bottom.mas_equalTo(0);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"dce0e3"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)btnAction {
    BLOCK_EXEC(self.signBlock);
}

- (void)setData:(UserSignInListRequestItem_elements *)data {
    _data = data;
    self.nameLabel.text = data.userName;
    self.phoneLabel.text = data.mobilePhone;
}

@end
