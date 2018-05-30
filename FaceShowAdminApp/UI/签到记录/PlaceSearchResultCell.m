//
//  PlaceSearchResultCell.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/5/29.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "PlaceSearchResultCell.h"

@interface PlaceSearchResultCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation PlaceSearchResultCell

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
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(8);
        make.right.mas_equalTo(-15);
    }];
    self.subtitleLabel = [[UILabel alloc]init];
    self.subtitleLabel.font = [UIFont systemFontOfSize:12];
    self.subtitleLabel.textColor = [UIColor colorWithHexString:@"cccccc"];
    [self.contentView addSubview:self.subtitleLabel];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(6);
        make.right.mas_equalTo(-15);
    }];
    self.selectImageView = [[UIImageView alloc]init];
    self.selectImageView.image = [UIImage imageNamed:@"点击"];
    [self.contentView addSubview:self.selectImageView];
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    self.bottomLine = [[UIView alloc]init];
    self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setPoiInfo:(BMKPoiInfo *)poiInfo {
    _poiInfo = poiInfo;
    self.titleLabel.text = poiInfo.name;
    self.subtitleLabel.text = [NSString stringWithFormat:@"%@%@",poiInfo.city,poiInfo.address];
}

- (void)setIsCurrent:(BOOL)isCurrent {
    _isCurrent = isCurrent;
    self.selectImageView.hidden = !isCurrent;
}

- (void)setKeyword:(NSString *)keyword {
    _keyword = keyword;
    NSString *pattern = [NSString stringWithFormat:@"[%@]*",keyword];
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSArray *array = [reg matchesInString:self.titleLabel.text options:NSMatchingReportCompletion range:NSMakeRange(0, self.titleLabel.text.length)];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:self.titleLabel.text];
    for (NSTextCheckingResult *result in array) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0068bd"] range:result.range];
    }
    self.titleLabel.attributedText = attrStr;
}
@end
