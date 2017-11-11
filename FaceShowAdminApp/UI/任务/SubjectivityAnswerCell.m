//
//  SubjectivityAnswerCell.m
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SubjectivityAnswerCell.h"

@interface SubjectivityAnswerCell ()
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation SubjectivityAnswerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *bottomLine = [[UIView alloc]init];
    self.bottomLine = bottomLine;
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"d7dde0"];
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(20);
    }];
    self.commentLabel = [[UILabel alloc]init];
    self.commentLabel.font = [UIFont systemFontOfSize:14];
    self.commentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.commentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(8);
    }];
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.commentLabel.mas_left);
        make.top.mas_equalTo(self.commentLabel.mas_bottom).mas_offset(20);
        make.bottom.mas_equalTo(-30);
    }];
}

- (void)setBottomLineHidden:(BOOL)bottomLineHidden {
    _bottomLineHidden = bottomLineHidden;
    self.bottomLine.hidden = bottomLineHidden;
}

- (void)setItem:(GetsubjectivityAnswer_Element *)item {
    _item = item;
    self.nameLabel.text = item.userName;
    NSString *comment = item.answer;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:comment attributes:dic];
    self.commentLabel.attributedText = attributeStr;
#warning 主观题回复缺少发布时间
    self.timeLabel.text = [self dateStringFromOriString:nil];
}

- (NSString *)dateStringFromOriString:(NSString *)oriStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:oriStr];
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:self.currentTime.doubleValue/1000];
    NSTimeInterval interval = [currentDate timeIntervalSinceDate:date];
    if (interval >= 24*60*60) {
        NSString *displayStr = [oriStr stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        displayStr = [displayStr substringToIndex:displayStr.length-3];
        return displayStr;
    }else if (interval < 60) {
        return @"刚刚";
    }else if (interval < 60*60) {
        NSInteger min = interval/60;
        return [NSString stringWithFormat:@"%@分钟前",@(min)];
    }else {
        NSInteger hour = interval/60/60;
        return [NSString stringWithFormat:@"%@小时前",@(hour)];
    }
}

@end
