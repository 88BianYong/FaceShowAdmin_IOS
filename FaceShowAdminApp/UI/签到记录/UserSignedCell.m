//
//  UserSignedCell.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserSignedCell.h"

@interface UserSignedCell()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation UserSignedCell

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
        make.top.mas_equalTo(10);
    }];
    self.phoneLabel = [[UILabel alloc]init];
    self.phoneLabel.font = [UIFont systemFontOfSize:11];
    self.phoneLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.contentView addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(4);
    }];
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
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

- (void)setData:(UserSignInListRequestItem_elements *)data {
    _data = data;
    self.nameLabel.text = data.userName;
    self.phoneLabel.text = data.mobilePhone;
    
    NSArray *startArr = [data.signInTime componentsSeparatedByString:@" "];
    NSString *startDate = startArr.firstObject;
    startDate = [startDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *startTime = startArr.lastObject;
    startTime = [startTime substringToIndex:5];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",startDate,startTime];
}

@end
