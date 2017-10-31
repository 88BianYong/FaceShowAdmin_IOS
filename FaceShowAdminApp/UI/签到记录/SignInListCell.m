//
//  SignInListCell.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SignInListCell.h"

@interface SignInListCell()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *rateLabel;
@end

@implementation SignInListCell

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
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(18);
    }];
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(7);
    }];
    self.countLabel = [[UILabel alloc]init];
    self.countLabel.font = [UIFont systemFontOfSize:12];
    self.countLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.countLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(20);
    }];
    self.rateLabel = [self.timeLabel clone];
    self.rateLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.rateLabel];
    [self.rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.countLabel.mas_right);
        make.top.mas_equalTo(self.countLabel.mas_bottom).mas_offset(7);
    }];
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setData:(SignInListRequestItem_signIns *)data {
    _data = data;
    self.nameLabel.text = data.title;
    
    NSArray *startArr = [data.startTime componentsSeparatedByString:@" "];
    NSString *startDate = startArr.firstObject;
    startDate = [startDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *startTime = startArr.lastObject;
    startTime = [startTime substringToIndex:5];
    NSArray *endArr = [data.endTime componentsSeparatedByString:@" "];
    NSString *endDate = endArr.firstObject;
    endDate = [endDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *endTime = endArr.lastObject;
    endTime = [endTime substringToIndex:5];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@ - %@",startDate,startTime,endTime];
    
    NSString *count = [NSString stringWithFormat:@"%@/%@",data.signInUserNum,data.totalUserNum];
    NSString *complete = [NSString stringWithFormat:@"已签到：%@",count];
    NSRange range = [complete rangeOfString:count];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0068bd"]};
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:complete];
    [attrStr addAttributes:dic range:range];
    self.countLabel.attributedText = attrStr;
    
    NSString *rate = [NSString stringWithFormat:@"签到率：%.0f%@",data.percent.floatValue*100,@"%"];
    self.rateLabel.text = rate;
}

@end
