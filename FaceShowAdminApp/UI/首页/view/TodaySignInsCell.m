//
//  TodaySignInsCell.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/10/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TodaySignInsCell.h"
@interface TodaySignInsCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *signInsLabel;
@property (nonatomic, strong) UILabel *signInsRateLabel;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation TodaySignInsCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.contentView addSubview:self.titleLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.timeLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.contentView addSubview:self.timeLabel];
    
    self.signInsLabel = [[UILabel alloc] init];
    self.signInsLabel.textColor = [UIColor colorWithHexString:@"0068bd"];
    self.signInsLabel.font = [UIFont boldSystemFontOfSize:12.0];
    self.signInsLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.signInsLabel];
    
    self.signInsRateLabel = [[UILabel alloc] init];
    self.signInsRateLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.signInsRateLabel.font = [UIFont systemFontOfSize:11.0f];
    self.signInsRateLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.signInsRateLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:self.lineView];
}
- (void)setupLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-1.0f);
        make.right.mas_equalTo(-100);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7.0f);
    }];
    
    [self.signInsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    
    [self.signInsRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.centerY.equalTo(self.timeLabel.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(1.0f);
    }];
}
#pragma mark - set
- (void)setTodySignIns:(ClazsGetClazsRequestItem_Data_TodaySignIns *)todySignIns {
    _todySignIns = todySignIns;
    self.titleLabel.text = _todySignIns.title;
    NSArray *startArr = [_todySignIns.startTime componentsSeparatedByString:@" "];
    NSString *startDate = startArr.firstObject;
    startDate = [startDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *startTime = startArr.lastObject;
    startTime = [startTime substringToIndex:5];
    NSArray *endArr = [_todySignIns.endTime componentsSeparatedByString:@" "];
    NSString *endDate = endArr.firstObject;
    endDate = [endDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *endTime = endArr.lastObject;
    endTime = [endTime substringToIndex:5];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@ - %@",startDate,startTime,endTime];
    NSString *signInsString = [NSString stringWithFormat:@"已签到: %@/%@",_todySignIns.signInUserNum,_todySignIns.totalUserNum];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:signInsString];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"],NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} range:NSMakeRange(0, 4)];
    self.signInsLabel.attributedText = attrStr;
    self.signInsRateLabel.text = [NSString stringWithFormat:@"签到率%0.0f%%",_todySignIns.signInUserNum.floatValue/_todySignIns.totalUserNum.floatValue * 100];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
